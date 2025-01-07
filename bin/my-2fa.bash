#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

MY_VAULT=$HOME/.my-vault.2fa.csv



if [ -e ${HOME}/.config/2fa/config ]
then
  source ${HOME}/.config/2fa/config
fi

_new-2fa-entry ()
{
    echo $*
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
        new)
            _new-2fa-entry $*
        ;;
        *)
            echo hola
        ;;
    esac
    shift
done

