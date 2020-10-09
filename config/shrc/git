# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

# Explicitly unset color (default anyhow). Use 1 to set it.
export GIT_PS1_SHOWCOLORHINTS=1

#GIT_PS1_DESCRIBE_STYLE="branch"
#GIT_PS1_SHOWUPSTREAM="auto git"

#export GIT_PROXY_COMMAND=$HOME/bin/git-proxy

source $HOME/.local/bin/git-completion.bash
source $HOME/.local/bin/git-prompt.sh

##"PS1=[\u@\h \W]\$" # old
# \[\e[38;5;39m\]\u\[\e[0m\]@\[\e[38;5;208m\]\H \[\e[38;5;39m\]\w \[\e[38;5;39m\]$ \[\e[0;0m\]
PS_USER="\[\e[38;5;39m\]\u\[\e[0m\]@\[\e[38;5;208m\]\h \[\e[38;5;39m\]\w\[\e[0;0m\]"
PS_USER_END=" \[\e[38;5;39m\]$ \[\e[0;0m\]"
#export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
export PROMPT_COMMAND='__git_ps1 "$PS_USER" "$PS_USER_END"'
