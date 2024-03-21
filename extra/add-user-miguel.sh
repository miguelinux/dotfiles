#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

source /usr/lib/os-release

if [ $UID -ne 0 ]
then
    echo "Please run with \"root\" or \"sudo $0\""
    exit 1
fi

if [ ! -d /home/miguel ]
then
    useradd \
	--uid 1980 \
	--shell /usr/bin/bash \
	--create-home \
	--home-dir /home/miguel \
        --groups users  \
	--comment "Miguel Bernal Marin" \
	miguel
fi

#	--groups cdrom,dip,plugdev,lpadmin,lxd,familia,sambashare  \

if [ -d /etc/sudoers.d ]
then
    echo "miguel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/015_miguel-nopasswd
fi

if [ -d /home/miguel -a ! -d /home/miguel/.local/git/dotfiles ]
then
    mkdir -p /home/miguel/.local/git
    git -C /home/miguel/.local/git clone https://github.com/miguelinux/dotfiles.git
    chown --recursive miguel:miguel /home/miguel/.local/git
fi

