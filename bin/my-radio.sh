#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

estaciones="
metropoli https://s2.yesstreaming.net:9088/stream
"

function toca() 
{
    found=0
    for est in $estaciones
    do
        if [ "$found" = "1" ]
        then
            mpv --really-quiet $est
            exit
        fi
        if [ "$est" = "$1" ]
        then
            found=1
        fi
    done
    echo "$1 no se encontró"
}

if [ "$#" == "0" ]
then
    echo "Estaciones de radio:"
    n=0
    for est in $estaciones
    do
        if [ "$n" = "0" ]
        then
            echo $est
            n=1
        else
            n=0
        fi
    done
    exit
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
        *)
            toca $1
        ;;
    esac
    shift
done

