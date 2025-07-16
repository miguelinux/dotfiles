#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

F=/tmp/eject.sh

echo "#!/bin/bash" > $F
echo  >> $F
echo "sleep 2" >> $F
echo "udisksctl power-off -b /dev/sdb" >> $F

chmod 755 $F
