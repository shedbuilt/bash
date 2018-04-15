#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        ./configure --prefix=/tools \
                    --without-bash-malloc || exit 1
        ;;
    *)
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/bash-4.4.18 \
                    --without-bash-malloc \
                    --with-installed-readline || exit 1
        ;;
esac
make -j $SHED_NUM_JOBS && \
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

case "$SHED_BUILD_MODE" in
    toolchain)
        ln -sv bash "${SHED_FAKE_ROOT}/tools/bin/sh"
        ;;
    *)    
        mkdir -v "${SHED_FAKE_ROOT}/bin"
        mv -vf "${SHED_FAKE_ROOT}/usr/bin/bash" "${SHED_FAKE_ROOT}/bin"
        ln -sv bash "${SHED_FAKE_ROOT}/bin/sh"
        ;;
esac
