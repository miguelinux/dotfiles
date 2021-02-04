#!/usr/bin/echo "Este script tiene que correrse con source o ."
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

u=$1
h=$2

if [ -z "$u" ]
then
    u="\\u"
fi
if [ -z "$h" ]
then
    h="\\h"
fi

##"PS1=[\u@\h \W]\$" # old
# \[\e[38;5;39m\]\u\[\e[0m\]@\[\e[38;5;208m\]\H \[\e[38;5;39m\]\w \[\e[38;5;39m\]$ \[\e[0;0m\]
PS_USER="\[\e[38;5;39m\]${u}\[\e[0m\]@\[\e[38;5;208m\]${h} \[\e[38;5;39m\]\w\[\e[0;0m\]"
PS_USER_END=" \[\e[38;5;39m\]$ \[\e[0;0m\]"
#export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
export PROMPT_COMMAND='__git_ps1 "$PS_USER" "$PS_USER_END"'
