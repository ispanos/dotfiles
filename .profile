#!/usr/bin/env bash

# Declutter ~
export GNUPGHOME="$HOME/.config/gnupg"
export INPUTRC="$HOME/.config/inputrc"
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir $HOME/.config/gtk-2.0
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
[ ! -d "$HOME/.config/zsh" ] && mkdir "$HOME/.config/zsh"
export ZDOTDIR="$HOME/.config/zsh"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if echo $0 | grep -q bash && [ -f ~/.bashrc ]; then
    source "$HOME/.bashrc"
fi

# init script for i3/ sway
if [ -d "$HOME/.local/bin/wm-scripts" ]; then
	PATH="$HOME/.local/bin/wm-scripts/:$PATH"
    [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] &&
        source "$HOME/.local/bin/wm-scripts/wm_init_profile"
fi
