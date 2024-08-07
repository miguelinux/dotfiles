#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

if [ $UID -ne 0 ]
then
    echo "Please run with \"root\" or \"sudo $0\""
    exit 1
fi

test -e /etc/os-release && os_release='/etc/os-release' || os_release='/usr/lib/os-release'
source "${os_release}"

packages_to_install="git git-lfs tmux vim rsync curl"
packages_to_install_too="stow connect-proxy"

case $ID in
    fedora)
        dnf -y update
        dnf -y install $packages_to_install
        dnf -y install $packages_to_install_too
    ;;
    centos)
        dnf -y update
        dnf -y install $packages_to_install
    ;;
    debian|ubuntu)
        apt-get -y update
        apt-get -y upgrade
        apt-get -y install $packages_to_install
        apt-get -y install $packages_to_install_too
    ;;
esac

mkdir -p $HOME/git

if [ ! -d $HOME/git/dotfiles ]
then
    git -C $HOME/git clone https://github.com/miguelinux/dotfiles.git
fi

cd $HOME/git/dotfiles
bash setup.sh
bash $HOME/git/dotfiles/extra/add-user-miguel.sh

