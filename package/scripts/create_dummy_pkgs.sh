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

for arch in i386 amd64 noarch
do
  echo $arch
  rm -fr /var/tmp/fpm/dummy-$arch/src
  mkdir -p /var/tmp/fpm/dummy-$arch/src
  cd /var/tmp/fpm/dummy-$arch/
  echo "dummy package for arch $arch" > src/README-${arch}.md
  fpm -t deb -s dir --name dummy-package --version 0.0.1 --architecture $arch --maintainer "<rls-team@acme.com>" --description "dummy package arch $arch" --prefix /var/tmp/dummy -C src .
  aptly repo add $REPO /var/tmp/fpm/dummy-$arch/dummy-package*deb
  aptly publish update $DISTRIBUTION $REPO
done
