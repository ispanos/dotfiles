# ~/.bashrc

#!/bin/bash
[[ $- != *i* ]] && return
[ -r "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

#shopt -s checkwinsize
stty -ixon
complete -cf sudo
shopt -s autocd

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
        
# Use git-prompt.sh for git if present.
source $HOME/.local/bin/helpers/git-prompt.sh
PS1='$(tput setaf 5)[\u@\h \W $(__git_ps1 " (%s)")]$(tput setaf 1) $(tput sgr0)\$ '

# History Managment.
[ -f "$XDG_DATA_HOME/bash/" ] || mkdir -p "$XDG_DATA_HOME/bash/"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=9999
export HISTFILESIZE=9999

[ -s "$HISTFILE" ] || echo "#!/usr/bin/env bash" > $HISTFILE
shopt -s histappend