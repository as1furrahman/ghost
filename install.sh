#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

echo "👻 Installing Ghost Ghostty Configuration..."

# 1. Create Ghostty config directory
mkdir -p "$CONFIG_DIR"

# 2. Backup existing config if it is a regular file (not our symlink)
if [ -f "$CONFIG_DIR/config" ] && [ ! -L "$CONFIG_DIR/config" ]; then
    echo "📦 Backing up existing config to $CONFIG_DIR/config.bak"
    mv "$CONFIG_DIR/config" "$CONFIG_DIR/config.bak"
fi

# 3. Symlink configuration
echo "🔗 Linking config -> $CONFIG_DIR/config"
ln -sf "$REPO_DIR/config" "$CONFIG_DIR/config"

# 4. Optional: Symlink shaders if present
if [ -d "$REPO_DIR/shaders" ]; then
    mkdir -p "$CONFIG_DIR/shaders"
    ln -sf "$REPO_DIR/shaders/cursor_warp.glsl" "$CONFIG_DIR/shaders/cursor_warp.glsl"
fi

# 5. Check font dependency
if ! fc-list : family | grep -qi "Cascadia Code NF"; then
    echo "⚠️  'Cascadia Code NF' font not detected."
    read -p "Would you like to install CascadiaCode Nerd Font automatically? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "⬇️  Downloading CascadiaCode Nerd Font..."
        mkdir -p "$FONT_DIR/CascadiaCode"
        curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.tar.xz" | tar -xJ -C "$FONT_DIR/CascadiaCode"
        fc-cache -fv "$FONT_DIR/CascadiaCode" > /dev/null
        echo "✅ CascadiaCode Nerd Font installed successfully!"
    else
        echo "ℹ️  Remember to install 'Cascadia Code NF' or set your preferred font in $CONFIG_DIR/config"
    fi
else
    echo "✅ 'Cascadia Code NF' font is already installed."
fi

# 6. Verify ghostty installation
if command -v ghostty &>/dev/null; then
    echo "🔍 Validating Ghostty configuration..."
    ghostty +validate-config
    echo "✨ Ghostty setup is complete and verified 10/10!"
else
    echo "⚠️  Ghostty is not installed yet."
    echo "   Install Ghostty from https://ghostty.org/docs/install or your package manager."
fi
