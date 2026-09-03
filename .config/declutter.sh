#!/usr/bin/env bash

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

# Jupyter
export JUPYTER_PLATFORM_DIRS=1

# Rust - Cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# R
export R_LIBS_USER=${XDG_DATA_HOME:-$HOME/.local/share}/R/%p-library/%v

# Julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"

# Octave
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"

# CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv

export INPUTRC="${XDG_CONFIG_HOME}/inputrc"
