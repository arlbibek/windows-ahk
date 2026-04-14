# WINDOWS-AHK

A simple and intuitive AutoHotKey script designed to enhance Windows shortcuts and improve your workflow.

[![GitHub License](https://img.shields.io/github/license/arlbibek/windows-ahk)](https://github.com/arlbibek/windows-ahk/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/arlbibek/windows-ahk)](https://github.com/arlbibek/windows-ahk/releases/latest)
[![GitHub all releases](https://img.shields.io/github/downloads/arlbibek/windows-ahk/total)](https://github.com/arlbibek/windows-ahk/releases/latest)
[![GitHub Stars](https://img.shields.io/github/stars/arlbibek/windows-ahk?style=social)](https://github.com/arlbibek/windows-ahk/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/arlbibek/windows-ahk?style=social)](https://github.com/arlbibek/windows-ahk/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/arlbibek/windows-ahk)](https://github.com/arlbibek/windows-ahk/issues)
[![Last Commit](https://img.shields.io/github/last-commit/arlbibek/windows-ahk)](https://github.com/arlbibek/windows-ahk/commits/main)
[![Repo Size](https://img.shields.io/github/repo-size/arlbibek/windows-ahk)](https://github.com/arlbibek/windows-ahk)

> [!NOTE]
> **Why WINDOWS-AHK?**
>
> Do you often find yourself repeating small, tedious tasks—like:
>
> - switching between apps (quite frequently),
> - copying text, pasting it into a browser, just to search,
> - checking the calendar just to type today's date,
> - changing text case (lowercase, **UPPER**, or Title Case),
> - or typing the same responses over and over?
>
> This project helps **eliminate those micro-frustrations** by automating repetitive actions—so you spend less time on busywork and more time on what matters.

## 🚀 Features

Here are some of the features WINDOWS-AHK offers:

- 🔄 Application switcher: Launch or toggle between apps using function keys (customizable).
- 📁 File Explorer power-shortcuts: Instantly Open file explorer or navigate to folders like Downloads, Music, or open VS Code in the current directory.
- 🧠 Hotstrings & snippets: Type /date, /addr, etc., to expand text dynamically (customizable).
- 🔤 Text case transformers: Change selected text to uppercase, lowercase, or title case instantly.
- 🔍 Quick search: Search any selected text directly in your browser.
- 🖥️ Presentation / stay awake: Toggle Windows Presentation Mode where available; on Home and similar editions, a **stay-awake** fallback keeps the system from idling to sleep while the script runs.
- 🧩 Customizable: Change actions, hotkeys, and text expansions via configuration file — no code needed!

**Learn more about AutoHotKey**

AutoHotkey is a free and open-source scripting language for Windows, originally designed to create custom keyboard shortcuts, automate tasks, and perform fast macro-creation. It empowers users of all skill levels to automate repetitive tasks in Windows applications.

- Official Website: [autohotkey.com](https://www.autohotkey.com)
- Download AutoHotkey: [autohotkey.com/download](https://www.autohotkey.com/download)

## 📖 Usage

```plaintext
CAUTION!
THESE SCRIPTS TEND TO BE VERY ADDICTIVE.
```

### Option 1

✅ _Recommended_

1. Download `windows-ahk-setup-v3.x.exe` from the latest [releases](https://github.com/arlbibek/windows-ahk/releases).
2. Run the installer
3. Done!

_Prefer the installer over `WINDOWS_AHK.exe` (portable/advanced use only)._

> [!Note]
> _**Please note:**_ _You are likely to encounter a [Windows SmartScreen warning](https://sockettools.com/kb/smartscreen-installation-warnings/) when launching `windows_ahk.exe` for the first time._
> _This is a common behavior for executables that aren't digitally signed or widely downloaded._
>
> _To proceed: Click **"More info"** on the warning screen. Then click **"Run anyway"**._

### Option 2

☑️ _Ideal for users who prefer not to run `.exe` files or want to tweak the script_

1. Download and install AutoHotKey v2 from [autohotkey.com/download](https://www.autohotkey.com/download).
2. Clone this repository and navigate to the `windows-ahk/` directory.
3. Run the `WINDOWS.ahk` script. That’s it!

## ⌨️ Keyboard Shortcuts

Explore the available keyboard shortcuts in [keyboardshortcuts.md](https://github.com/arlbibek/windows-ahk/blob/master/keyboardshortcuts.md) or download the [keyboardshortcuts.pdf](https://github.com/arlbibek/windows-ahk/blob/master/keyboardshortcuts.pdf).

## 🛠️ Customize Your Experience

You can personalize the script by editing `config.ini` (for function key behaviors and hotstrings). To do so after launching the script:

1. Right-click the tray icon → **Preferences** (or press <kbd>Alt</kbd> + <kbd>F1</kbd>)
2. Click **Open config folder** or **Edit config file**
3. Edit as needed, guidelines can be found on the config file itself or in [keyboardshortcuts.md](https://github.com/arlbibek/windows-ahk/blob/master/keyboardshortcuts.md)
4. Save changes and reload the script

## 🔄 Updates

- In-app auto-update is for the **compiled `exe` build** only (not `WINDOWS.ahk` source mode).
- Open **Preferences** and click **Check for updates**.
- If a newer release is found, click **Install update**.
- The app downloads the latest installer, launches it, and closes the current process so upgrade can complete.
- Your config stays in `%AppData%\windows-ahk\config.ini`, so settings are preserved.

### Keyboard shortcuts PDF

- `assets/keyboardshortcuts.pdf` is **not** generated in CI. When you change `keyboardshortcuts.md`, update the PDF yourself (any Markdown→PDF workflow you prefer) and commit `assets/keyboardshortcuts.pdf` so installs and release builds include it.

## 📂 Project Structure

- `WINDOWS.ahk` – Main script
- `assets/` – Icons, screenshots, and media
- `keyboardshortcuts.md` – Keyboard shortcuts documentation
- `keyboardshortcuts.pdf` – PDF version of shortcuts
- `config.ini` – User configuration (generated after first run)
- `version.txt` – App version source used by updater/build
- `installer/` – Inno Setup script for no-admin per-user install
- `scripts/build-release.ps1` – Local release build script (exe + installer)

## 🔗 Additional Resources

- 🔍 [AutoHotKey Documentation](https://www.autohotkey.com/docs/v2/)
- 📜 [AutoHotkey Script Showcase](https://www.autohotkey.com/docs/scripts/index.htm) – Discover scripts created by different authors that showcase AutoHotkey's capabilities.
- 🛠️ [Skrommel's One Hour Software](https://www.dcmembers.com/skrommel/downloads/) – More useful scripts and utilities.
- 📄 [md2pdf](https://github.com/realdennis/md2pdf) by [@realdennis](https://github.com/realdennis/) - Offline markdown to PDF converter.

## 💬 Join us on Discord

at [discord.gg/a2NyrV6PBY](http://discord.gg/a2NyrV6PBY) to connect with other Windows AHK users and get support.

[Join our Discord server!](http://discord.gg/a2NyrV6PBY)

## 📜 License

Copyleft (ↄ) 2025 Bibek Aryal

This project is licensed under the GNU General Public License v3.0 (GPLv3).
You are free to use, modify, and distribute the code under the terms of this license.

See the [LICENSE](https://github.com/arlbibek/windows-ahk/blob/master/LICENSE) file for full details.

---

Made with ❤️ by [Bibek Aryal](https://bibeka.com.np/).
