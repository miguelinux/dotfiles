# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

my-stow() {
    if stow --version 2&> /dev/null
    then
        stow $@
    else
        echo "No stow package"
        exit
        #TODO Dec 28 2020
        echo "---- > $2 "
        for f in $3/*
        do
            if [ -f $f ]
            then
                echo "f  $f"
            else
                echo "o  $f"
            fi
        done
    fi
}

find -name \*~ -exec rm {} \;
mkdir -p ${HOME}/.local/bin
mkdir -p ${HOME}/.config/git
mkdir -p ${HOME}/.config/i3
mkdir -p ${HOME}/.config/shrc
mkdir -p ${HOME}/.config/systemd/user
mkdir -p ${HOME}/.mutt
mkdir -p ${HOME}/.cache/mutt
mkdir -p ${HOME}/.fluxbox
mkdir -p ${HOME}/.vim/colors
mkdir -p ${HOME}/.vim/templates

my-stow -t ${HOME}/.config config
my-stow -t ${HOME}/.mutt mutt
my-stow -t ${HOME}/.vim vim
my-stow -t ${HOME}/.fluxbox fluxbox
my-stow -t ${HOME} tmux
my-stow -t ${HOME}/.local/bin bin
my-stow -t ${HOME} varios
