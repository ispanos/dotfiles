#!/bin/bash
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="neovim"
export TERMINAL="termite"
export BROWSER="firefox"
export READER="zathura"
export INPUTRC="$HOME/.config/inputrc"
#export GIT_CONFIG="$HOME/.config/gitconfig" # didn't work.
export QT_QPA_PLATFORMTHEME=qt5ct
export XKB_DEFAULT_LAYOUT=us,gr
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle

[ -f ~/.bashrc ] && source ~/.bashrc

# Start X if its not already running.
#[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

# Start sway if its not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && sway
