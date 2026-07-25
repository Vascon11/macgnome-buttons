#!/usr/bin/env bash

set -euo pipefail

CSS_FILE="Macgnome.css"
GTK_DIR="$HOME/.config/gtk-4.0"
TARGET_FILE="$GTK_DIR/gtk.css"
ICON_DIR="$HOME/.local/share/icons"

# Sweet cursors, by EliverLara — GPL-3.0
# https://store.kde.org/p/1393084/
CURSOR_NAME="Sweet-cursors"
CURSOR_API="https://api.kde-look.org/ocs/v1/content/data/1393084"
CURSOR_SIZE=24

DO_THEME=false
DO_CURSOR=false
DO_FLATPAK=false

usage() {
    cat <<EOF
MacGNOME buttons — installer

Usage: ./install.sh [options]

  (no options)   same as --theme
  --theme        install the GTK4 button CSS
  --cursor       download and install the Sweet cursors, then select them
  --flatpak      let Flatpak apps see the CSS (see note below)
  --all          everything above
  -h, --help     show this

Note on --flatpak:
  Flatpak points XDG_CONFIG_HOME at ~/.var/app/<id>/config, so sandboxed
  apps never read ~/.config/gtk-4.0/gtk.css. The override below mounts it
  where GTK actually looks. Without it the buttons only show up in native
  apps.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --theme)   DO_THEME=true ;;
        --cursor)  DO_CURSOR=true ;;
        --flatpak) DO_FLATPAK=true ;;
        --all)     DO_THEME=true; DO_CURSOR=true; DO_FLATPAK=true ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1"; echo; usage; exit 1 ;;
    esac
    shift
done

# No options: keep the original behaviour.
if ! $DO_THEME && ! $DO_CURSOR && ! $DO_FLATPAK; then
    DO_THEME=true
fi

need() {
    command -v "$1" >/dev/null 2>&1 || { echo "❌ '$1' is required but not installed."; exit 1; }
}

# ---------------------------------------------------------------- theme
if $DO_THEME; then
    echo "🔧 Installing MacGNOME GTK4 buttons..."
    mkdir -p "$GTK_DIR"

    # Back up an existing gtk.css that isn't ours, keeping older backups.
    if [ -e "$TARGET_FILE" ] && [ "$(readlink -f "$TARGET_FILE")" != "$(readlink -f "$GTK_DIR/$CSS_FILE")" ]; then
        backup="$GTK_DIR/gtk.css.bak-$(date +%Y%m%d-%H%M%S)"
        echo "📦 Backing up existing gtk.css -> $(basename "$backup")"
        mv "$TARGET_FILE" "$backup"
    fi

    echo "📁 Copying $CSS_FILE..."
    cp "$CSS_FILE" "$GTK_DIR/"

    echo "🔗 Linking as gtk.css..."
    ln -sf "$GTK_DIR/$CSS_FILE" "$TARGET_FILE"
fi

# --------------------------------------------------------------- cursor
if $DO_CURSOR; then
    need curl
    need tar

    echo "🖱️  Installing $CURSOR_NAME..."
    echo "   by EliverLara, GPL-3.0 — https://store.kde.org/p/1393084/"

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    # The store hands out a signed, short-lived URL, so it has to be
    # resolved at install time instead of hard-coded.
    echo "🌐 Resolving download link..."
    url="$(curl -fsSL "$CURSOR_API" | grep -oE '<downloadlink1>[^<]+' | sed 's/<downloadlink1>//')"
    if [ -z "$url" ]; then
        echo "❌ Could not get the download link."
        echo "   Download it manually from https://store.kde.org/p/1393084/"
        echo "   and extract it into $ICON_DIR"
        exit 1
    fi

    echo "⬇️  Downloading..."
    curl -fsSL "$url" -o "$tmp/cursors.tar.xz"

    mkdir -p "$ICON_DIR"
    echo "📁 Extracting into $ICON_DIR..."
    tar -xJf "$tmp/cursors.tar.xz" -C "$ICON_DIR"

    if command -v gsettings >/dev/null 2>&1; then
        echo "🎯 Selecting the cursor theme..."
        gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME"
        gsettings set org.gnome.desktop.interface cursor-size "$CURSOR_SIZE"
    fi
fi

# -------------------------------------------------------------- flatpak
if $DO_FLATPAK; then
    need flatpak
    echo "📦 Letting Flatpak apps read the CSS..."
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi

echo ""
echo "✅ Done!"
echo ""
echo "⚠️  IMPORTANT:"
echo "- GTK4 apps only"
echo "- Restart the apps (or log out and back in) to see the change"
