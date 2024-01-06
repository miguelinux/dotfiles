#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

#VAULT_FILE=${HOME}/.local/vault.img
#MAP_NAME=vault
#MOUNT_DIR=${HOME}/.local/vault

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
    esac
    shift
done

SU_CMD="sudo"
if [ ${UID} -eq 0 ]
then
    SU_CMD=""
fi

if test -f ${HOME}/.config/my-vault.sh.conf
then
    source ${HOME}/.config/my-vault.sh.conf
    if ! mount | grep --quiet ${MOUNT_DIR}
    then
        ${SU_CMD} cryptsetup open ${VAULT_FILE} ${MAP_NAME} && \
        ${SU_CMD} mount /dev/mapper/${MAP_NAME} ${MOUNT_DIR}
    else
        ${SU_CMD} umount /dev/mapper/${MAP_NAME} && \
        ${SU_CMD} cryptsetup close ${MAP_NAME}
    fi
fi
