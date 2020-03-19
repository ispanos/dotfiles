autoload -U colors && colors

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

autoload -Uz compinit && compinit
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%c %{$fg[red]%}]%{$reset_color%}$%b "

# Use git-prompt.sh for git if present.
if [[ `command -v git` ]] && [[ -f "$HOME/.local/bin/helpers/git-prompt.sh" ]]; then
    source $HOME/.local/bin/helpers/git-prompt.sh
    setopt PROMPT_SUBST
    PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%c\$(__git_ps1 \" (%s)\") %{$fg[red]%}]%{$reset_color%}$%b "
fi

# History
export HISTFILE=$ZDOTDIR/zsh_history
[[ -f "$HISTFILE" ]] || touch $HISTFILE
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=9999
export HISTFILESIZE=9999
setopt appendhistory
SAVEHIST=100

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null