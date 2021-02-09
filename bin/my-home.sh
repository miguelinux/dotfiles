#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

#CDEV=/dev/mapper/name
#CNAME=name
#CMOUNT=/home/name

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
    esac
    shift
done

if test -f ${HOME}/.config/my-home.sh.conf
then
    source ${HOME}/.config/my-home.sh.conf
    sudo cryptsetup open ${CDEV} ${CNAME}
    sudo mount ${CMOUNT}
fi
