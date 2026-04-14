#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent(true)

#Include globals.ahk
#Include defaults.ahk

; Validate configuration file and it's contents
if !FileExist(config_path) {
    load_default_config(config_path)
}

try {
    IniRead(config_path, windows_ahk_section)
    IniRead(config_path, function_keys_section)
    IniRead(config_path, hotstrings_section)
    IniRead(config_path, well_wishes_section)
} catch {
    msg := "An error occurred while reading the configuration file:`n"
        . config_path
        . "`n`nWould you like to restore default settings? This will overwrite all your changes."
    title := "Configuration Error - " . A_ScriptName

    if (MsgBox(msg, title, 0x21) = "OK") {
        load_default_config(config_path)
    } else {
        MsgBox("Please fix the config file manually.`nThe app will now exit.", "Configuration Not Reset - " . A_ScriptName, 0x40)
        ExitApp()
    }
}

#Include tray.ahk
#Include functions.ahk
#Include hotkeys.ahk
#Include hotstrings.ahk
#Include function_keys_ui.ahk

; splash screen
if FileExist(app_logo) {
    splash_ui.AddPicture("w85 h-1", app_logo)
}
splash_ui.Add("Text", "w250 h50 y5 x115", A_ScriptName).SetFont("s12")
splash_ui.Add("Text", "w350 h50 y30 x115 Wrap", "A simple and intuitive AutoHotKey script designed to enhance Windows shortcuts and improve your workflow. ")
splash_ui.Add("Button", "w100 y65 x115", "View on GitHub ↗️").OnEvent("Click", view_github_source)
splash_ui.Add("Button", "w125 y65 x215", "Keyboard Shortcuts 📄").OnEvent("Click", view_keyboard_shortcuts)
splash_ui.Add("Button", "w170 y65 x340 Default", "Launch preferences ⚙️").OnEvent("Click", launch_config_ui)

; config window
config_ui.OnEvent("Close", (*) => config_ui.Hide())
config_ui.OnEvent("Escape", (*) => config_ui.Hide())
config_ui.MarginX := 8
config_ui.MarginY := 8
if FileExist(app_logo) {
    config_ui.AddPicture("w86 h-1 x8 y8", app_logo)
}
config_ui.Add("Text", "x102 y10 w190 h20", "Preferences").SetFont("s10 Bold")
config_ui.Add("Text", "x102 y28 w190 h14", "Quick launch and config actions").SetFont("s8 c0x666666")

; Keep buttons below logo so controls never overlap.
config_ui.Add("Button", "x8 y102 w138 h26 Default", "&Manage Function Keys").OnEvent("Click", initialize_fkey_manager)
config_ui.Add("Button", "x154 y102 w138 h26", "&Edit config file").OnEvent("Click", open_config_file)
config_ui.Add("Button", "x8 y134 w138 h26", "&Open config folder").OnEvent("Click", open_config_file_dir)
config_ui.Add("Button", "x154 y134 w138 h26", "&Restore defaults").OnEvent("Click", restore_default_config)

config_ui.Add("Button", "x8 y166 w138 h26", "&View source code").OnEvent("Click", view_github_source)
config_ui.Add("Button", "x154 y166 w138 h26", "Reload script").OnEvent("Click", reload_script)
config_ui.Add("Button", "x8 y198 w138 h26", "Check for updates").OnEvent("Click", (*) => check_for_updates(true))
config_install_update_btn := config_ui.Add("Button", "x154 y198 w138 h26", "Install update")
config_install_update_btn.OnEvent("Click", install_available_update)
config_install_update_btn.Enabled := false

config_version_text := config_ui.Add("Text", "x8 y228 w284 h16", "")
config_version_text.SetFont("s8 c0x666666")
config_update_status_text := config_ui.Add("Text", "x8 y246 w284 h28", "Update status: Not checked yet.")
config_update_status_text.SetFont("s8 c0x666666")
update_preferences_version_text()

; start app
TrayTip("Open keyboard shortcuts with {Ctrl + Shift + Alt + \}`n`n" . txt_author, A_ScriptName " started", "0x1 0x10")

first_launch := IniRead(config_path, windows_ahk_section, "first_launch")
if StrLower(first_launch) == "true" {
    launch_splash_screen()
    IniWrite("false", config_path, windows_ahk_section, "first_launch")
}


if FileExist(tray_icon) {
    TraySetIcon(tray_icon)
}