autoload -U colors && colors

# Use git-prompt.sh for git if present.
if [[ `command -v git` ]]; then
source $HOME/.local/bin/helpers/git-prompt.sh
setopt PROMPT_SUBST
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%c\$(__git_ps1 \" (%s)\") %{$fg[red]%}]%{$reset_color%}$%b "
fi
