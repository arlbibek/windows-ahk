## WINDOWS-AHK v3.0

![GitHub all releases](https://img.shields.io/github/downloads/arlbibek/windows-ahk/total)
![GitHub Downloads (all assets, specific tag)](https://img.shields.io/github/downloads/arlbibek/windows-ahk/v3.0/total)

### Major Release Highlights

- New installer-based distribution (recommended): per-user installer with no admin requirement, installed under `%LocalAppData%\windows-ahk`.
- In-app update flow for EXE users: Preferences now includes `Check for updates` and `Install update`.
- Automated release build pipeline to generate and publish:
  - `WINDOWS_AHK.exe`
  - `windows-ahk-setup-<version>.exe`
  - `checksums.txt`
- Unified and improved Preferences dashboard (`Alt + F1`).

### Download Guidance

- Recommended for most users: `windows-ahk-setup-v3.0.exe`
- Advanced/portable only: `WINDOWS_AHK.exe`

### What Changed (Detailed)

#### Update and Release System

- Added `version.txt` as single version source.
- Added GitHub Releases update check logic in-app.
- Added safe update install flow (download installer, launch, close current app for replacement).
- Auto-update is EXE-only; `WINDOWS.ahk` source mode remains manual-update.

#### Installer and Build

- Added Inno Setup installer for no-admin per-user install.
- Added `scripts/build-release.ps1` for local/CI builds.
- Added GitHub Actions workflow to build and attach release artifacts.

#### Preferences / UI

- Compact, cleaner Preferences layout.
- Added explicit action to open Function Key Manager from Preferences.
- Updated tray and hotkey behavior to align with Preferences-first flow.
- Improved Function Key UI behavior and compacted button layout.

#### Documentation

- Updated `README.md` and `keyboardshortcuts.md` for installer-first setup and EXE update flow.

> [!IMPORTANT]
>
> This is a major update and changes the recommended install/update path.
>
> - If you currently run `WINDOWS.ahk` directly, you can continue to do so, but in-app auto-update does not apply in script mode.
> - If you currently use older EXE builds, move to the new installer flow (`windows-ahk-setup-3.0.exe`) for best future update experience.
> - User config remains external in `%AppData%\windows-ahk\config.ini`, so updates preserve your settings.

### Full Changelog

https://github.com/arlbibek/windows-ahk/compare/v2.3...v3.0
