#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

echo "👻 Installing Ghost Ghostty Configuration..."

# 1. Ensure target config directory exists
mkdir -p "$CONFIG_DIR"

# 2. Backup existing regular config file (skip if already a symlink)
if [ -f "$CONFIG_DIR/config" ] && [ ! -L "$CONFIG_DIR/config" ]; then
    BACKUP_PATH="$CONFIG_DIR/config.backup.$(date +%Y%m%d%H%M%S)"
    echo "📦 Backing up existing config to $BACKUP_PATH"
    mv "$CONFIG_DIR/config" "$BACKUP_PATH"
fi

# 3. Create config symlink
echo "🔗 Linking config -> $CONFIG_DIR/config"
ln -sf "$REPO_DIR/config" "$CONFIG_DIR/config"

# 4. Optional shaders directory link
if [ -f "$REPO_DIR/shaders/cursor_warp.glsl" ]; then
    mkdir -p "$CONFIG_DIR/shaders"
    ln -sf "$REPO_DIR/shaders/cursor_warp.glsl" "$CONFIG_DIR/shaders/cursor_warp.glsl"
fi

# 5. Provide local.conf.example template in config directory if missing
if [ -f "$REPO_DIR/local.conf.example" ] && [ ! -f "$CONFIG_DIR/local.conf.example" ]; then
    cp "$REPO_DIR/local.conf.example" "$CONFIG_DIR/local.conf.example"
fi

# 6. Font detection & automatic installer
if command -v fc-list &>/dev/null && fc-list : family | grep -qi "Cascadia Code NF"; then
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
        echo "ℹ️  Please install 'Cascadia Code NF' manually or customize your font in $CONFIG_DIR/local.conf"
    fi
fi

# 7. Validate configuration if ghostty is installed
if command -v ghostty &>/dev/null; then
    echo "🔍 Validating Ghostty configuration..."
    if ghostty +validate-config; then
        echo "✨ Setup complete! Ghostty configuration verified 10/10."
    fi
else
    echo "ℹ️  Ghostty binary not found. Install it from https://ghostty.org/docs/install"
fi
