#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't put duplicate lines or lines starting with space in the history. [bash(1)]
HISTCONTROL=ignoreboth

HISTSIZE=9999
HISTFILESIZE=9999

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command & update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Disable ctrl-s and ctrl-q.
stty -ixon

complete -cf sudo

shopt -s autocd

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export PS1="\[$(tput setaf 4)\]\u\[$(tput setaf 1)\]@\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 7)\] \\$ \[$(tput sgr0)\]"

