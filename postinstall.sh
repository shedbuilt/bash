#!/bin/bash
if [ ! -e /etc/shells ]; then
    ln -sfv /usr/share/defaults/etc/shells /etc/shells
fi
if [ ! -e /etc/bashrc ]; then
    ln -sfv /usr/share/defaults/etc/bashrc /etc/bashrc
fi
if [ ! -e /etc/profile ]; then
    ln -sfv /usr/share/defaults/etc/profile /etc/profile
fi
if [ ! -e /etc/profile.d ]; then
    ln -sfv /usr/share/defaults/etc/profile.d /etc/profile.d
fi
if [ ! -e /etc/skel ]; then
    ln -sfv /usr/share/defaults/etc/skel /etc/skel
fi
