#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

CUENTA=""
ANOMBRE=""

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
            CUENTA=$1
        ;;
    esac
    shift
done

if test -z "${CUENTA}"
then
    echo >&2 "No account given"
    exit 1
fi


if ! test -e ${HOME}/.config/Microsoft/my-teams.conf
then
    echo >&2 "No ${HOME}/.config/Microsoft/my-teams.conf found"
    exit 2
fi


source ${HOME}/.config/Microsoft/my-teams.conf


if test -z "${ANOMBRE}"
then
    echo >&2 "Microsoft account name not found"
    exit 3
fi


if ! test -d ${HOME}/.config/Microsoft-${CUENTA}
then
    echo >&2 "Microsoft-${CUENTA} not found"
    exit 4
fi


if test $(ps aux | grep teams | wc -l) -gt 6
then
    echo >&2 "Teams is running"
    exit 5
fi


mv ${HOME}/.config/Microsoft ${HOME}/.config/Microsoft-${ANOMBRE}
mv ${HOME}/.config/Microsoft-${CUENTA} ${HOME}/.config/Microsoft
teams
