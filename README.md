# MacGNOME GTK4 Buttons

Minimal macOS-style window control buttons for GNOME (GTK4).

![https://github.com/Vascon11/Fedora-_Customizado/blob/main/Pictures/Captura%20de%20tela%20de%202026-03-26%2015-22-06.png?raw=true](https://raw.githubusercontent.com/Vascon11/Fedora-_Customizado/refs/heads/main/Pictures/Captura%20de%20tela%20de%202026-03-26%2015-22-06.png)

## ✨ Features

- Rounded macOS-like window buttons
- Subtle hover icons
- Drawn in pure CSS, so it works on top of any GTK theme
- One variable to change the size
- Lightweight (CSS only)

## 📦 Installation

```bash
git clone https://github.com/Vascon11/macgnome-buttons.git
cd macgnome-buttons
chmod +x install.sh
./install.sh --all
```

| Option | What it does |
| --- | --- |
| *(none)* | same as `--theme` |
| `--theme` | installs the button CSS |
| `--cursor` | installs the Sweet cursors and selects them |
| `--flatpak` | lets Flatpak apps see the CSS |
| `--all` | all of the above |

An existing `gtk.css` that isn't ours is backed up as `gtk.css.bak-<date>`, so
nothing is lost.

## 🎚️ Changing the size

The whole point of this theme is that the stock buttons are too small. GTK 4.16+
supports CSS variables, so the size lives in one place:

```css
windowcontrols {
  --mac-btn-size: 20px;   /* WhiteSur uses 16px */
  --mac-btn-gap: 5px;
}
```

Colors are variables too (`--mac-close`, `--mac-minimize`, `--mac-maximize`).

## 🖱️ Cursor

`--cursor` installs [Sweet cursors](https://store.kde.org/p/1393084/) by
**EliverLara** (GPL-3.0) into `~/.local/share/icons`, no `sudo` needed.

The files are not redistributed here: the installer downloads them from the KDE
Store at install time, so you always get the current version and the credit stays
with the author.

## 📦 Why `--flatpak` is needed

Flatpak points `XDG_CONFIG_HOME` at `~/.var/app/<id>/config`, so a sandboxed app
never reads `~/.config/gtk-4.0/gtk.css` — the buttons show up in native apps only.
The fix is to mount the directory where GTK actually looks:

```bash
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
```

Granting `--filesystem=~/.config/gtk-4.0` instead does **not** work: it mounts the
absolute path, which GTK never consults inside the sandbox.

## 🔀 Button order

The order of the buttons does not come from this theme. It comes from GNOME:

```bash
gsettings get org.gnome.desktop.wm.preferences button-layout
# ':minimize,maximize,close'
```

## 🎨 Using it with WhiteSur (or any full theme)

This theme only styles the window buttons, so the rest of your GTK theme is
untouched. If you force a theme on Flatpak apps, **always include the variant**:

```bash
flatpak override --user --env=GTK_THEME=WhiteSur-Dark:dark
```

Without the `:dark` suffix, and with `color-scheme` set to `prefer-dark`, GTK
loads the light variant while libadwaita refuses to inject its own stylesheet —
the result is an app with no styling at all. Note that an app that forces *light*
mode will hit the same conflict from the other side; leave those on "automatic".

## ⚠️ Limitations

- Tested only on Fedora (GNOME)
- Works ONLY on GTK4 apps
- Does NOT affect:
  - Firefox
  - Chromium-based apps
  - Electron apps (VS Code, Discord)

## 🔄 Apply changes

Restart the apps to see the change. For a session-wide refresh, log out and back in.

## 📄 License

The CSS and the installer are MIT — see [LICENSE](LICENSE).

The Sweet cursors are © EliverLara and distributed under the GPL-3.0 — see
<https://store.kde.org/p/1393084/>. They are downloaded at install time, not
redistributed in this repository.
