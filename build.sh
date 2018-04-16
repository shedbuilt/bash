#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        ./configure --prefix=/tools \
                    --without-bash-malloc || exit 1
        ;;
    *)
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/bash-${SHED_PKG_VERSION} \
                    --without-bash-malloc \
                    --with-installed-readline || exit 1
        ;;
esac
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

case "$SHED_BUILD_MODE" in
    toolchain)
        ln -sv bash "${SHED_FAKE_ROOT}/tools/bin/sh" || exit 1
        ;;
    bootstrap)
        install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/shells" "${SHED_FAKE_ROOT}/etc/shells" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/bashrc" "${SHED_FAKE_ROOT}/etc" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/profile" "${SHED_FAKE_ROOT}/etc" &&
        install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_logout" "${SHED_FAKE_ROOT}/etc/skel/.bash_logout" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_profile" "${SHED_FAKE_ROOT}/etc/skel" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bashrc" "${SHED_FAKE_ROOT}/etc/skel" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.profile" "${SHED_FAKE_ROOT}/etc/skel" &&
        install -v -dm755 "${SHED_FAKE_ROOT}/etc/profile.d" &&
        install -v -m755 "${SHED_PKG_CONTRIB_DIR}"/profile.d/*.sh "${SHED_FAKE_ROOT}/etc/profile.d" || exit 1
        ;&
    *)
        install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/shells" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/shells" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/bashrc" "${SHED_FAKE_ROOT}/usr/share/defaults/etc" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/profile" "${SHED_FAKE_ROOT}/usr/share/defaults/etc" &&
        install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_logout" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/skel/.bash_logout" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_profile" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/skel" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bashrc" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/skel" &&
        install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.profile" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/skel" &&
        install -v -dm755 "${SHED_FAKE_ROOT}/usr/share/defaults/etc/profile.d" &&
        install -v -m755 "${SHED_PKG_CONTRIB_DIR}"/profile.d/*.sh "${SHED_FAKE_ROOT}/usr/share/defaults/etc/profile.d" &&
        mkdir -v "${SHED_FAKE_ROOT}/bin" &&
        mv -vf "${SHED_FAKE_ROOT}/usr/bin/bash" "${SHED_FAKE_ROOT}/bin" &&
        ln -sv bash "${SHED_FAKE_ROOT}/bin/sh"
        ;;
esac
