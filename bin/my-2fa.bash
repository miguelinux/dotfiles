#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# run: gpg --list-secret-keys --keyid-format LONG
U_ID="nombre <correo>"
K_ID="1234567890ABCDEF"
DIR_PATH="${HOME}"/.config/2fa

_gpg=/usr/bin/gpg
_oathtool=/usr/bin/oathtool
_qrencode=/usr/bin/qrencode

if [ -e "${HOME}"/.config/2fa/config ]
then
  source "${HOME}"/.config/2fa/config
else
    >&2 echo "No se encontro archivo de configuración."
    exit 1
fi

_new-2fa-entry ()
{
    local id
    local usuario
    local llave

    if [ $# -lt 3 ]
    then
        >&2 echo "Faltan argumentos: sitio y/o usuario y/o llave"
        >&2 echo "Uso: $0 new sitio usuario llave"
        exit 1
    fi

    id=$1
    shift
    usuario=$1
    shift
    llave="$*"

    if [ -f $DIR_PATH/$id.$usuario.txt ]
    then
        >&2 echo "El sitio $id con $usuario ya existe"
        exit 2
    fi

    local tmpfile=$(mktemp --dry-run)
    echo "$llave" | $_gpg --encrypt --local-user "$K_ID" --recipient "$U_ID" --batch --output "$tmpfile" --armor
    $_gpg --symmetric --cipher-algo AES256 --batch --output $DIR_PATH/$id.$usuario.txt --armor "$tmpfile"
    rm -f "$tmpfile"
}

_get_qr ()
{
    local sitio
    local usuario
    local totp
    local tmpfile
    sitio=$1
    usuario=$2

    if [ -f $DIR_PATH/$sitio.$usuario.txt ]
    then
        tmpfile=$(mktemp --dry-run)
        $_gpg --decrypt --quiet --batch --output "$tmpfile" $DIR_PATH/$sitio.$usuario.txt
        if [ $? -ne 0 ]
        then
            rm -f $tmpfile
            exit 2
        fi
        # Synchronize cached writes to persistent storage
        sync
        totp=$($_gpg --decrypt --quiet --local-user "$K_ID" --recipient "$U_ID" --batch --output - "$tmpfile")
        rm $tmpfile
    else
        exit 3
    fi

    if [ -z "$totp" ]
    then
        exit 4
    fi


    totp=$(echo $totp | tr -d ' ')
    url="otpauth://totp/$sitio%3A$usuario?period=30&digits=6&algorithm=SHA1&secret=$totp&issuer=$sitio"

    qrencode -t UTF8 $url
}

_decrypt-2fa-entry ()
{
    local sitio
    local usuario
    local totp
    local tmpfile
    sitio=$1
    usuario=$2

    if [ -f $DIR_PATH/$sitio.$usuario.txt ]
    then
        tmpfile=$(mktemp --dry-run)
        $_gpg --decrypt --quiet --batch --output "$tmpfile" $DIR_PATH/$sitio.$usuario.txt
        if [ $? -ne 0 ]
        then
            rm -f $tmpfile
            exit 2
        fi
        # Synchronize cached writes to persistent storage
        sync
        totp=$($_gpg --decrypt --quiet --local-user "$K_ID" --recipient "$U_ID" --batch --output - "$tmpfile")
        rm $tmpfile
    else
        exit 3
    fi

    if [ -z "$totp" ]
    then
        exit 4
    fi


    code=$($_oathtool -b --totp "$totp")
    type -a xclip &> /dev/null
    test $? -eq 0 && { echo $code | xclip -selection clipboard; echo "*** Código copiado al porta papeles ***"; }
    echo "$code"
}

for p in $_gpg $_oathtool $_qrencode
do
    if [ ! -x $p ]
    then
        >&2 echo "$p NO existe"
        exit 5
    fi
done

if [ "$#" = 0 ]
then
    _sites=$(ls $DIR_PATH/*.txt)
    printf " %15s %15s\n" sitio usuario
    for d in $_sites
    do
        f=${d##*/}
        s=$(echo $f | cut -f 1 -d .)
        u=$(echo $f | cut -f 2 -d .)
        printf " %15s %15s\n" $s $u
    done
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
        new)
            shift
            _new-2fa-entry "$@"
            exit 0
        ;;
        qr)
            shift
            _get_qr "$@"
            exit 0
        ;;
        *)
            _site=$1
            shift
            _user=$1
            if [ -f $DIR_PATH/$_site.$_user.txt ]
            then
                _decrypt-2fa-entry $_site $_user
            else
                >&2 echo "El sitio $_site con $_user NO existe"
                exit 3
            fi
        ;;
    esac
    shift
done
