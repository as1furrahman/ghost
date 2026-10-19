#!/usr/bin/env bash
set -euo pipefail

# Determine repo directory (supports both local checkout and curl | bash)
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    REPO_DIR="${GHOST_DIR:-$HOME/.local/share/ghost}"
    if [ ! -d "$REPO_DIR" ]; then
        echo "📦 Cloning ghost repository to $REPO_DIR..."
        git clone https://github.com/as1furrahman/ghost.git "$REPO_DIR"
    else
        echo "🔄 Updating ghost repository at $REPO_DIR..."
        git -C "$REPO_DIR" pull --ff-only || true
    fi
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"

OS_TYPE="$(uname -s)"
if [ "$OS_TYPE" = "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

echo "👻 Installing Ghost Ghostty Configuration..."

# 1. Ensure target config directory exists
mkdir -p "$CONFIG_DIR"

# 2. Backup existing regular config files (skip symlinks: those are ours)
for CONFIG_FILE in config.ghostty config; do
    if [ -f "$CONFIG_DIR/$CONFIG_FILE" ] && [ ! -L "$CONFIG_DIR/$CONFIG_FILE" ]; then
        BACKUP_PATH="$CONFIG_DIR/$CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
        echo "📦 Backing up existing $CONFIG_FILE to $BACKUP_PATH"
        mv "$CONFIG_DIR/$CONFIG_FILE" "$BACKUP_PATH"
    fi
done

# 3. Create config symlink. Ghostty 1.3 documents `config.ghostty`; the legacy
# `config` name still loads, but `config.ghostty` wins when both exist, so drop
# a stale legacy link to keep exactly one source of truth.
echo "🔗 Linking config.ghostty -> $CONFIG_DIR/config.ghostty"
ln -sf "$REPO_DIR/config.ghostty" "$CONFIG_DIR/config.ghostty"
if [ -L "$CONFIG_DIR/config" ]; then
    echo "🧹 Removing legacy config symlink"
    rm -f "$CONFIG_DIR/config"
fi

# 4. Optional shaders directory link
if [ -f "$REPO_DIR/shaders/cursor_warp.glsl" ]; then
    mkdir -p "$CONFIG_DIR/shaders"
    ln -sf "$REPO_DIR/shaders/cursor_warp.glsl" "$CONFIG_DIR/shaders/cursor_warp.glsl"
fi

# 5. Font detection & automatic installer
HAS_FONT=false
if command -v fc-list &>/dev/null && fc-list "Cascadia Code NF" : family | grep -i "Cascadia Code NF" >/dev/null; then
    HAS_FONT=true
elif [ "$OS_TYPE" = "Darwin" ] && [ -d "$FONT_DIR/CascadiaCode" ]; then
    HAS_FONT=true
fi

if [ "$HAS_FONT" = true ]; then
    echo "✅ 'Cascadia Code NF' font is installed."
else
    echo "⚠️  'Cascadia Code NF' font was not detected."
    INSTALL_FONT="n"
    if [ -t 0 ]; then
        read -p "Would you like to auto-download CascadiaCode Nerd Font? [Y/n] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Nn]$ ]] && INSTALL_FONT="y"
    else
        INSTALL_FONT="y"
    fi

    if [ "$INSTALL_FONT" = "y" ] && command -v curl &>/dev/null && command -v tar &>/dev/null; then
        echo "⬇️  Downloading CascadiaCode Nerd Font..."
        mkdir -p "$FONT_DIR/CascadiaCode"
        curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.tar.xz" | tar -xJ -C "$FONT_DIR/CascadiaCode"
        if command -v fc-cache &>/dev/null; then
            fc-cache -fv "$FONT_DIR/CascadiaCode" > /dev/null || true
        fi
        echo "✅ CascadiaCode Nerd Font installed successfully!"
    else
        echo "ℹ️  Please install 'Cascadia Code NF' manually if icons do not render."
    fi
fi

# 6. Validate configuration if ghostty is installed
if command -v ghostty &>/dev/null; then
    echo "🔍 Validating Ghostty configuration..."
    if ghostty +validate-config; then
        echo "✨ Setup complete! Ghostty configuration verified 10/10."
    fi
else
    echo "ℹ️  Ghostty binary not found. Install it from https://ghostty.org/docs/install"
fi

# 7. Linux launchers pass --shell-integration-features=ssh-env, and a CLI value
#    replaces the config value wholesale instead of merging with it, which
#    silently disables the config's `sudo` feature. Ship sanitised user-level
#    copies so every launch path (desktop entry and D-Bus activation) honours
#    the config. Regenerated on each run, so re-run this script after upgrades.
if [ "$OS_TYPE" = "Linux" ]; then
    DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
    for LAUNCHER in \
        "/usr/share/applications/com.mitchellh.ghostty.desktop:$DATA_DIR/applications/com.mitchellh.ghostty.desktop" \
        "/usr/share/dbus-1/services/com.mitchellh.ghostty.service:$DATA_DIR/dbus-1/services/com.mitchellh.ghostty.service"; do
        SRC_FILE="${LAUNCHER%%:*}"
        DEST_FILE="${LAUNCHER#*:}"
        [ -f "$SRC_FILE" ] || continue
        mkdir -p "$(dirname "$DEST_FILE")"
        sed 's/ --shell-integration-features=ssh-env//' "$SRC_FILE" > "$DEST_FILE"
        echo "🔧 Launcher override written: $DEST_FILE"
    done
    echo "ℹ️  Restart Ghostty (or re-login for D-Bus) to pick up the launcher overrides."
fi
