#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

MY_VAULT=$HOME/.my-vault.2fa.csv

# run: gpg --list-secret-keys --keyid-format LONG
U_ID="nombre <correo>"
K_ID="1234567890ABCDEF"

if [ -e "${HOME}"/.config/2fa/config ]
then
  source "${HOME}"/.config/2fa/config
fi

_new-2fa-entry ()
{
    local datos
    local id
    local llave
    datos=""

    if [ $# -lt 2 ]
    then
        >&2 echo "Faltan argumentos: sitio y/o llave"
        exit 1
    fi

    id=$1
    shift
    llave="$*"

    if [ -f "$MY_VAULT" ]
    then
        datos="$(gpg --decrypt --quiet "$MY_VAULT")"
    else
        #touch "$MY_VAULT" 
        echo no existe
    fi

    if echo "$datos" | grep --quiet "$id"
    then
        >&2 echo "El sitio $id ya existe"
        exit 2
    fi
        
    echo "$llave" | gpg --encrypt --local-user "$K_ID" --recipient "$U_ID" --output - --armor

    echo $id
    echo $llave

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
            shift
            _new-2fa-entry "$@"
            exit 0
        ;;
        *)
            echo hola
        ;;
    esac
    shift
done
