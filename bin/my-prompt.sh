#!/usr/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

u=$1
h=$2

# Path to prompt file
PTPF=${HOME}/.config/shrc/zz-prompt

if [ -z "$u" ]
then
    u="\\u"
fi
if [ -z "$h" ]
then
    h="\\h"
fi

if [ "$u" = "\\u" -a "$h" = "\\h" ]
then
    rm -f ${PTPF}
    exit
fi

echo "PS_USER=\"\[\e[38;5;39m\]${u}\[\e[0m\]@\[\e[38;5;208m\]${h} \[\e[38;5;39m\]\w\[\e[0;0m\]\"" > ${PTPF}
echo "PS_USER_END=\" \[\e[38;5;39m\]$ \[\e[0;0m\]\"" >> ${PTPF}
echo "export PROMPT_COMMAND='__git_ps1 \"\$PS_USER\" \"\$PS_USER_END\"'" >> ${PTPF}
