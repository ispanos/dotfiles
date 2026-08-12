# Selective dconf sync

`dconf_sync` treats the settings already present in these keyfiles as an exact
allowlist. `dconf_sync export` updates their values, but never discovers new
keys from a whole subtree. This keeps transient state and newly introduced
personal-data fields out of Git unless they are explicitly added.

The script requires Python 3.10 or newer and the `dconf` command. It has no
third-party Python dependencies.

Commands:

```sh
dconf_sync audit   # check tracked values for common personal-data leaks
dconf_sync export  # update the allowlisted values from this device
dconf_sync apply   # write the allowlisted values to this device
dconf_sync test    # run the automated test suite
```

The old `--dump`/`-d` and `--load`/`-l` flags remain as aliases.

## Adding a key

Use `dconf watch /` and change the setting in GNOME to discover its full key.
You can then read its current GVariant value directly. For example:

```sh
dconf read /org/gnome/desktop/interface/accent-color
```

Add the output to the keyfile named after the key's parent path. The example
above belongs in `dconf.d/org.gnome.desktop.interface`:

```ini
[/]
accent-color='blue'
```

Represent any path below that parent with a section. For example,
`/org/gnome/Ptyxis/Profiles/PROFILE_ID/palette` belongs in
`dconf.d/org.gnome.Ptyxis` as:

```ini
[Profiles/PROFILE_ID]
palette='Monokai Pro'
```

GNOME Shell extension keys under `/org/gnome/shell/extensions/EXTENSION_NAME/`
belong in `dconf.d/extensions/EXTENSION_NAME`.

After adding a key, verify the result:

```sh
dconf_sync audit
dconf_sync export
git diff
```

Export will only update the key after this explicit addition. To make a setting
machine-local again, remove its line from the tracked keyfile; apply and export
will then leave it alone.

Unset values are intentionally not removed during export because removing a
line would also remove it from the allowlist. Delete such a line manually when
you no longer want to manage the key.

The audit is a conservative guard, not a general secret scanner. It rejects
home/removable-media paths, file URIs, email addresses, and common credentials
in URLs. Always review `git diff` before committing or pushing.

Run exports manually when you are ready to review and commit settings:

```sh
dconf_sync export
git diff -- .config/dconf
```

Automatic exports are intentionally not configured. On multiple devices, a
background export could leave device-specific working-tree changes that
conflict with a later pull. Manual export keeps `git diff` as the review and
approval boundary.

Run the automated tests from any directory with:

```sh
dconf_sync test
```
