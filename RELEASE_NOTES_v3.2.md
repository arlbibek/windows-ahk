# windows-ahk v3.2

## Updates

- **Unix epoch hotstrings** — Type **`/epoch`**, **`/unix`**, or **`/unixtime`** to insert the current **UTC Unix time** in seconds (POSIX epoch), handy for APIs, logs, and scheduling.
- **Presentation mode on Windows Home** — If **Presentation Settings** is not available (common on **Home**), the same tray action and **Win+Shift+P** use a **stay-awake** fallback so the PC does not idle-sleep while the script runs. On editions where Presentation Settings works, behavior is unchanged.
- **Tray: open Preferences with one click** — **Single left-click** the tray icon opens **Preferences** (default menu item), in addition to **Alt+F1**.
- **Network adapter switch** — Under **Tray → Windows Utilities**, a new item runs [nadap-switch](https://github.com/arlbibek/nadap-switch) so you can toggle network adapters from the tray (same remote-invoke pattern as the other utilities there).
- **Automatic update check on launch** — The compiled app checks GitHub for a newer release every time it starts. If an update is available, you get a tray notification and can install from **Preferences** as before.
- **Keyboard shortcuts PDF stays current after upgrades** — After you install a new version, the cached PDF in your profile is refreshed from the copy shipped with that build (tracked by app version), so shortcuts match the release you installed.
- **More reliable PDF download** — If the shortcuts file is missing, download tries the **latest release asset** first, then falls back to the **raw file on `master`** if needed.

## Notes

- Automatic update checks apply to the **EXE build** only (not when running `WINDOWS.ahk` from source).
- Your `config.ini` in `%AppData%\windows-ahk` is unchanged by these features.
