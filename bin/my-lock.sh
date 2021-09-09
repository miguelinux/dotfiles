#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

revert() {
  xset dpms 0 0 0
}

trap revert HUP INT TERM

xset +dpms dpms 5 5 5

i3lock --nofork --color=000000

revert
