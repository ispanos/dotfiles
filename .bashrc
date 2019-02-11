#!/bin/bash
complete -cf sudo
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s checkwinsize
shopt -s autocd
export PS1="\e[1;30m[\em\e[1;34m\u@\e[m\e[34m\H:\e[m \w\e[1;30m]\e[m\\$ \[$(tput setaf 2)\]"
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"