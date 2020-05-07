#!/usr/bin/env bash

# Append our default paths
appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# Declutter ~ // https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# NPM
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"

# GTK-2
[ ! -d "${XDG_CONFIG_HOME}/gtk-2.0" ] && mkdir ${XDG_CONFIG_HOME}/gtk-2.0
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"

# ZSH
[ ! -d "${XDG_CONFIG_HOME}/zsh" ] && mkdir "${XDG_CONFIG_HOME}/zsh"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Rust - Cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
[ -d "${CARGO_HOME}/bin" ] && appendpath "${CARGO_HOME}/bin"

# Wine
[ ! -d "$XDG_DATA_HOME/wineprefixes" ] && mkdir -p "$XDG_DATA_HOME/wineprefixes"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

# No /.Xauthority if GDM isn't used.
pgrep -x gdm || pgrep -x gdm3 ||
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority" # This will break some DMs.

export INPUTRC="${XDG_CONFIG_HOME}/inputrc"

# This will break some apps that hard-code ~/.gnupg
#export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

# set PATH so it includes user's private bin
appendpath "$HOME/.local/bin"
appendpath "$HOME/.local/bin/wm-scripts/"
# appendpath "/var/lib/flatpak/exports/bin"
unset appendpath


export SUDO_ASKPASS=dmenupass
export EDITOR="code"
export TERMINAL="alacritty"
export BROWSER="firefox"

# Needed with no display manager.
[[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return
if [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ]; then
	# init i3wm
	i3confmerge # NEEDS FIX FOR GDM
    pgrep -x gdm || pgrep -x gdm3 || exec startx /usr/bin/i3
elif [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ]; then
	# init Sway
	export XKB_DEFAULT_LAYOUT=us,gr
	export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
	export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
	export QT_QPA_PLATFORM=wayland
	export MOZ_ENABLE_WAYLAND=1
    pgrep -x gdm || pgrep -x gdm3 || sway
fi
