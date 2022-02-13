#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vi: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Environmen variables for to overide default values
# TELEGRAM_CHAT_ID
# TELEGRAM_TOKEN

# Global variables
API_URL=https://api.telegram.org/bot

#### The config file ########
TEXT=""
CHAT_ID=""
TOKEN=""
RET_JS=/dev/null
#### END The config file ########


##### my std lib #####

IDENTIFIER="dime"

error ()
{
    >&2 echo -e "${*}"
    echo "${*}" | systemd-cat --identifier=${IDENTIFIER} --priority=err
    telegram "${*}"
}

die ()
{
    >&2 echo -e "${*}"
    echo "${*}" | systemd-cat --identifier=${IDENTIFIER} --priority=emerg
    exit 1
}

pr_info ()
{
    echo -e "${*}"
    echo "${*}" | systemd-cat --identifier=${IDENTIFIER} --priority=info
}

##### my std lib #####

show_help() {
    echo "Usage: $0 [parameters] <command> [TEXT]"
    echo ""
    echo "COMMANDS"
    echo ""
    echo "ip         Get the IPv4 IPs"
    echo "hostname   Get the hostname"
    echo ""
    echo "PARAMETERS"
    echo ""
    echo "-d, --debug              Set debug mode in bash, i.e. set -x"
    echo "-e, --error              Set error mode in bash, i.e. set -e"
    echo "-w, --wait <TIME>        Wait TIME to continue, i.e. sleep TIME"
    echo "-i, --chat-id <CHAT_ID>  Set the CHAT_ID"
    echo "-t, --token <TOKEN>      Set the TOKEN"
    echo "-r, --ret-js <RET_JS>    Set the return JS file; default: /dev/null"
    echo "-c, --config <NAME_or_PATH> Set the name of config file or Full path"
    echo "-h, --help               Shows this help"
    echo ""
    echo "The TEXT can be at any position and multiple times"
    echo ""
    echo "Environment variables"
    echo ""
    echo "TEXT=${TEXT}"
    echo "CHAT_ID=${CHAT_ID}"
    echo "TOKEN=${TOKEN}"
    echo "RET_JS=${RET_JS}"
    echo ""
    exit
}

dime ()
{
    if [ -z "${TEXT}" ]
    then
        return
    fi
    if [ -z "${CHAT_ID}" ]
    then
        die "No chat id found" 
    fi
    if [ -z "${TOKEN}" ]
    then
        die "No token found" 
    fi

    TOKEN_URL=${API_URL}${TOKEN}

    curl --get --silent \
        --data-urlencode "chat_id=${CHAT_ID}" \
        --data-urlencode "text=${TEXT}" \
        $TOKEN_URL/sendMessage > ${RET_JS}

    #curl --silent \
    #    --form chat_id=${CHAT_ID}\
    #    --form caption="el mensaje" \
    #    --form photo=@/tmp/h.jpg \
    #    $TOKEN_URL/sendPhoto > ${RET_JS}
}


parse_args ()
{
    local need_help=0
    # Look for:
    # 1. /etc
    # 2. $HOME
    # 3. env vars
    # 4. cmdline

    # 1. Look for /etc
    if [ -e "/etc/telegram/config" ]
    then
        source /etc/telegram/config
    fi

    # 2. Look for $HOME
    if [ -e "${HOME}/.config/telegram/config" ]
    then
        source ${HOME}/.config/telegram/config
    fi

    # 3. Look for environment variables
    if [ -n "${TELEGRAM_CHAT_ID}" ]
    then
        CHAT_ID=${TELEGRAM_CHAT_ID}
    fi
    if [ -n "${TELEGRAM_TOKEN}" ]
    then
        TOKEN=${TELEGRAM_TOKEN}
    fi
    if [ -n "${TELEGRAM_TEXT}" ]
    then
        TEXT=${TELEGRAM_TEXT}
    fi

    # 4. Look for command line
    while [ -n "${1}" ]
    do
        case "$1" in
            -d|--debug)
                set -x
            ;;
            -e|--error)
                set -e
            ;;
            -w|--wait)
                shift
                sleep $1
            ;;
            hostname)
                TEXT="${TEXT} $(hostname)"$'\n'
            ;;
            ip)
                TEXT="${TEXT} $(ip a show | grep  inet\  | cut -f 6 -d " ") "
            ;;
            -i|--chat-id)
                shift
                CHAT_ID=$1
            ;;
            -t|--token)
                shift
                TOKEN=$1
            ;;
            -r|--ret-js)
                shift
                RET_JS=$1
            ;;
            -c|--config)
                shift
                if [ -e "/etc/telegram/$1" ]
                then
                    source /etc/telegram/$1
                fi
                if [ -e "${HOME}/.config/telegram/$1" ]
                then
                    source ${HOME}/.config/telegram/$1
                fi
                if [ -e "$1" ]
                then
                    source $1
                fi
            ;;
            -h|--help)
                need_help=1
            ;;
            *)
                TEXT="${TEXT} ${1} "
            ;;
        esac
        shift
    done

    if test ${need_help} -eq 1
    then
        show_help
    fi
}

#############   main #############

parse_args $@
dime
