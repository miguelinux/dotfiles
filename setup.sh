# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

find -name \*~ -exec rm {} \;
mkdir -p ${HOME}/.local/bin
mkdir -p ${HOME}/.config/git
mkdir -p ${HOME}/.config/shrc
mkdir -p ${HOME}/.config/systemd/user
mkdir -p ${HOME}/.mutt
mkdir -p ${HOME}/.cache/mutt
mkdir -p ${HOME}/.fluxbox
mkdir -p ${HOME}/.vim/colors
mkdir -p ${HOME}/.vim/templates
stow -t ${HOME}/.config config
stow -t ${HOME}/.mutt mutt
stow -t ${HOME}/.vim vim
stow -t ${HOME}/.fluxbox fluxbox
stow -t ${HOME} tmux
stow -t ${HOME} dircolors
stow -t ${HOME} bash
stow -t ${HOME}/.local/bin bin
