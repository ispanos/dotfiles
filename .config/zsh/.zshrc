autoload -U colors && colors

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


# Use git-prompt.sh for git if present.
if [[ `command -v git` ]]; then
source $HOME/.local/bin/helpers/git-prompt.sh
setopt PROMPT_SUBST
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%c\$(__git_ps1 \" (%s)\") %{$fg[red]%}]%{$reset_color%}$%b "
fi

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}