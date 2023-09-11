#!/usr/bin/env bash

# [ -f ~/.config/declutter.sh ] &&
source ~/.config/declutter.sh

# set PATH so it includes user's private bin
PATH=$PATH:~/.local/bin

bash ~/.local/bin/load_dconf_settings

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Gnome Keyring
# https://wiki.archlinux.org/index.php/GNOME/Keyring#PAM_method
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# # No display manager:
# [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return
# [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ] &&
# 	exec /usr/local/bin/sway-ptinopedila
