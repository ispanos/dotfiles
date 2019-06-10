#!/bin/bash
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="neovim"
export TERMINAL="termite"
export BROWSER="firefox"
export READER="zathura"
export INPUTRC="$HOME/.config/inputrc"
export QT_QPA_PLATFORMTHEME=qt5ct

[ -f ~/.bashrc ] && source ~/.bashrc

# Start graphical server if i3 not already running.
if [ "$(tty)" = "/dev/tty1" ]; then
	pgrep -x i3 || exec startx
fi
# # Alternative 
# [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx