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

; splash screen
if FileExist(app_logo) {
    splash_ui.AddPicture("w85 h-1", app_logo)
}
splash_ui.Add("Text", "w250 h50 y5 x115", A_ScriptName).SetFont("s12")
splash_ui.Add("Text", "w350 h50 y30 x115 Wrap", "A simple and intuitive AutoHotKey script designed to enhance Windows shortcuts and improve your workflow. ")
splash_ui.Add("Button", "w100 y65 x115", "View on GitHub ↗️").OnEvent("Click", view_github_source)
splash_ui.Add("Button", "w125 y65 x215", "Keyboard Shortcuts 📄").OnEvent("Click", view_keyboard_shortcuts)
splash_ui.Add("Button", "w150 y65 x340 Default", "Launch config window ⚙️").OnEvent("Click", launch_config_ui)

; config window
if FileExist(app_logo) {
    config_ui.AddPicture("w70 h-1 y5 x5", app_logo)
}
config_ui.Add("Text", "w200 h50 y5 x100 ", "Manage/edit configurations").SetFont("s11")
config_ui.Add("Button", "w200 y25 x100 ", "&Edit configuration file").OnEvent("Click", open_config_file)
config_ui.Add("Button", "w200 y50 x100", "&Open configuration file location").OnEvent("Click", open_config_file_dir)
config_ui.Add("Button", "w145 y75 x100", "&Restore default configuration").OnEvent("Click", restore_default_config)
config_ui.Add("Button", "w90 y75 x5", "&Learn more ↗️").OnEvent("Click", view_github_source)
config_ui.Add("Button", "w50 y75 x250 Default", "Reload").OnEvent("Click", reload_script)

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