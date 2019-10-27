#!/usr/bin/env bash
[[ $- != *i* ]] && return
[ -r "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
shopt -s checkwinsize
stty -ixon
complete -cf sudo
shopt -s autocd

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# PS1
# `[$USER`
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\["
# `@hostname`
export PS1="$PS1$(tput setaf 2)\]@\[$(tput setaf 4)\]\h "
# ` dir ]$`
export PS1="$PS1\[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

# History Managment.
export HISTCONTROL=ignoredups:erasedups  
export HISTSIZE=9999
export HISTFILESIZE=9999
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" 
[  ! -d "$HOME/.cache/bash" ] && mkdir "$HOME/.cache/bash"
export HISTFILE="$HOME/.cache/bash/history"
[ -s "$HISTFILE" ] || echo "#!/usr/bin/env bash" > $HISTFILE
shopt -s histappend

# Alias
alias \
    free="free --mebi"\
	cp="cp --interactive"\
	df="df --human-readable"\
	diff="diff --color=auto"\
	dotc="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m"\
	dots="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME status"\
	dot="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"\
	egrep="egrep --colour=auto"\
	fgrep="fgrep --colour=auto"\
	ga="git add -A"\
	gc="git commit -m"\
	grep="grep --colour=auto"\
	gs="git status"\
	hcat="highlight --out-format=ansi"\
	hcatt="highlight --src-lang"\
	ls="ls --literal --human-readable --color=auto --group-directories-first "\
	mkd="mkdir -pv"\
	pc="pacman -Qq | wc -l"\
	printascii="man ascii | grep -m 1 -A 63 --color=never Oct"\
	starwars="telnet towel.blinkenlights.nl"\
	yt="youtube-dl --add-metadata"\
	inxi="inxi -FxxxzD"


[[ `command -v lsd` ]] && alias \
	ll="lsd --human-readable --color=auto -al"\
	ls="lsd --human-readable --color=auto "

# Use neovim for vim if present.
[[ `command -v nvim` ]] && alias \
    vim="nvim" vimdiff="nvim -d" 

# For Raspberry Pi 
[[ `command -v /opt/vc/bin/vcgencmd` ]] && alias \
    temp="/opt/vc/bin/vcgencmd measure_temp"
