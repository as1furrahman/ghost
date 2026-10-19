Minimal Ghostty terminal setup.

## Install

```bash
git clone https://github.com/as1furrahman/ghost.git
cd ghost
./install.sh
```

Or via one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/as1furrahman/ghost/main/install.sh | bash
```

The installer symlinks `config.ghostty` (the Ghostty 1.3 name) into
`~/.config/ghostty/` and drops any legacy `config` symlink, since the new name
takes precedence when both exist. Requires Ghostty 1.3+ — older releases only
read `config`.

On Linux it also writes sanitised user-level copies of the desktop entry and the
D-Bus service file: the distro versions pass
`--shell-integration-features=ssh-env`, and a CLI value replaces the config
value instead of merging with it, which would silently disable the `sudo`
shell-integration feature. Re-run the installer after a Ghostty upgrade to
regenerate them.

## Machine-local overrides

Put anything host-specific in `~/.config/ghostty/local.conf` — it is gitignored
and pulled in through `config-file = ?local.conf`.

## Keybindings

| Key | Action |
| :--- | :--- |
| `Ctrl+\`` | Dropdown scratchpad terminal |
| `Ctrl+Shift+P` | Toggle command palette |
| `Ctrl+Shift+Z` | Toggle split zoom |
| `Alt+=` | Equalize splits |
| `Ctrl+Shift+X` | Close active split |
| `Ctrl+Shift+D` | Toggle title bar & window decorations |
| `Ctrl+Shift+B` | Tab overview |
| `Ctrl+Shift+R` | Reload config |
| `Ctrl+Shift+M` | Toggle mouse reporting |
| `Ctrl+Alt+R` | Toggle read-only guard |
| `Alt+U` | Copy URL under cursor |
| `Ctrl+Alt+E` | Open scrollback in `$EDITOR` |
