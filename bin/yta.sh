#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

# playlist URL

youtube-viewer \
    --no-video-info \
    --autoplay \
    --audio \
    --novideo \
    --resolution=audio \
    --shuffle \
    --audio-quality=best \
    $*
