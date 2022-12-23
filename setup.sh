# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

my-stow() {
    if stow --version 2&> /dev/null
    then
        stow $@
    else
        mkdir -p $2
        for f in $(ls -a $3)
        do
            if [ ${f: -1} = "." ]
            then
                continue
            fi
            if [ -d $3/$f ]
            then
                my-stow -t $2/$f $3/$f
            else
                ln -f -s $(realpath --relative-to=$2 $3/$f) $2/$f
            fi
        done
    fi
}

find -name \*~ -exec rm {} \;
mkdir -m 700 -p ${HOME}/.cache/mutt
mkdir -m 700 -p ${HOME}/.config/git
mkdir -m 700 -p ${HOME}/.config/i3
mkdir -m 700 -p ${HOME}/.config/shrc
mkdir -m 700 -p ${HOME}/.config/systemd/user
mkdir -m 700 -p ${HOME}/.config/todo
mkdir -m 700 -p ${HOME}/.fluxbox
mkdir -m 700 -p ${HOME}/.local/bin
mkdir -m 700 -p ${HOME}/.mutt
mkdir -m 700 -p ${HOME}/.vim/colors
mkdir -m 700 -p ${HOME}/.vim/templates
mkdir -m 700 -p ${HOME}/.ssh

my-stow -t ${HOME}/.config config
my-stow -t ${HOME}/.mutt mutt
my-stow -t ${HOME}/.vim vim
my-stow -t ${HOME}/.fluxbox fluxbox
my-stow -t ${HOME} tmux
my-stow -t ${HOME}/.local/bin bin
my-stow -t ${HOME} varios
