#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

clean_filename() {
    NO_SPACES=$(echo $1 | tr [:blank:] "_" | tr "'" "_")
    NEW_NAME=$(echo ${NO_SPACES} | sed -e 's/_\[[^][]*\]//g')
    mv "$1" $NEW_NAME
}

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
        *)
            clean_filename "$1"
        ;;
    esac
    shift
done

