#Include globals.ahk
#Include functions.ahk
#Include function_keys_ui.ahk


tray.Delete()
A_IconTip := A_ScriptName . "`nRight click for more options. "

tray.Add(txt_windows_ahk, launch_splash_screen)
if FileExist(tray_icon) {
    tray.SetIcon(txt_windows_ahk, tray_icon)
}
tray.Add()
; Add the "Run at startup" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txt_startup, toggle_startup_shortcut)
if FileExist(startup_shortcut) {
    tray.check(txt_startup)
} else {
    tray.unCheck(txt_startup)
}

; Add the "Start menu shortcut" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the Start Menu shortcut
tray.Add(txt_start_menu, toggle_start_menu_shortcut)
if FileExist(start_menu_shortcut) {
    tray.check(txt_start_menu)
} else {
    tray.unCheck(txt_start_menu)
}

; Add other tray menu items
tray.Add(txt_presentation_mode, toggle_presentation_mode)

; Add the "Keyboard shortcuts" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txt_keyboard_shortcut, view_keyboard_shortcuts, "Radio")
if FileExist(keyboard_shortcut_path) {
    tray.check(txt_keyboard_shortcut)
} else {
    tray.unCheck(txt_keyboard_shortcut)
}
tray.Add()

tray.Add("Manage Function  keys", initialize_fkey_manager)
tray.Add(txt_locate_file, open_script_location)
tray.SetIcon(txt_locate_file, "shell32.dll", 4)
tray.Add(txt_launch_config, tray_config_menu)
tray.SetIcon(txt_launch_config, "shell32.dll", 70)
tray.Add()

tray.Add(txt_github, view_github_source)
tray.SetIcon(txt_github, "shell32.dll", 14)
tray.Add(txt_ahk_doc, view_ahk_doc)
tray.SetIcon(txt_ahk_doc, "shell32.dll", 15)
tray.Add()

tray.Add(txt_suspend, toggle_suspend_hotkey)
tray.SetIcon(txt_suspend, "shell32.dll", 28)
tray.Add(txt_reload, reload_script)
tray.SetIcon(txt_reload, "shell32.dll", 239)
tray.Add(txt_exit, exit_script)
tray.SetIcon(txt_exit, "imageres.dll", 94)
tray.Add()
tray.Add(txt_author, visit_author_website)

tray_config_menu.Add("Edit configuration file", open_config_file)
tray_config_menu.Add("Open configuration file location", open_config_file_dir)
tray_config_menu.Add("Restore default configuration", restore_default_config)
tray_config_menu.Add("Launch configuration window", launch_config_ui)