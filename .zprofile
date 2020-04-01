#!/usr/bin/env bash

# Declutter ~ // https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# NPM
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config

# GTK-2
[ ! -d "${XDG_CONFIG_HOME}/gtk-2.0" ] && mkdir ${XDG_CONFIG_HOME}/gtk-2.0
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"

# ZSH
[ ! -d "${XDG_CONFIG_HOME}/zsh" ] && mkdir "${XDG_CONFIG_HOME}/zsh"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Rust - Cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
if [ -d "${CARGO_HOME}/bin" ]; then
    PATH="${CARGO_HOME}/bin:$PATH"
fi

# Wine
[ ! -d "$XDG_DATA_HOME/wineprefixes" ] && mkdir -p "$XDG_DATA_HOME/wineprefixes"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority" # This will break some DMs.
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi


export SUDO_ASKPASS=dmenupass
export EDITOR="code"
export TERMINAL="gnome-terminal"
export BROWSER="firefox"
export QT_QPA_PLATFORMTHEME=qt5ct
export PATH="$HOME/.local/bin/wm-scripts/:$PATH"


# init function for i3wm
i3start(){
	[ ! -d "${XDG_DATA_HOME}/xorg" ] && mkdir -p ${XDG_DATA_HOME}/xorg
	logfile="${XDG_DATA_HOME}/xorg/$(date +%Y_%m_%d-%Hh%Mm%Ss).log"
	touch "$logfile"
	i3confmerge
	exec startx /usr/bin/i3 > "$logfile" 2>&1
}

# init function for Sway
swaystart() {
	export XKB_DEFAULT_LAYOUT=us,gr
	export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
	#export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
	#export QT_QPA_PLATFORM=wayland
	#export MOZ_ENABLE_WAYLAND=1
	[ ! -d "${XDG_DATA_HOME}/sway" ] && mkdir -p "${XDG_DATA_HOME}/sway"
	logfile="${XDG_DATA_HOME}/sway/$(date +%Y_%m_%d-%Hh%Mm%Ss).log"
	sway  > "$logfile" 2>&1
}

[[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return
if [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ]; then
	i3start

elif [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ]; then
	swaystart
fi
