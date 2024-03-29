#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

xclip -selection clipboard -t image/png -o > "$(date +%Y-%m-%d_%T).png"
ls $(date +%Y-%m-)*.png
