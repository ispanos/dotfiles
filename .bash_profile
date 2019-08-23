#!/usr/bin/env bash

export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export BROWSER="firefox"
export READER="zathura"
export QT_QPA_PLATFORMTHEME=qt5ct

# Declutter ~
export GNUPGHOME="$HOME/.config/gnupg"
export INPUTRC="$HOME/.config/inputrc"

[ -f ~/.bashrc ] && source ~/.bashrc

if [[ -z $DISPLAY ]]; then
	if [ -f /usr/bin/i3 ]; then
		[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

	elif [ -f /usr/bin/sway ]; then
		# Variables needed by only by sway.
		export XKB_DEFAULT_LAYOUT=us,gr
		export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
		#export QT_QPA_PLATFORM=wayland
		export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
		#export MOZ_ENABLE_WAYLAND=1
		
		[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && sway >/dev/null
	fi
fi