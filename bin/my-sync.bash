#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Leer archivo separado por espacioes
# comando source dest
#  rclone sync  /home/mbernalm/Documents/scouts scouts:

if [ ! -f $HOME/.config/rclone/rclone.conf ]
then
    echo No $HOME/.config/rclone/rclone.conf file found
    exit 0
fi

if [ ! -f $HOME/.config/rclone/my-sync.conf ]
then
    echo No $HOME/.config/rclone/my-sync.conf file found
    exit 0
fi

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

while read -r line
do
    if [ ${line:0:1}  = "#" ]
    then
        continue
    fi
    # Run rclone
    rclone $line
done < $HOME/.config/rclone/my-sync.conf

