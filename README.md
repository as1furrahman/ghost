# Ghost 👻

> Pure, high-productivity, minimal configuration for [Ghostty](https://ghostty.org/).

`ghost` is tuned for a borderless, keyboard-driven terminal workflow on Linux/Wayland with zero bloat, instant launch times, per-surface resource containment, and low-distraction ergonomics.

---

## Highlights

- **Pure Minimal Aesthetic**: Completely borderless (`window-decoration = none`, hidden top tab bar), solid crisp background, dynamic system theme tracking, and balanced padding.
- **Instant Launch**: `gtk-single-instance = true` delivers ~15ms cold window spawn latency.
- **Resource Sandboxing**: Systemd cgroups soft memory ceiling (8 GiB) and hard fork-bomb process ceiling (8192 tasks).
- **50 MB Lazy History**: Ample buffer for long build logs, compiler traces, and debugging sessions.
- **Dropdown Scratch Terminal**: Global shortcut portal support (`Ctrl+\``) for an autohiding dropdown quake terminal.
- **Modular Overrides**: Loads `?local.conf` automatically if present without polluting git history.
- **Optional Cursor Shaders**: Includes smooth GLSL cursor physics in `shaders/cursor_warp.glsl` (opt-in via `local.conf`).

---

## Directory Structure

```text
ghost/
├── config                # Core Ghostty configuration (~40 lines)
├── shaders/
│   └── cursor_warp.glsl  # Optional OpenGL cursor animation shader
├── .gitignore            # Ignores local.conf and OS metadata
└── README.md
```

---

## Installation & Symlinking

```bash
# Ensure Ghostty config directory exists
mkdir -p ~/.config/ghostty

# Symlink config
ln -sf ~/Projects/ghost/config ~/.config/ghostty/config
```

---

## Essential Custom Keybindings

All standard Ghostty bindings (`Ctrl+Shift+T/W`, `Ctrl+Shift+O/E`, `Ctrl+Alt+Arrows`, `Ctrl+Shift+F`) work out of the box. Ghost only registers essential gap-fillers:

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `global:Ctrl+\`` | `toggle_quick_terminal` | Top dropdown scratchpad terminal (45% height) |
| `Alt+=` | `equalize_splits` | Reset all split sizes equally |
| `Ctrl+Shift+X` | `close_surface` | Close active pane without killing the tab |
| `Ctrl+Shift+B` | `toggle_tab_overview` | Visual tab overview (when tab bar is hidden) |
| `Ctrl+Shift+R` | `reload_config` | Instant hot reload |
| `Ctrl+Shift+M` | `toggle_mouse_reporting` | Unhook mouse reporting in TUIs (`htop`, `neovim`) |
| `Ctrl+Alt+R` | `toggle_readonly` | Lock surface to prevent accidental keystrokes |
| `Alt+U` | `copy_url_to_clipboard` | Instantly copy URL under cursor |
| `Ctrl+Alt+E` | `write_scrollback_file:open` | Dump scrollback straight into `$EDITOR` |
