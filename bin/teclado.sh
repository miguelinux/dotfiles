#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Synergy Server
SS=mobl3
SSTOP=0

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debbug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
        off)
            SSTOP=1
        ;;
        *)
            SS=$1
        ;;
    esac
    shift
done

if [ ${SSTOP} -eq 1 ]
then
    systemctl --user stop synergy-client-ssh.service
    systemctl --user stop synergy-tunnel@${SS}
    echo stopped
    exit
fi

if ssh -o ConnectTimeout=2 ${SS} echo > /dev/null
then
    systemctl --user start synergy-tunnel@${SS}
    sleep 1
    systemctl --user start synergy-client-ssh.service
else
    echo "No connection to ${SS}"
fi
