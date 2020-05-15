# ~/.bashrc

#!/bin/bash
[[ $- != *i* ]] && return
[ -r "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r /usr/share/bash-completion/bash_completion ] &&
        source /usr/share/bash-completion/bash_completion

shopt -s checkwinsize
stty -ixon
complete -cf sudo
shopt -s autocd

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

git_prmt(){
        source $HOME/.local/bin/helpers/git-prompt.sh
        local CE="\[\e[0m\]"
        local bld="\[\e[1m\]"
        local Red="\[\e[31m\]"
        local Yel="\[\e[33m\]"
        local grn="\[\e[32m\]"
        local bl="\[\e[36m\]"
        local Mg="\[\e[35m\]"

        PS1="${bld}${Red}[${Yel}\u${grn}@${bl}\h${Mg} \W\$(__git_ps1 \" (%s)\")${Red}]${CE}\$ "
}
normal_prmt(){
        local CE="\[\e[0m\]"
        local bld="\[\e[1m\]"
        local Red="\[\e[31m\]"
        local Yel="\[\e[33m\]"
        local grn="\[\e[32m\]"
        local bl="\[\e[36m\]"
        local Mg="\[\e[35m\]"

        PS1="${bld}${Red}[${Yel}\u${grn}@${bl}\h${Mg} \W\${Red}]${CE}\$ "
}

# Use git-prompt.sh for git if present.
[[ `command -v git` ]] && git_prmt || normal_prmt

# History Managment.
[ -f "$XDG_DATA_HOME/bash/" ] || mkdir -p "$XDG_DATA_HOME/bash/"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=9999
export HISTFILESIZE=9999

[ -s "$HISTFILE" ] || echo "#!/usr/bin/env bash" > $HISTFILE
shopt -s histappend