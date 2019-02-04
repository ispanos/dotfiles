#
# ~/.bashrc
#
[[ $- != *i* ]] && return
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
complete -cf sudo
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s checkwinsize
shopt -s autocd

export PS1="\W \\$ \[$(tput sgr0)\]"

alias free='free --mebi'
alias mkd="mkdir -pv"
alias yt="youtube-dl --add-metadata"
alias cp='cp --interactive'
alias df='df --human-readable'

# Launch text editor
alias sb='subl3'
alias ssb='sudo subl3'

# Git
alias g='git'
alias gs='git status'
alias ga='git add -A'
alias gp='git push'
alias gc='git commit -m'
alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias dotc='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m'
alias dots='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME status'

# Pacman
alias p='sudo pacman'
alias pc="pacman -Qq | wc -l"

# Add color
alias ls='ls --literal --human-readable --color=auto --group-directories-first '
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias hcat='highlight --out-format=ansi'
alias hcatt='highlight --src-lang'
alias diff="diff --color=auto"

# Other
alias starwars='telnet towel.blinkenlights.nl'
alias printascii='man ascii | grep -m 1 -A 63 --color=never Oct'
