# MacGNOME GTK4 Buttons

Minimal macOS-style window control buttons for GNOME (GTK4).

![https://github.com/Vascon11/Fedora-_Customizado/blob/main/Pictures/Captura%20de%20tela%20de%202026-03-26%2015-22-06.png?raw=true](https://raw.githubusercontent.com/Vascon11/Fedora-_Customizado/refs/heads/main/Pictures/Captura%20de%20tela%20de%202026-03-26%2015-22-06.png)

## ✨ Features

- Rounded macOS-like window buttons
- Subtle hover icons
- Works with GNOME (GTK4 apps only)
- Lightweight (CSS only)

## ⚠️ Limitations

- Tested only on Fedora (GNOME)
- Works ONLY on GTK4 apps
- Does NOT affect:
  - Firefox
  - Chromium-based apps
  - Electron apps (VS Code, Discord)
- May break with custom GTK themes (like WhiteSur)

## 📦 Installation

```bash
git clone https://github.com/seu-usuario/macgnome.git
cd macgnome
chmod +x install.sh
./install.sh
```

## 🔄 Apply changes

After installation, you need to reload GNOME for the changes to take effect.

### Recommended (most reliable)
Log out and log back in.

### Alternative (may work)
Restart GNOME Shell:

- Press `Alt + F2`
- Type `r` and press Enter (X11 only)
