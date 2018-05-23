#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Configure
SHED_PKG_LOCAL_PREFIX='/usr'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    SHED_PKG_LOCAL_PREFIX='/tools'
fi
SHED_PKG_LOCAL_DOCDIR=${SHED_PKG_LOCAL_PREFIX}/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    ./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
                --docdir=${SHED_PKG_LOCAL_DOCDIR} \
                --without-bash-malloc || exit 1
else
    ./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
                --docdir=${SHED_PKG_LOCAL_DOCDIR} \
                --without-bash-malloc \
                --with-installed-readline || exit 1
fi

# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

# Rearrange
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    ln -sv bash "${SHED_FAKE_ROOT}/tools/bin/sh" || exit 1
elif [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/shells" "${SHED_FAKE_ROOT}/etc/shells" &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}/bashrc" "${SHED_FAKE_ROOT}/etc" &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}/profile" "${SHED_FAKE_ROOT}/etc" &&
    install -v -Dm644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_logout" "${SHED_FAKE_ROOT}/etc/skel/.bash_logout" &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bash_profile" "${SHED_FAKE_ROOT}/etc/skel" &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.bashrc" "${SHED_FAKE_ROOT}/etc/skel" &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}/skel/.profile" "${SHED_FAKE_ROOT}/etc/skel" &&
    install -v -dm755 "${SHED_FAKE_ROOT}/etc/profile.d" &&
    install -v -m755 "${SHED_PKG_CONTRIB_DIR}"/profile.d/*.sh "${SHED_FAKE_ROOT}/etc/profile.d" || exit 1
fi

if [ -z "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
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
fi

# Prune Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}"
fi
