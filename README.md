# SYCRONIX Framework

> **A cyberpunk-themed Termux customization framework — lightweight, modular, and highly customizable.**

<p align="center">
  <img src="assets/logo.png" alt="SYCRONIX Logo" width="600">
</p>

<p align="center">
  <b>SYCRONIX CYBER ENVIRONMENT</b><br>
  <i>ACCESS GRANTED — WELCOME BACK</i>
</p>

<p align="center">
  <a href="#-quick-install">Install</a> •
  <a href="#-features">Features</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-themes">Themes</a> •
  <a href="#-configuration">Configuration</a> •
  <a href="#-plugins">Plugins</a> •
  <a href="#-project-structure">Structure</a>
</p>

---

## Quick Install

```bash
curl -fsSL https://github.com/officialsycronix/sycronix/raw/main/install.sh | bash
```

Or clone and install manually:

```bash
git clone https://github.com/officialsycronix/sycronix.git
cd sycronix
chmod +x install.sh
./install.sh
```

## Uninstall

```bash
sycronix-reset    # Reset to defaults first
# Then remove manually or run uninstall.sh
```

---

## Features

### Dynamic System Dashboard
Displays system information on terminal launch:
- Username, device model, Android version, kernel version
- Current shell, date/time, battery percentage
- IP address (optional), system uptime
- Plugin-powered custom info modules

### Professional ASCII Banners
Multiple cyberpunk-styled SYCRONIX logos:
- 6 distinct banner styles (Default, Cyber, Neon, Matrix, Hacker, Minimal)
- Clean alignment, responsive design
- Auto-colored to match active theme

### Advanced Prompt Engine
Powerlevel10k-inspired prompt system with multiple styles:
- Username, directory, git branch, root indicator
- Exit code display, custom icons, multi-line support
- 5 prompt modes: Cyber, Neon, Matrix, Hacker, Minimal
- Fully customizable colors and icons

### Theme Engine
```bash
sycronix-theme apply cyber    # Apply cyber theme
sycronix-theme list           # List all themes
```

Available themes: **Cyber**, **Neon**, **Matrix**, **Hacker**, **Minimal**

Each theme controls:
- Color palette (primary, secondary, accent, success, error)
- Banner style
- Prompt style
- Icon set

### Interactive Configuration Wizard
```bash
sycronix-config
```

Menu-driven interface to customize everything:
- Change theme, prompt style, banner
- Toggle dashboard components
- Customize colors (hex input)
- Manage plugins
- Restore defaults

---

## Usage

| Command | Description |
|---------|-------------|
| `sycronix` | Initialize SYCRONIX environment |
| `sycronix-config` | Open interactive configuration wizard |
| `sycronix-theme list` | List available themes |
| `sycronix-theme apply <name>` | Apply a theme |
| `sycronix-update` | Check for updates |
| `sycronix-reset` | Reset configuration to defaults |
| `sycronix-version` | Show version information |

---

## Themes

| Theme | Colors | Vibe |
|-------|--------|------|
| **Cyber** | Cyan + Magenta | Classic cyberpunk |
| **Neon** | Pink + Blue | Bright neon glow |
| **Matrix** | Green on Black | Hacker aesthetic |
| **Hacker** | Amber + Green | Underground terminal |
| **Minimal** | Grayscale | Clean and subtle |

---

## Configuration

Configuration file: `~/.config/sycronix/sycronix.conf`

Key settings:

```bash
SYCRONIX_THEME="cyber"              # Current theme
SYCRONIX_BANNER="default"           # Banner style
SYCRONIX_PROMPT_STYLE="cyber"       # Prompt style

# Dashboard toggles
SYCRONIX_SHOW_BANNER="true"
SYCRONIX_SHOW_DASHBOARD="true"
SYCRONIX_SHOW_BATTERY="true"
SYCRONIX_SHOW_IP="false"
SYCRONIX_SHOW_UPTIME="true"

# Prompt options
SYCRONIX_PROMPT_MULTILINE="true"
SYCRONIX_PROMPT_SHOW_GIT="true"
SYCRONIX_PROMPT_SHOW_EXIT_CODE="true"

# Custom colors (hex)
SYCRONIX_COLOR_PRIMARY="#00ffcc"
SYCRONIX_COLOR_SECONDARY="#ff00ff"
```

---

## Plugins

SYCRONIX supports a plugin architecture for extending functionality.

### Built-in Plugins
- **Weather** — Display current weather (requires curl)
- **Network Monitor** — Show active network interface
- **Battery Monitor** — Battery percentage and status
- **Git Status** — Enhanced git repository status

### Custom Plugins
Create your own plugins in `~/.config/sycronix/plugins/`:

```bash
# ~/.config/sycronix/plugins/myplugin.plugin
PLUGIN_NAME="My Plugin"
PLUGIN_DESC="My custom plugin"

__sycronix_plugin_myplugin() {
  echo " Custom: $(my_custom_command)"
}
```

Plugins are automatically sourced and executed on terminal start.

---

## Project Structure

```
~/.config/sycronix/
├── sycronix.conf          # User configuration
├── themes/                # Theme files (*.theme)
├── banners/               # Banner files (*.banner)
├── prompts/               # Prompt styles (*.prompt)
├── plugins/               # User plugins (*.plugin)
└── cache/                 # Cache directory

System installation:
${PREFIX}/bin/
├── sycronix               # Main command
├── sycronix-config        # Configuration wizard
├── sycronix-theme         # Theme manager
├── sycronix-update        # Update checker
├── sycronix-reset         # Reset to defaults
└── sycronix-version       # Version info
```

---

## Requirements

- **Termux** (primary target) or any Unix-like terminal
- **Bash** ≥ 4.0 or **Zsh**
- Optional: `curl` (weather plugin, update checks)

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

<p align="center">
  <b>SYCRONIX CYBER ENVIRONMENT</b><br>
  <i>Made with ⚡ for the terminal</i>
</p>
