#!/usr/bin/env bash
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
	local CE="\e[0m"
	local bld="\e[1m"
	local Red="\e[31m"
	local Yel="\e[33m"
	local grn="\e[32m"
	local bl="\e[36m"
	local Mg="\e[35m"

	PS1="${bld}${Red}[${Yel}\u${grn}@${bl}\h${Mg} \W\$(__git_ps1 \" (%s)\")${Red}]${CE}\$ "
}

normal_prmt(){
	local CE="\e[0m"
	local bld="\e[1m"
	local Red="\e[31m"
	local Yel="\e[33m"
	local grn="\e[32m"
	local bl="\e[36m"
	local Mg="\e[35m"

	PS1="${bld}${Red}[${Yel}\u${grn}@${bl}\h${Mg} \W\${Red}]${CE}\$ "
}
normal_prmt
# Use git-prompt.sh for git if present.
[[ `command -v git` ]] && git_prmt

# History Managment.
export HISTCONTROL=ignoredups:erasedups  
export HISTSIZE=9999
export HISTFILESIZE=9999
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" 
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
	ll='ls --color=auto -alF'\
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
