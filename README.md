# ghost 👻

Minimal, high-productivity configuration for [Ghostty](https://ghostty.org/).

- **Borderless & Minimal**: Titlebars & tab strip suppressed, crisp solid background.
- **Dynamic Theming**: Automatically tracks system appearance (`Melange Light` / `Melange Dark`).
- **Instant & Safe**: GTK single-instance (~15ms cold start) + systemd cgroup isolation (8GB RAM, 8192 procs).

---

## Install

```bash
git clone git@github.com:as1furrahman/ghost.git ~/Projects/ghost
cd ~/Projects/ghost
./install.sh
```

---

## Keybindings

| Shortcut | Action |
| :--- | :--- |
| `global:Ctrl+\`` | Toggle top dropdown scratchpad |
| `Alt+=` | Equalize split sizes |
| `Ctrl+Shift+X` | Close active split |
| `Ctrl+Shift+B` | Toggle visual tab overview |
| `Ctrl+Shift+R` | Hot-reload configuration |
| `Ctrl+Shift+M` | Toggle mouse reporting (for TUIs) |
| `Ctrl+Alt+R` | Toggle read-only surface guard |
| `Alt+U` | Copy URL under cursor |
| `Ctrl+Alt+E` | Dump scrollback into `$EDITOR` |

---

## Overrides

Copy `local.conf.example` to `local.conf` to add machine-local settings without dirtying git.

## License

[MIT](LICENSE)
