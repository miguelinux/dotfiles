#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

_gpg=/usr/bin/gpg

# Secret keys file
SKF="${HOME}/.ssh/.secret-keys"

# First param: Enter passphrase for /path/to/ssh.key:
FP=${1}

if test -z "$FP"
then
    echo >&2 "Needs at least one parameter with file path"
    exit 1
fi

KEY_FILE=${FP#*/}
KEY_FILE="/${KEY_FILE:0:-2}"

if test -z "$KEY_FILE"
then
    echo >&2 "No key file identified: $KEY_FILE"
    exit 2
fi

if ! test -f "$KEY_FILE"
then
    echo >&2 "File not found: $KEY_FILE"
    exit 3
fi

MY_KEYS=$("$_gpg" --decrypt --quiet "$SKF")
for k in $MY_KEYS
do
    IFS="," read -r file passwd <<< "$k"
    if test "$file" = "$KEY_FILE"
    then
        echo "$passwd"
        exit
    fi
done

#systemd-creds --user decrypt "$MY_CREDS_FILE"
