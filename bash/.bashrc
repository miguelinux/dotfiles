# Use global profile when available
if [ -f /usr/share/defaults/etc/profile ]; then
	. /usr/share/defaults/etc/profile
fi
# allow admin overrides
if [ -f /etc/profile ]; then
	. /etc/profile
fi

# load global shell setup
if [ -d ${HOME}/.config/shrc/ ]; then
  for s in ${HOME}/.config/shrc/* ; do
    source $s
  done
  unset s
fi
