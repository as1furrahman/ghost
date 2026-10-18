# Ghost 👻

> Minimalist, high-productivity, research-focused configuration for [Ghostty](https://ghostty.org/).

`ghost` is tuned for a borderless, keyboard-driven terminal workflow on Linux/Wayland with smooth cursor physics, per-surface resource containment, and low-distraction ergonomics.

---

## Highlights

- **Stealth Aesthetic**: Completely borderless (`window-decoration = none`, hidden top tab bar), 0.92 background opacity with cell-level transparency support for Neovim/tmux, and balanced padding.
- **Smooth Cursor Physics**: Custom GLSL cursor warp shader (`shaders/cursor_warp.glsl`) offering Neovide-like fluid cursor glide trails.
- **Typography & Ligatures**: Tuned for `Cascadia Code NF` (and `Cascadia Mono NF`) at 13pt with explicit ligatures (`+calt, +liga`) and 25% icon height adjustment.
- **Performance & Isolation**:
  - `gtk-single-instance = true` drops launch latency from ~250ms to ~15ms.
  - Systemd cgroups soft memory throttling (8 GiB) and hard fork-bomb process ceiling (8192 tasks).
  - 50 MB lazily-allocated scrollback buffer per surface.
- **Dropdown Scratch Terminal**: Global shortcut portal support (`Ctrl+\``) for an autohiding dropdown quake terminal.
- **Modular Overrides**: Loads `?local.conf` automatically if present without polluting git history.

---

## Directory Structure

```text
ghost/
├── config                # Core Ghostty configuration
├── shaders/
│   └── cursor_warp.glsl  # Custom OpenGL cursor animation shader
├── .gitignore            # Ignores local.conf and OS metadata
└── README.md
```

---

## Installation & Symlinking

To link `ghost` to your Ghostty config directory:

```bash
# Ensure Ghostty config directory exists
mkdir -p ~/.config/ghostty/shaders

# Symlink config
ln -sf ~/Projects/ghost/config ~/.config/ghostty/config

# Symlink custom shaders
ln -sf ~/Projects/ghost/shaders/cursor_warp.glsl ~/.config/ghostty/shaders/cursor_warp.glsl
```

### Themes & System Auto-Switching
Ghostty automatically tracks your desktop environment's appearance (light or dark mode):
```ini
theme = light:Melange Light,dark:Melange Dark
window-theme = auto
```
You can customize this to any pair or override it locally in `local.conf`.

---

## Keybindings Cheat Sheet

| Category | Shortcut | Action |
| :--- | :--- | :--- |
| **Quick Terminal** | `global:Ctrl+\`` | Toggle top dropdown scratch terminal (45% height) |
| **Splits** | `Ctrl+Shift+O` / `Ctrl+Shift+E` | Split right / Split down |
| | `Ctrl+Alt+Arrows` | Navigate between splits |
| | `Super+Ctrl+Shift+Arrows` | Resize active split |
| | `Alt+=` / `Ctrl+Shift+G` | Equalize all splits |
| | `Ctrl+Shift+Enter` | Toggle split zoom (preserved across navigation) |
| | `Ctrl+Shift+X` | Close active split (without closing the tab) |
| **Tabs** | `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / Previous tab |
| | `Alt+1..9` | Go to tab 1–9 / Last tab |
| | `Ctrl+Shift+B` | Toggle visual tab overview / buffer picker |
| | `Alt+Shift+Left/Right` | Move active tab position |
| | `Alt+Shift+T` | Rename tab |
| **Productivity** | `Ctrl+Shift+M` | Toggle mouse reporting (copy text in TUIs like htop/Neovim) |
| | `Alt+U` | Copy URL currently under cursor to clipboard |
| | `Ctrl+Alt+E` | Dump scrollback into `$EDITOR` |
| | `Ctrl+Shift+S` | Search selection directly |
| | `Ctrl+Shift+L` | Clear screen and wipe scrollback |
| **Safety & System**| `Ctrl+Alt+R` | Toggle read-only guard (locks surface from keystrokes) |
| | `Ctrl+Shift+D` | Toggle window decorations / titlebars |
| | `Ctrl+Shift+R` | Reload configuration instantly |
