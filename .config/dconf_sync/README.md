# Selective dconf sync

`dconf_sync` treats the settings already present in these keyfiles as an exact
allowlist. `dconf_sync export` updates their values without scanning whole
subtrees. There is one exception: when the `custom-keybindings` list is tracked,
export also captures the `name`, `command`, and `binding` of each referenced
custom keyboard shortcut. Other new keys require an explicit addition.

Managed settings live in `~/.config/dconf_sync`, or
`$XDG_CONFIG_HOME/dconf_sync` when `XDG_CONFIG_HOME` is set.
This directory contains `dconf.ini`, `dconf.d/`, and this README.
The native dconf database stays in `~/.config/dconf/user`.
The script does not load managed files from the old directory.

The script requires Python 3.10 or newer and the `dconf` command.
The script has no third-party Python dependencies.
HTML reports also require `xdg-open` to open your default browser.

Commands:

```sh
dconf_sync audit   # check tracked values for common personal-data leaks
dconf_sync diff    # compare saved and live settings, with color in a terminal
dconf_sync diff --html  # open the drift report in your browser
dconf_sync show    # open all saved values in one HTML page
dconf_sync export  # update tracked values and capture referenced shortcuts
dconf_sync apply   # write the allowlisted values to this device
dconf_sync test    # run the automated test suite
```

The old `--dump`/`-d` and `--load`/`-l` flags remain as aliases.

## Review drift before syncing

Run `dconf_sync diff` to see changed keys grouped by file. Saved values appear
in red and live values in green. Each key also has a text label, so color is
not required. Unchanged keys are omitted.

Use `dconf_sync diff --color always` to force color, or `--color never` to
disable it. Automatic color is disabled for redirected output and when
`NO_COLOR` is set.

To compare the browser version, run:

```sh
dconf_sync diff --html
```

The HTML report shows saved and live values side by side. It uses no external
assets or scripts. The report is a private temporary file, readable only by
your user.
Both HTML commands print the temporary file path and open it with `xdg-open`.
If opening fails, the command reports an error and keeps the file for manual opening.
Delete the printed file after review when you no longer need it.

Both versions report the same differences without changing the saved files
or live settings. The HTML command writes only its report. The commands return
zero when comparison succeeds, even if drift exists, and nonzero on errors.

Read the labels as follows:

- `CHANGED`: apply restores the saved value; export saves the live value.
- `NEW`: export adds a field from a referenced custom shortcut. Apply leaves
  that field alone until it is saved.
- `UNSET`: dconf has no explicit live value. Export keeps the saved value;
  apply writes it. The report does not resolve application defaults.

The report also shows audit issues that would block apply or export. Comparison
uses serialized dconf values, so equivalent values with different formatting
can appear as differences. Live reads happen sequentially. Avoid changing
settings during comparison or export.

The scope is tracked keys plus referenced custom shortcuts, not all of dconf.
Use `apply` when the saved configuration is the version you want on this device.
Use `export` when you want to keep the live changes, then review `git diff`.

## Browse all saved values

Run `dconf_sync show` to create and open one HTML file with every managed
saved value, including unchanged settings.
The page groups keys by source file and includes links to each group.
It shows full dconf paths and the values as stored in the keyfiles.
It does not read live dconf values or change any settings.

The page includes `dconf.ini`, files directly inside `dconf.d/`,
and files directly inside `dconf.d/extensions/`.
It does not treat the README or unrelated files as settings.

## Capture custom keyboard shortcuts

Keep `custom-keybindings` in the root section of
`dconf.d/org.gnome.settings-daemon.plugins.media-keys`. After you add a shortcut
in GNOME Settings, run:

```sh
dconf_sync diff
dconf_sync export
```

Export reads the live list and adds missing `name`, `command`, and `binding`
keys for each referenced shortcut to the same file. Existing partial sections
are completed without creating duplicate sections. You do not need to dump
the media-keys subtree or copy sections manually. This also works when the
list is saved under its full section path in `dconf.ini`.

Only paths directly under
`/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/` are accepted.
Unreferenced new shortcuts and unrelated fields are not discovered. An unset
list adds nothing; an unset shortcut field produces a warning. New values pass
the same privacy audit as existing values before any file is updated.

Deleting a shortcut in GNOME updates the exported list, but its saved section
is retained. The list controls which shortcuts GNOME uses. Remove obsolete
sections manually if you want to clean them up. To stop managing an active
shortcut's fields, remove the tracked `custom-keybindings` key as well, or remove the shortcut
from the live list before exporting; otherwise export discovers those fields again.

Apply continues to write the keys already saved in the files. It does not
discover live shortcuts or reset keys absent from the files.

## Adding another key

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

Except for referenced custom shortcut fields, export only updates a key after
this explicit addition. To make a setting
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
git diff -- .config/dconf_sync
```

Automatic exports are intentionally not configured. On multiple devices, a
background export could leave device-specific working-tree changes that
conflict with a later pull. Manual export keeps `git diff` as the review and
approval boundary.

Run the automated tests from any directory with:

```sh
dconf_sync test
```
