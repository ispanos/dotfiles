#!/usr/bin/env bash

# sudo install -Dm644 declutter.sh  "/usr/local/share/ptinopedila/declutter.sh"

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

# Ruby
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem

# Vagrant
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant

# GTK-2
[ ! -d "${XDG_CONFIG_HOME}/gtk-2.0" ] && mkdir ${XDG_CONFIG_HOME}/gtk-2.0
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"

# # Java
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# Jupyter
export JUPYTER_PLATFORM_DIRS=1

# Rust - Cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
[ -d "${CARGO_HOME}/bin" ] && appendpath "${CARGO_HOME}/bin"

# R
export R_LIBS_USER=${XDG_DATA_HOME:-$HOME/.local/share}/R/%p-library/%v
[[ $(command -v Rscript) ]] &&
mkdir -p "$(Rscript -e 'cat(Sys.getenv("R_LIBS_USER"))')"
# export R_PROFILE_USER=${XDG_CONFIG_HOME:-$HOME/.config}/R/rprofile
# export R_ENVIRON_USER=${XDG_CONFIG_HOME:-$HOME/.config}/R/renviron

# Julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"

# Octave
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"

	## $XDG_CONFIG_HOME/octave/octaverc
	# source /usr/share/octave/site/m/startup/octaverc;
	# pkg prefix ~/.local/share/octave/packages ~/.local/share/octave/packages;
	# pkg local_list /home/<your username>/.local/share/octave/octave_packages;
	## The local_list option must be given an absolute path. 

# CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv


# Wine
[ ! -d "$XDG_DATA_HOME/wineprefixes" ] && mkdir -p "$XDG_DATA_HOME/wineprefixes"
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

export INPUTRC="${XDG_CONFIG_HOME}/inputrc"

# This will break some apps that hard-code ~/.gnupg
# export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

[ -f "$HOME/.steampid" ] && rm "$HOME/.steampid" || true
[ -L "$HOME/.steampath" ] && rm "$HOME/.steampath" || true
