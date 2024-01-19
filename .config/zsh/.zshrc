autoload -U colors && colors

setopt autocd

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

[ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

CASE_SENSITIVE="true"
autoload -Uz compinit && compinit
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Za-z}'
#zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist

[ -d "$HOME/.cache/zsh/" ] || mkdir -p "$HOME/.cache/zsh/"
compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

setopt PROMPT_SUBST
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%c%{$fg[red]%}]%{$reset_color%}$%b "

if [ -f "$HOME/.local/bin/helpers/git-prompt.sh" ]; then
	source $HOME/.local/bin/helpers/git-prompt.sh
	git_prmpt=\$(__git_ps1 \"(%s) \")
	PS1="$git_prmpt$PS1"
fi

# History
export HISTFILE=$ZDOTDIR/history
[[ -f "$HISTFILE" ]] || touch $HISTFILE
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=99999

export SAVEHIST=99999
# setopt appendhistory
# Immediate append
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
# Add timestamp to history
setopt EXTENDED_HISTORY

## KEYS START

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# TTY sends different key codes. Translate them to regular.
bindkey -s '^[[1~' '^[[H'  # home
bindkey -s '^[[4~' '^[[F'  # end

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

## KEYS END

[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || {
	[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
}

[ -f /usr/bin/starship ] && eval "$(starship init zsh)"

# Load zsh-syntax-highlighting; should be last.
highlighting_paths=(
	"/usr/share/fsh/fast-syntax-highlighting.plugin.zsh"
	"${XDG_DATA_HOME:-$HOME/.local/share}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
	"/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	"/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
# Iterate through the paths and source the first existing file
for zsh_sh_path in "${highlighting_paths[@]}"; do
  if [ -f "$zsh_sh_path" ]; then
    source "$zsh_sh_path"
    break  # Stop after the first file is found and sourced
  fi
done

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME/.local/anaconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
