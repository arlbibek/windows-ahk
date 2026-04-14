# windows-ahk v3.2

## Updates

- **Automatic update check on launch** — The compiled app checks GitHub for a newer release every time it starts. If an update is available, you get a tray notification and can install from **Preferences** as before.
- **Keyboard shortcuts PDF stays current after upgrades** — After you install a new version, the cached PDF in your profile is refreshed from the copy shipped with that build (tracked by app version), so shortcuts match the release you installed.
- **More reliable PDF download** — If the shortcuts file is missing, download tries the **latest release asset** first, then falls back to the **raw file on `master`** if needed.

## Notes

- Automatic update checks apply to the **EXE build** only (not when running `WINDOWS.ahk` from source).
- Your `config.ini` in `%AppData%\windows-ahk` is unchanged by these features.
