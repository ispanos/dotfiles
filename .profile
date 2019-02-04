#!/bin/bash

#
# ~/.bash_profile
#

export PATH="$(du $HOME/.scripts/ | cut -f2 | tr '\n' ':')$PATH"
export EDITOR="neovim"
export VISUAL=/usr/bin/neovim
export TERMINAL="termite"
export BROWSER="firefox"
export READER="zathura"
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

[ -f ~/.bashrc ] && source ~/.bashrc

# Start graphical server if i3 not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x i3 || exec startx
fi
