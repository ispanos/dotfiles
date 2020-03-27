#!/usr/bin/env bash

# Declutter ~
export GNUPGHOME="$HOME/.config/gnupg"
export INPUTRC="$HOME/.config/inputrc"
[ ! -d "$HOME/.config/gtk-2.0" ] && mkdir $HOME/.config/gtk-2.0
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
[ ! -d "$HOME/.config/zsh" ] && mkdir "$HOME/.config/zsh"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This will break some DMs.
export WINEPREFIX="$HOME/.local/share/wine" # Can be changed for every program.
# ZSH
export ZDOTDIR="$HOME/.config/zsh"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi


# i3wm/ Sway stuff
export SUDO_ASKPASS=dmenupass
#export EDITOR="nvim"
export EDITOR="code"
export TERMINAL="gnome-terminal"
export BROWSER="firefox"
export READER="zathura"
export QT_QPA_PLATFORMTHEME=qt5ct
export PATH="$HOME/.local/bin/wm-scripts/:$PATH"

# init function for i3wm
i3start(){
	[ ! -d ~/.local/xorg ] && mkdir -p ~/.local/share/xorg
	logfile=~/.local/share/xorg/$(date +%Y_%m_%d-%Hh%Mm%Ss).log
	touch "$logfile"
	i3confmerge
	exec startx /usr/bin/i3 > "$logfile" 2>&1
}

# init function for Sway
swaystart() {
	# Variables needed by only by sway.
	export XKB_DEFAULT_LAYOUT=us,gr
	#export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
	#export QT_QPA_PLATFORM=wayland
	export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
	#export MOZ_ENABLE_WAYLAND=1
	[ ! -d ~/.local/xorg ] && mkdir -p ~/.local/share/sway
	logfile=~/.local/share/sway/$(date +%Y_%m_%d-%Hh%Mm%Ss).log
	sway  > "$logfile" 2>&1
}

if [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ]; then
	[[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] && i3start

elif [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ]; then
	[[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] && swaystart
fi