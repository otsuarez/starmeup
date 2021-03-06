#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  exit 1
fi

REPO=$1
DISTRIBUTION_SUFFIX=$(echo $REPO | sed 's/-conf//')
DISTRIBUTION="acme-${DISTRIBUTION_SUFFIX}"

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

aptly repo create -architectures="noarch,i386,amd64" -comment="${REPO} Environment Repository" -component="acme" -distribution="${DISTRIBUTION}" ${REPO}
#aptly publish -architectures="amd64,i386,noarch" repo ${REPO} ${REPO}

for arch in i386 amd64 noarch
do
  echo $arch
  rm -fr /var/tmp/fpm/dummy-$arch/src
  mkdir -p /var/tmp/fpm/dummy-$arch/src
  cd /var/tmp/fpm/dummy-$arch/
  echo "dummy package for arch $arch" > src/README-${arch}.md
  fpm -t deb -s dir --name dummy-package --version 0.0.1 --architecture $arch --maintainer "<rls-team@acme.com>" --description "dummy package arch $arch" --prefix /var/tmp/dummy -C src .
  aptly repo add $REPO /var/tmp/fpm/dummy-$arch/dummy-package*deb
  #aptly publish update $DISTRIBUTION $REPO
done

#Now you can add following lines to apt sources:
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-testing acme
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-staging acme
#  deb http://jenkins.acme.com/apt/${REPO}/ acme-prod acme
#Don't forget to add your GPG key to apt with apt-key.

