#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

xrandr \
    --output LVDS --pos 0x0 \
    --output VGA-0 --pos 1366x0 \
#    --output LVDS --pos 0x0 --mode 1366x768 --rotate normal \
#    --output VGA-0 --pos 1366x0 --mode 1366x768 --rotate normal \
