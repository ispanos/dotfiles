#!/usr/bin/env bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export BROWSER="firefox"
export READER="zathura"
export QT_QPA_PLATFORMTHEME=qt5ct

# Declutter ~
export GNUPGHOME="$HOME/.config/gnupg"
export INPUTRC="$HOME/.config/inputrc"
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir $HOME/.config/gtk-2.0
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
[ ! -d "$HOME/.config/zsh" ] && mkdir 
export ZDOTDIR="$HOME/.config/zsh"

# [ -f ~/.bashrc ] && source ~/.bashrc
echo "$0" | grep "bash$" >/dev/null && [ -f ~/.bashrc ] && source "$HOME/.bashrc"

# Uncomment for i3/sway if no Display manager is used.
# source "$HOME.local/bin/wm-scripts/wm_init_profile