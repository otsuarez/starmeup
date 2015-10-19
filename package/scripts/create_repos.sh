#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  exit 1
fi

REPO=$1

if ! which fpm > /dev/null
then
  echo "Please install fpm"
  exit 0
fi

if aptly repo list -raw | grep -q "${REPO}"
then
  echo "Repository already exists"
  # exit 0
fi

for env in testing staging prod
do
  aptly repo create -comment="${REPO} Environment Repository" -component="acme" -distribution="acme-${env}" ${REPO}
done

for arch in i386 amd64 noarch
do
  echo $arch
  rm -fr /var/tmp/fpm/dummy-$arch/src
  mkdir -p /var/tmp/fpm/dummy-$arch/src
  cd /var/tmp/fpm/dummy-$arch/
  echo "dummy package for arch $arch" > src/README-${arch}.md
  fpm -t deb -s dir --name dummy-package --version 0.0.1 --architecture $arch --maintainer "<rls-team@acme.com>" --description "dummy package arch $arch" --prefix /var/tmp/dummy -C src .
  aptly repo add $REPO /var/tmp/fpm/dummy-$arch/dummy-package*deb
  aptly publish update acme-$REPO $REPO
done

#for env in testing staging prod
#do
#  aptly publish -component="acme" -distribution="acme-${env}" -architectures="noarch,i386,amd64"  repo ${REPO} ${REPO}
#done

#echo "
#Now you can add following lines to apt sources:
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-testing acme
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-staging acme
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-prod acme
#Don't forget to add your GPG key to apt with apt-key.
#"


#aptly publish  -architectures="noarch,amd64,i386" update acme-prod prod-conf


