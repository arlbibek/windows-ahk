# WINDOWS-AHK

A simple and intuitive AutoHotKey script designed to enhance Windows shortcuts and improve your workflow.

[GitHub License](https://github.com/arlbibek/windows-ahk/blob/master/LICENSE)
[GitHub release](https://github.com/arlbibek/windows-ahk/releases/latest)
[GitHub all releases](https://github.com/arlbibek/windows-ahk/releases/latest)
[GitHub Stars](https://github.com/arlbibek/windows-ahk/stargazers)
[GitHub Forks](https://github.com/arlbibek/windows-ahk/network/members)
[GitHub Issues](https://github.com/arlbibek/windows-ahk/issues)
[Last Commit](https://github.com/arlbibek/windows-ahk/commits/main)
[Repo Size](https://github.com/arlbibek/windows-ahk)

Do you often find yourself repeating small, tedious tasks — like switching between apps, copying text, pasting it into a browser to search, checking the calendar just to type today’s date, changing text cases, or typing the same responses over and over? This script attempts to eliminate those micro-frustrations by automating repetitive actions.

## 🚀 Features

Here are some of the features WINDOWS-AHK offers:

- 🔄 Application switcher: Launch or toggle between apps using function keys (customizable).
- 📁 File Explorer power-shortcuts: Instantly Open file explorer or navigate to folders like Downloads, Music, or open VS Code in the current directory.
- 🧠 Hotstrings & snippets: Type /date, /addr, etc., to expand text dynamically (customizable).
- 🔤 Text case transformers: Change selected text to uppercase, lowercase, or title case instantly.
- 🔍 Quick search: Search any selected text directly in your browser.
- 🖥️ Presentation mode: Toggle Windows Presentation Mode on/off.
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

✅ *Recommended*

1. Download `windows-ahk-setup-<version>.exe` from the latest [releases](https://github.com/arlbibek/windows-ahk/releases).
2. Run the installer (no admin required).
3. The app is installed per-user to `%LocalAppData%\windows-ahk`.
4. Prefer the installer over `WINDOWS_AHK.exe` (portable/advanced use only).

> **Please note:** You are likely to encounter a [Windows SmartScreen warning](https://sockettools.com/kb/smartscreen-installation-warnings/) when launching `windows_ahk.exe` for the first time.
> This is a common behavior for executables that aren't digitally signed or widely downloaded.
>
> To proceed: Click **"More info"** on the warning screen. Then click **"Run anyway"**.

### Option 2

☑️ *Ideal for users who prefer not to run `.exe` files or want to tweak the script*

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

Other preferences:
- Use **Keyboard shortcuts** button in Preferences to open the latest shortcuts PDF.
- Use tray **Show launch notification** to enable or disable startup tray notification.

## 🔄 Updates

- In-app auto-update is for the **compiled EXE build** only (not `WINDOWS.ahk` source mode).
- Open **Preferences** and click **Check for updates**.
- If a newer release is found, click **Install update**.
- The app downloads the latest installer, launches it, and closes the current process so upgrade can complete.
- Your config stays in `%AppData%\windows-ahk\config.ini`, so settings are preserved.

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