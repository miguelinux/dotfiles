#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

# DotFiles Directory
DFD="${XDG_CONFIG_HOME:-$HOME/.config}"/my-dotfiles.d

my_update()
{

    for ref in "$DFD"/*
    do
        repo_path_full="$(realpath "$ref")"
        repo_path="${repo_path_full%/*/*/*}"
        #if ! git -C "${repo_path}" diff-index --cached --quiet HEAD --
        if test -n "$(git -C ${repo_path} status --porcelain)"
        then
            echo "Please commit and push: ${repo_path}"
            git -C "${repo_path}" fetch --all --quiet
            continue
        fi
        git -C "${repo_path}" pull --quiet
        cd "${repo_path}"
        bash setup.sh
        cd -
    done
}

function myhelp()
{
    echo "Usage: $0 <command>"
    echo ""
    echo "COMMANDS"
    echo ""
    echo "up|update         updates the repo"
    echo ""
    exit
}

if [ "$#" == "0" ]
then
    myhelp
fi

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
        up|update)
            my_update
        ;;
        -h|--help)
            myhelp
        ;;
        *)
            myhelp
        ;;
    esac
    shift
done
