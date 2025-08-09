#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

if [ "${0##*/}" = "decifra.sh" ]
then
    gpg --decrypt --quiet --batch --passphrase-file $@
else
    gpg --symmetric --cipher-algo AES256 --batch --passphrase-file $@
fi
