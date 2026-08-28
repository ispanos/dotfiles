#!/usr/bin/env bash

set -euo pipefail

# Match the current preferred layout:
#
#   ~/Downloads, ~/Documents, ~/Music, ~/Pictures, ~/Videos
#   ~/.local/share/Desktop
#   ~/.local/share/Templates
#   ~/.local/share/Public
#
# This script updates XDG mappings. It never merges or deletes non-empty
# directories. Review any warning and move old data manually.

data_home="${XDG_DATA_HOME:-${HOME}/.local/share}"
desktop_dir="${data_home}/Desktop"
templates_dir="${data_home}/Templates"
public_dir="${data_home}/Public"
user_dirs_file="${XDG_CONFIG_HOME:-${HOME}/.config}/user-dirs.dirs"

command -v xdg-user-dirs-update >/dev/null || {
    printf 'xdg-user-dirs-update is required.\n' >&2
    exit 1
}

mkdir -p -- "${desktop_dir}" "${templates_dir}" "${public_dir}"

xdg-user-dirs-update --set DESKTOP "${desktop_dir}"
xdg-user-dirs-update --set TEMPLATES "${templates_dir}"
xdg-user-dirs-update --set PUBLICSHARE "${public_dir}"

# Remove a nonstandard variable created by the old script. The recognized name
# is XDG_PUBLICSHARE_DIR, which xdg-user-dirs-update manages above.
if [[ -f "${user_dirs_file}" ]]; then
    sed -i '/^XDG_PUBLIC_DIR=/d' "${user_dirs_file}"
fi

# Remove only empty legacy top-level directories. Never delete user data.
for legacy_dir in \
    "${HOME}/Desktop" \
    "${HOME}/Templates" \
    "${HOME}/Public"; do
    if [[ -d "${legacy_dir}" && ! -L "${legacy_dir}" ]]; then
        if ! rmdir -- "${legacy_dir}" 2>/dev/null; then
            printf 'Left non-empty legacy directory in place: %s\n' \
                "${legacy_dir}" >&2
        fi
    fi
done

printf 'Desktop:    %s\n' "$(xdg-user-dir DESKTOP)"
printf 'Templates:  %s\n' "$(xdg-user-dir TEMPLATES)"
printf 'Public:     %s\n' "$(xdg-user-dir PUBLICSHARE)"
