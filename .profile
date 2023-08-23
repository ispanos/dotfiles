#!/usr/bin/env bash

# [ -f ~/.config/declutter.sh ] &&
source ~/.config/declutter.sh

# set PATH so it includes user's private bin
PATH=$PATH:~/.local/bin

bash ~/.local/bin/load_dconf_settings
gsettings get org.gnome.shell enabled-extensions > "$HOME/.config/dconf/enabled-extensions"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Gnome Keyring
# https://wiki.archlinux.org/index.php/GNOME/Keyring#PAM_method
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Needed with no display manager.
# [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return

# No display manager:

# [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ] &&
# 	i3confmerge
# 	exec startx /usr/bin/i3
# [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ] &&
# 	exec /usr/local/bin/sway-ptinopedila
