#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

complete -cf sudo
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

