#!/usr/bin/env bash

# export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:$HOME/.local/bin/"
export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export BROWSER="firefox"
export READER="zathura"
export SUDO_ASKPASS="$HOME/.local/bin/tools/dmenupass"
export QT_QPA_PLATFORMTHEME=qt5ct

# Declutter ~
export GNUPGHOME="$HOME/.config/gnupg"
export INPUTRC="$HOME/.config/inputrc"
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir $HOME/.config/gtk-2.0
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
[ ! -d "$HOME/.config/zsh" ] && mkdir 
export ZDOTDIR="$HOME/.config/zsh"

# [ -f ~/.bashrc ] && source ~/.bashrc
echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

if [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ]; then

	if [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ]; then
		[ ! -d ~/.local/xorg ] && mkdir ~/.local/xorg
		exec startx > ~/.local/xorg/$(date +%Y_%m_%d-%Hh%Mm%Ss).log 2>&1

	elif [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ]; then
		# Variables needed by only by sway.
		export XKB_DEFAULT_LAYOUT=us,gr
		export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
		#export QT_QPA_PLATFORM=wayland
		export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
		#export MOZ_ENABLE_WAYLAND=1
		sway >/dev/null
	fi
fi