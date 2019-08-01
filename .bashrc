#!/bin/bash
[[ $- != *i* ]] && return
shopt -s checkwinsize
stty -ixon
complete -cf sudo
shopt -s autocd
[ -f "$HOME/.config/bash/aliasrc" ] && source "$HOME/.config/bash/aliasrc"
[ -r /usr/share/bash-completion/bash_completion   ] && source /usr/share/bash-completion/bash_completion

export PS1="\[$(tput setaf 4)\]\u\[$(tput setaf 1)\]@\[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 7)\] \\$ \[$(tput sgr0)\]"

# History Managment.
	export HISTCONTROL=ignoredups:erasedups  
	export HISTSIZE=9999
	export HISTFILESIZE=9999
	export HISTFILE="$HOME/.config/bash/history"
	PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" 
	[ -s "$HISTFILE" ] || echo "#!/bin/bash" > $HISTFILE
	shopt -s histappend