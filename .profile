#!/usr/bin/env bash

[ -f "/usr/local/share/ptinopedila/declutter.sh" ] &&
source "/usr/local/share/ptinopedila/declutter.sh"

# Append our default paths
appendpath () {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="${PATH:+$PATH:}$1"
	esac
}

# set PATH so it includes user's private bin
[ -d "$HOME/.local/bin" ] && appendpath "$HOME/.local/bin"
# appendpath "/var/lib/flatpak/exports/bin"
unset appendpath

# Gnome Keyring
# https://wiki.archlinux.org/index.php/GNOME/Keyring#PAM_method
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Needed with no display manager.
[[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return

# No display manager:

# [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ] &&
# 	i3confmerge
# 	exec startx /usr/bin/i3
# [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ] &&
# 	exec /usr/local/bin/sway-ptinopedila
