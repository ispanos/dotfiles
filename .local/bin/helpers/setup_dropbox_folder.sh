#!/bin/bash

set -oue pipefail
cd ~

# DROPBOX_DIRS="$(locate -rb 'Dropbox$')"
# echo $DROPBOX_DIRS

DROPBOX_DIR="${DROPBOX_DIR:-$HOME/Dropbox}"
[ ! -d "$DROPBOX_DIR" ] && exit 1

# xdg-user-dirs-update --set DOWNLOAD "$HOME/Downloads" # Default location

rmdir Videos Documents Pictures Public Desktop Templates Music
mkdir -p ~/.local/share/{Public,Desktop,Templates}

xdg-user-dirs-update --set DESKTOP "$HOME/.local/share/Desktop"
xdg-user-dirs-update --set PUBLICSHARE "$HOME/.local/share/Public"
xdg-user-dirs-update --set TEMPLATES "$HOME/.local/share/Templates"

xdg-user-dirs-update --set DOCUMENTS "$DROPBOX_DIR/Documents"
xdg-user-dirs-update --set MUSIC "$DROPBOX_DIR/Music"
xdg-user-dirs-update --set PICTURES "$DROPBOX_DIR/Pictures"
xdg-user-dirs-update --set VIDEOS "$DROPBOX_DIR/Videos"

ln -s Dropbox/Videos .
ln -s Dropbox/Documents .
ln -s Dropbox/Pictures .
ln -s Dropbox/Projects .
ln -s Dropbox/Music .
# ln -s .profile .zprofile
