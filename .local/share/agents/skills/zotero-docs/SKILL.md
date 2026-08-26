---
name: zotero-docs
description: Use it for questions about the official Zotero documentation. Do not use it for actions that involve the local API. Search and interpret the official Zotero documentation from an optional local shallow clone, provisioning or refreshing that clone only after user consent. Use for Zotero setup, troubleshooting, syncing, storage, attachments, citation behavior, translators, plugins, Web API, local API, connector behavior, or other questions not covered by the installed Zotero operational skill.
---

# Zotero Docs

Use the official Zotero documentation as an independently managed local reference at:

```text
~/.local/share/zotero-docs
```

The skill must work whether or not this clone already exists. Treat its `content/` directory as read-only documentation.

## Bootstrap or refresh with consent

Never clone, fetch, pull, or otherwise use network data automatically. The user may be on a metered connection.

### First use: clone absent

Check locally without network access:

```bash
test -d ~/.local/share/zotero-docs/content
```

If the directory is absent:

1. Tell the user that the official documentation is not installed locally.
2. Ask whether they want the agent to create a shallow clone.
3. Only after explicit agreement, run:

   ```bash
   git clone --depth 1 \
     https://github.com/zotero/zotero-docs.git \
     ~/.local/share/zotero-docs
   ```

4. Verify that `~/.local/share/zotero-docs/content` exists before using it.

Do not require the user to run the clone command themselves. The agent should offer to perform it after receiving consent. If the user declines or has not answered, do not access the network; explain that the local documentation is unavailable.

### Later use: clone present

Inspect the current revision and its age without network access:

```bash
git -C ~/.local/share/zotero-docs log -1 --format='%cI %h %s'
revision_time=$(git -C ~/.local/share/zotero-docs log -1 --format='%ct')
current_time=$(date +%s)
age_seconds=$((current_time - revision_time))
```

If `age_seconds` is at most `604800` (seven days), use the local clone without
prompting for an update. If it is greater than `604800`, continue using the
existing clone when possible and append this brief note to the end of the
response:

> The local Zotero documentation is more than a week old. Ask me to update it if you want the latest version.

Update the clone only after the user explicitly asks or agrees to run:

```bash
git -C ~/.local/share/zotero-docs pull --ff-only
```

If freshness is essential to the answer, flag the uncertainty and ask whether
to update before proceeding rather than relying silently on documentation over
a week old. Never access the network without explicit agreement.

The clone is shallow because ordinary documentation work needs the current files, not repository history, and minimizing transfer matters on metered connections. Do not run `git fetch --unshallow` unless the user explicitly requests historical analysis and authorizes the additional download.

## Search workflow

1. Use the installed `Zotero` skill for ordinary library operations, BibTeX export, and citation insertion. Use this skill for official documentation beyond that helper's coverage.
2. Complete the consent-aware bootstrap or refresh check above.
3. Search narrowly with `rg` before reading files:

   ```bash
   rg -n -i 'search terms' ~/.local/share/zotero-docs/content
   rg --files ~/.local/share/zotero-docs/content | rg -i 'topic|api|sync'
   ```

4. Read only the relevant Markdown pages, following direct links when necessary.
5. Base the answer on the official documentation and identify the relevant local source files. Preserve distinctions among the Zotero Web API, the Desktop local API, the connector server, and the Zotero JavaScript API.
6. If the documentation does not cover an implementation detail, say so. Do not infer undocumented connector behavior as official. Inspect Zotero source code or live official pages only when needed and separately authorized.

## Storage architecture

Keep the documentation clone separate from this skill:

```text
<global-skills-directory>/zotero-docs/  # Agent instructions
~/.local/share/zotero-docs/             # Official documentation clone
```

This separation allows the skill and documentation to be installed or updated independently. Installing the skill alone is valid; the agent provisions the optional documentation clone on first use after asking.

## Safety

- Do not modify documentation files.
- Do not run `git clone`, `git pull`, `git fetch`, package installation, or an MkDocs build without explicit user authorization.
- Do not expose local Zotero library contents, attachment paths, or indexed document text unless the user's request requires them.
- Prefer read-only inspection. Ask before any action that writes to Zotero or changes its configuration.
