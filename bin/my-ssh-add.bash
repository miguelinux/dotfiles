#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

_gpg=/usr/bin/gpg

# Secret keys file
SKF="${HOME}/.ssh/.secret-keys"

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
    esac
    shift
done

if ! test -f "$SKF"
then
    exit 0
fi

# gpg --symmetric --cipher-algo AES256 --output .secret-keys secretos
MY_KEYS=$("$_gpg" --decrypt --quiet "$SKF")

SSH_ASKPASS=$HOME/.local/bin/my-ssh-askpass.bash
export SSH_ASKPASS

for k in $MY_KEYS
do
    IFS="," read -r file passwd <<< "$k"
    if test -f "$file"
    then
        echo "password" | ssh-add "$file"
    fi
done

unset SSH_ASKPASS
