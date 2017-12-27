#!/bin/bash
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bash-4.4.12 \
            --without-bash-malloc \
            --with-installed-readline
make -j $SHED_NUMJOBS
make "DESTDIR=${SHED_FAKEROOT}" install
mkdir -v "${SHED_FAKEROOT}/bin"
mv -vf "${SHED_FAKEROOT}/usr/bin/bash" "${SHED_FAKEROOT}/bin"
ln -sv bash "${SHED_FAKEROOT}/bin/sh"
