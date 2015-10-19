#!/bin/bash

SCRIPTS_DIR="/home/osvaldo/src/acme/github/pkg-scripts/octopush"
PI="${SCRIPTS_DIR}/preinst.sh"
PR="${SCRIPTS_DIR}/prerm.sh"
TR="${SCRIPTS_DIR}/postrm.sh"
TI="${SCRIPTS_DIR}/postinst.sh"
SCRIPTS=" --template-scripts --post-install $TI --pre-install $PI --post-uninstall $TR --pre-uninstall $PR"

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
  fpm -t deb -s dir --name dummy-package ${SCRIPTS} --version 0.0.2 --architecture $arch --maintainer "<rls-team@acme.com>" --description "dummy package arch $arch" --prefix /var/tmp/dummy -C src .
done
