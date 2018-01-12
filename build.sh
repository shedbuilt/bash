#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        ./configure --prefix=/tools \
                    --without-bash-malloc || return 1
        ;;
    *)
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/bash-4.4.12 \
                    --without-bash-malloc \
                    --with-installed-readline || return 1
        ;;
esac
make -j $SHED_NUMJOBS
make DESTDIR="$SHED_FAKEROOT" install

case "$SHED_BUILDMODE" in
    toolchain)
        ln -sv bash "${SHED_FAKEROOT}/tools/bin/sh"
        ;;
    *)    
        mkdir -v "${SHED_FAKEROOT}/bin"
        mv -vf "${SHED_FAKEROOT}/usr/bin/bash" "${SHED_FAKEROOT}/bin"
        ln -sv bash "${SHED_FAKEROOT}/bin/sh"
        ;;
esac
