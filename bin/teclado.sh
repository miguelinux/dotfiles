#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Synergy Server
SS=$2

if [ "$1" != "off" ]
then
    SS=$1
fi

test -n "${SS}" || SS=mobl3

if [ "$1" = "off" ]
then
    systemctl --user stop synergy-client-ssh.service
    systemctl --user stop synergy-tunnel@${SS}
    echo stopped
    exit
fi

if nmcli -t device | grep --quiet OfficeW
then
    if ssh ${SS} echo > /dev/null
    then
        systemctl --user start synergy-tunnel@${SS}
        sleep 1 
        systemctl --user start synergy-client-ssh.service
    fi
fi
