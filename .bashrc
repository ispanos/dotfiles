#!/bin/bash

complete -cf sudo
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
