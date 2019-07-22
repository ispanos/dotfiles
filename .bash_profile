#!/bin/bash
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export EDITOR="nvim"
export TERMINAL="termite"
export BROWSER="firefox"
export READER="zathura"
export QT_QPA_PLATFORMTHEME=qt5ct

export XKB_DEFAULT_LAYOUT=us,gr
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
#export MOZ_ENABLE_WAYLAND=1

# Declutter ~
export GNUPGHOME=${XDG_CONFIG_HOME}/gnupg
export INPUTRC="$HOME/.config/inputrc"
[ -f ~/.config/bash/bashrc ] && source ~/.config/bash/bashrc

# Start X if its not already running.
#[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

# Start sway if its not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x sway >/dev/null && sway >/dev/null
