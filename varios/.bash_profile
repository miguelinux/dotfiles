# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Use global profile when available
if [ -f /usr/share/defaults/etc/profile ]; then
	source /usr/share/defaults/etc/profile
fi

# allow admin overrides
if [ -f /etc/profile ]; then
	source /etc/profile
fi

if [ -f "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc" -a -z "$MY_BASHRC" ]; then
	source "$HOME/.bashrc"
fi
