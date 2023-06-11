#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

MY_DBPAGES=$HOME/.local/share/check-web/pages.csv

if [ -e $HOME/.config/check-web.conf ]
then
    source $HOME/.config/check-web.conf
fi

if [ ! -e ${MY_DBPAGES} ]
then
    mkdir -p ${MY_DBPAGES%/*}
    touch  ${MY_DBPAGES}
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
            echo hola
        ;;
    esac
    shift
done
