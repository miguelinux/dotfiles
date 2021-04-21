#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

VQUIET="--quiet"

if [ $# -eq 0 ]
then
    echo "Git pull on all"
    exec $0 *
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
        -v|--verbose)
            VQUIET=""
        ;;
        *)
            if [ -d ${1}/.git ]
            then
                git -C $1 pull ${VQUIET} 
            fi
        ;;
    esac
    shift
done
