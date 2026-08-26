#!/usr/bin/env zsh

# Compatibility with Ptinopedila images that disable global Zsh startup files.
if [[ ! -o GLOBAL_RCS ]]; then
  source /etc/zshrc
fi

brew_prefix=${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}
autosuggestions="$brew_prefix/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
highlighting="$brew_prefix/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

[[ -r $autosuggestions ]] && source "$autosuggestions"
[[ -r $highlighting ]] && source "$highlighting"

unset autosuggestions brew_prefix highlighting
