#!/bin/bash
patch -Np1 -i "$SHED_PATCHDIR/bash-4.4-upstream_fixes-1.patch"
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bash-4.4 \
            --without-bash-malloc \
            --with-installed-readline
make -j $SHED_NUMJOBS
make "DESTDIR=${SHED_FAKEROOT}" install
mkdir -v "${SHED_FAKEROOT}/bin"
mv -vf "${SHED_FAKEROOT}/usr/bin/bash" "${SHED_FAKEROOT}/bin"
ln -sv bash "${SHED_FAKEROOT}/bin/sh"
