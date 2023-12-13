#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

QUIENSOY=miguel
MY_DB=${HOME}/.config/git-soy.csv

if [ ! -d .git ]
then
    echo "No git repo found"
    exit 1
fi

if [ ! -e ${MY_DB} ]
then
    echo "No ${MY_DB} found"
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
            QUIENSOY=$1
        ;;
    esac
    shift
done

MY_NAME=$(grep -m 1 $QUIENSOY $MY_DB | cut -f 1 -d ,)
MY_MAIL=$(grep -m 1 $QUIENSOY $MY_DB | cut -f 2 -d ,)

git config user.name "$MY_NAME"
git config user.email $MY_MAIL
git config user.name
git config user.email
