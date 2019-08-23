#!/bin/sh
#xcompmgr &
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
dunst &
exec i3