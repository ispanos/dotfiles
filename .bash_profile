#!/bin/bash
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="neovim"
export TERMINAL="termite"
export BROWSER="firefox"
export READER="zathura"
export INPUTRC="$HOME/.config/inputrc"
#export GIT_CONFIG="$HOME/.config/gitconfig" # didn't work.
export QT_QPA_PLATFORMTHEME=qt5ct

[ -f ~/.bashrc ] && source ~/.bashrc

# Start X if its not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx