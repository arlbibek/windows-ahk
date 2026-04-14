; Grouping explorers
GroupAdd("explorerGroup", "ahk_class CabinetWClass")
GroupAdd("explorerGroup", "ahk_class #32770") ; Explorer-based "save" and "load" boxes

; Grouping known browsers
GroupAdd("browserGroup", "ahk_exe firefox.exe")
GroupAdd("browserGroup", "ahk_exe duckduckgo.exe")
GroupAdd("browserGroup", "ahk_exe chrome.exe")
GroupAdd("browserGroup", "ahk_exe arc.exe")
GroupAdd("browserGroup", "ahk_exe brave.exe")
GroupAdd("browserGroup", "ahk_exe msedge.exe")
GroupAdd("browserGroup", "ahk_exe opera.exe")
GroupAdd("browserGroup", "ahk_exe iexplore.exe")
GroupAdd("browserGroup", "ahk_exe zen.exe")

; Grouping terminals (WSLs included)
GroupAdd("terminalGroup", "ahk_exe WindowsTerminal.exe")
GroupAdd("terminalGroup", "ahk_exe powershell.exe")
GroupAdd("terminalGroup", "ahk_exe cmd.exe")
GroupAdd("terminalGroup", "ahk_exe debian.exe")
GroupAdd("terminalGroup", "ahk_exe kali.exe")
GroupAdd("terminalGroup", "ahk_exe ubuntu.exe")

; Grouping Microsoft 365 work apps
GroupAdd("ms365Group", "ahk_exe winword.exe")
GroupAdd("ms365Group", "ahk_exe powerpnt.exe")
GroupAdd("ms365Group", "ahk_exe onenote.exe")
GroupAdd("ms365Group", "ahk_exe outlook.exe")
GroupAdd("ms365Group", "ahk_exe excel.exe")
GroupAdd("ms365Group", "ahk_exe ms-teams.exe")

; ============================================================================
; SECTION: Global Variables (Paths, Configs, etc.)

; File Explorer directory paths
global user_dir := "C:\Users\" A_UserName "\"
global this_pc := "This PC"
global desktop := user_dir "Desktop\"
global documents := user_dir "Documents\"
global downloads := user_dir "Downloads\"
global music := user_dir "Music\"
global pictures := user_dir "Pictures\"
global videos := user_dir "Videos\"
global c_drive := "C:\"

; Script shortcut paths
global startup_shortcut := A_Startup "\" A_ScriptName ".lnk"
global start_menu_shortcut := A_StartMenu "\Programs\" A_ScriptName ".lnk"

; Script configuration file paths
global config_file := "config.ini"
global config_dir := A_AppData . "\windows-ahk"
global config_path := config_dir . "\" . config_file
global app_version_file := A_ScriptDir . "\version.txt"
global windows_ahk_section := "WINDOWS_AHK"
global function_keys_section := "FUNCTION_KEYS"
global hotstrings_section := "HOTSTRINGS"
global well_wishes_section := "WELL_WISHES"
global github_repo := "arlbibek/windows-ahk"

; Keyboard shortcut PDF paths
keyboard_shortcut_filename := "keyboardshortcuts.pdf"
; Prefer latest release asset (matches CI-generated PDF); fallback raw master is still valid for offline mirrors
global keyboard_shortcut_url := "https://github.com/arlbibek/windows-ahk/releases/latest/download/" . keyboard_shortcut_filename
global keyboard_shortcut_url_fallback := "https://raw.githubusercontent.com/arlbibek/windows-ahk/master/assets/" . keyboard_shortcut_filename
global keyboard_shortcut_path := config_dir . "\" . keyboard_shortcut_filename
global keyboard_shortcut_asset_path := A_ScriptDir . "\assets\" . keyboard_shortcut_filename

; Tray menu text definitions
global txt_author := "Made with ❤️ by Bibek Aryal."
global txt_startup := "Run at startup"
global txt_keyboard_shortcut := "Keyboard shortcuts {Ctrl+Shift+Alt+\}"
global txt_launch_notification := "Show launch notification"
global txt_start_menu := "Start menu entry"
global txt_presentation_mode := "Presentation mode {Win+Shift+P}"
global txt_manage_function_keys := "Manage Function Keys"
global txt_locate_file := "Open file location"
global txt_launch_config := "Preferences {Alt+F1}"
global txt_github := "View in GitHub ↗️"
global txt_ahk_doc := "AutoHotKey documentation ↗️"
global txt_windows_ahk := A_ScriptName
global txt_reload := "Reload script {Ctrl+Shift+Alt+R}"
global txt_suspend := "Suspend hotkeys {Ctrl+Shift+Alt+S}"
global txt_exit := "Exit {Ctrl+Shift+Alt+E}"
global txt_win_util := "Windows Utilities"
global txt_win_util_chris_titus := "Launch Chris Titus Tech's Windows Utility" ; irm "https://christitus.com/win" | iex
global txt_win_util_mas := "Launch Microsoft Activation Scripts" ; irm https://get.activated.win/ | iex
global txt_win_util_nadap := "Network adapter switch" ; irm https://ttpl.pw/net | iex (nadap-switch)


global tray := A_TrayMenu
global tray_win_util_menu := Menu()

global splash_ui := Gui("MinimizeBox", "Welcome! - " . A_ScriptName)
global config_ui := Gui("MinimizeBox", "Preferences - windows-ahk")
global config_version_text := ""
global config_update_status_text := ""
global config_install_update_btn := ""
global update_latest_version := ""
global update_installer_url := ""
global keep_awake_fallback_active := false

; Script assets directory and tray icon path
global tray_icon := A_ScriptDir . "\assets\windows-ahk.ico"
global app_logo := A_ScriptDir . "\assets\windows-ahk.png"