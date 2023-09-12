#!/usr/bin/env bash

# [ -f ~/.config/declutter.sh ] &&
source ~/.config/declutter.sh

# set PATH so it includes user's private bin
PATH=$PATH:~/.local/bin

bash ~/.local/bin/load_dconf_settings

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# # No display manager:
# [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return
# [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ] &&
# 	exec /usr/local/bin/sway-ptinopedila
