find -name \*~ -exec rm {} \;
mkdir -p ${HOME}/bin
mkdir -p ${HOME}/.config/git
mkdir -p ${HOME}/.config/shrc
stow -t ${HOME}/.config XDG_CONFIG_HOME
stow -t ${HOME} tmux
stow -t ${HOME} dircolors
stow -t ${HOME} bash
stow -t ${HOME} bin
