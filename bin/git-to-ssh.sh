#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

GITREMOTE=origin

if [ ! -d .git ]
then
    echo "No git repo found"
    exit 1
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
        *)
            GITREMOTE=$1
        ;;
    esac
    shift
done

GITHOST=$(git remote -v | grep ${GITREMOTE} | grep fetch | cut -f 3 -d /)
GITREPO=$(git remote -v | grep ${GITREMOTE} | grep fetch | cut -f 3- -d / | cut -f 1 -d " " | cut -f 2- -d /)

git remote set-url --push ${GITREMOTE} git@${GITHOST}:${GITREPO}
