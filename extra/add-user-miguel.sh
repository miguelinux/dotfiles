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

useradd \
	--uid 1980 \
	--shell /usr/bin/bash \
	--create-home \
	--home-dir /home/miguel \
	--comment "Miguel Bernal Marin" \
	miguel

if [ -d /etc/sudoers.d ]
then
    echo "miguel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/015_miguel-nopasswd
fi

#	--groups cdrom,dip,plugdev,lpadmin,lxd,familia,sambashare  \
