#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

function update()
{
    repo_path_full=$(realpath $0)
    repo_path=${repo_path_full%/*/*}
    git -C "$repo_path" pull
    #if ! git -C "${repo_path}" diff-index --cached --quiet HEAD --
    if [ -n "$(git -C ${repo_path} status --porcelain)" ]
    then
        git -C "${repo_path}" add --all
        git -C "${repo_path}" commit -m "auto-update"
        git -C "${repo_path}" push
    fi
    bash "${repo_path}"/setup.sh
}

function myhelp()
{
    echo "Usage: $0 <command>"
    echo ""
    echo "COMMANDS"
    echo ""
    echo "update         updates the repo"
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
        update)
            update
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

