#Requires AutoHotkey v2.0

#Include globals.ahk
; #Include default_config.ahk

; CALL BACK FUNCTIONS

visit_author_website(*) {
    ; Opens the author's website.
    Run("https://bibeka.com.np/")
}

toggle_startup_shortcut(*) {
    ; Function: toggleStartupShortcut
    ; Description: Toggles the script's startup shortcut in the Windows Startup folder.

    ; Check if the startup shortcut already exists
    if FileExist(startup_shortcut) {
        ; If it exists, delete the shortcut
        FileDelete(startup_shortcut)

        ; Display a TrayTip indicating the result
        if not FileExist(startup_shortcut) {
            tray.unCheck(txt_startup)
            TrayTip("Startup shortcut removed", "This script won't start automatically", "Iconi")
        } else {
            TrayTip("Startup shortcut removal failed", "Something went wrong", "Iconx")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, startup_shortcut)

        ; Display a TrayTip indicating the result
        if FileExist(startup_shortcut) {
            tray.check(txt_startup)
            TrayTip("Startup shortcut added", "This script will run at startup", "Iconi")
        } else {
            TrayTip("Startup shortcut creation failed", "Something went wrong", "Iconx")
        }
    }

}

toggle_start_menu_shortcut(*) {
    ; Function: toggleStartMenuShortcut
    ; Description: Toggles the script's Start Menu shortcut.

    ; Check if the Start Menu shortcut already exists
    if FileExist(start_menu_shortcut) {
        ; If it exists, delete the shortcut
        FileDelete(start_menu_shortcut)

        ; Display a TrayTip indicating the result
        if !FileExist(start_menu_shortcut) {
            tray.unCheck(txt_start_menu)
            TrayTip("Start menu shortcut removed", "The script won't be shown in the Start Menu", "Iconi")
        } else {
            TrayTip("Start menu shortcut removal failed", "Something went wrong", "Iconx")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, start_menu_shortcut)

        ; Display a TrayTip indicating the result
        if FileExist(start_menu_shortcut) {
            tray.check(txt_start_menu)
            TrayTip("Start Menu shortcut added", "The script will be shown in the Start Menu", "Iconi")
        } else {
            TrayTip("Start menu shortcut creation failed", "Something went wrong", "Iconx")
        }
    }
}

toggle_launch_notification(*) {
    current_value := IniRead(config_path, windows_ahk_section, "show_launch_notification", "true")
    is_enabled := (StrLower(current_value) = "true")

    if is_enabled {
        IniWrite("false", config_path, windows_ahk_section, "show_launch_notification")
        tray.unCheck(txt_launch_notification)
        TrayTip("Launch notification disabled.", A_ScriptName, "Iconi")
    } else {
        IniWrite("true", config_path, windows_ahk_section, "show_launch_notification")
        tray.check(txt_launch_notification)
        TrayTip("Launch notification enabled.", A_ScriptName, "Iconi")
    }
}


; Windows Home and some SKUs lack working Presentation Settings; use SetThreadExecutionState as fallback.
toggle_keep_awake_mode(*) {
    global keep_awake_fallback_active
    static awake := false
    ES_CONTINUOUS := 0x80000000
    ES_SYSTEM_REQUIRED := 0x00000001
    ES_DISPLAY_REQUIRED := 0x00000002

    if awake {
        DllCall("SetThreadExecutionState", "UInt", ES_CONTINUOUS)
        awake := false
        keep_awake_fallback_active := false
        tray.UnCheck(txt_presentation_mode)
        TrayTip("Stay awake is off (idle sleep allowed).", "Presentation / stay awake", "Iconi Mute")
    } else {
        DllCall("SetThreadExecutionState", "UInt", ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED)
        awake := true
        keep_awake_fallback_active := true
        tray.check(txt_presentation_mode)
        TrayTip("Stay awake is on. Sleep is blocked while this script is running.", "Presentation / stay awake", "Iconi")
    }
}

presentation_cleanup_on_exit(*) {
    global keep_awake_fallback_active
    if keep_awake_fallback_active
        DllCall("SetThreadExecutionState", "UInt", 0x80000000)
}

toggle_presentation_mode(*) {
    ; Function: togglePresentationMode
    ; Description: Toggles Windows Presentation Mode, or stay-awake (API) when Presentation Settings is unavailable.

    static prefer_keep_awake := false
    if prefer_keep_awake {
        toggle_keep_awake_mode()
        return
    }

    program := "presentationsettings.exe"
    ahk_program := "ahk_exe " . program

    try {
        Run(program)
        WinWait(ahk_program,, 10)
        presentationStatus := ControlGetChecked("Button1", ahk_program)

        if (presentationStatus == 1) {
            ControlSetChecked(0, "Button1", ahk_program)
            ControlSetChecked(1, "Button7", ahk_program)
            tray.UnCheck(txt_presentation_mode)
            TrayTip("Presentation mode has been toggled off.", "Presentation mode: Off", "Iconi Mute")
        } else {
            ControlSetChecked(1, "Button1", ahk_program)
            ControlSetChecked(1, "Button3", ahk_program)
            ControlSetChecked(1, "Button7", ahk_program)
            tray.check(txt_presentation_mode)
            TrayTip("Presentation mode has been toggled on. Your computer will stay awake indefinitely.", "Presentation mode: On", "Iconi")
        }
    } catch Error {
        try WinClose(ahk_program)
        prefer_keep_awake := true
        TrayTip("Presentation Settings is not available here. Using stay-awake mode instead (same hotkey).", "windows-ahk", "Iconi")
        toggle_keep_awake_mode()
    }
}

view_keyboard_shortcuts(*) {
    ; Function: viewKeyboardShortcuts
    ; Description: Opens keyboard shortcuts PDF and keeps cached copy in sync with bundled asset.

    ; Keep cached shortcuts file updated with the installed app asset.
    if FileExist(keyboard_shortcut_asset_path) {
        try {
            if !DirExist(config_dir)
                DirCreate(config_dir)

            should_copy := !FileExist(keyboard_shortcut_path)
            if !should_copy {
                asset_time := FileGetTime(keyboard_shortcut_asset_path, "M")
                cached_time := FileGetTime(keyboard_shortcut_path, "M")
                asset_size := FileGetSize(keyboard_shortcut_asset_path)
                cached_size := FileGetSize(keyboard_shortcut_path)
                should_copy := (asset_time > cached_time) || (asset_size != cached_size)
            }

            if (should_copy)
                FileCopy(keyboard_shortcut_asset_path, keyboard_shortcut_path, 1)
        } catch {
            ; Non-fatal: fall back to existing cached/download flow below.
        }
    }

    ; Check if the PDF file exists locally
    While True {
        if FileExist(keyboard_shortcut_path) {
            ; If it exists, open the PDF file
            Run(keyboard_shortcut_path)
            tray.check(txt_keyboard_shortcut)
            break
        } else {
            ; If it doesn't exist, prompt the user to download it
            response := MsgBox("The '" keyboard_shortcut_filename "' file couldn't be located. `nThis PDF file contains a detailed list of keyboard shortcuts for '" A_ScriptName "'.`n`nWould you like to download it from GitHub (latest release, or raw repo if needed)?", "File not found: Would you like to download?", "0x4")

            if response == "Yes" {
                ; Attempt to download the PDF file (release asset first, then raw master)
                try {
                    TrayTip("Downloading: " keyboard_shortcut_filename, "Keyboard shortcuts", "Iconi")
                    try {
                        Download(keyboard_shortcut_url, keyboard_shortcut_path)
                    } catch Error {
                        Download(keyboard_shortcut_url_fallback, keyboard_shortcut_path)
                    }
                } catch Error as err {
                    TrayTip("The '" keyboard_shortcut_filename "' couldn't be downloaded. Are you offline? Please try again.", "Download failed. Error: " err.message, "Iconx")
                    break
                }
            } else {
                break
            }
        }
    }
}

open_script_location(*) {
    ; Opens the directory where the current script is located.
    Run(A_ScriptDir)
}

launch_config_ui(*) {
    config_ui.Show()
    try WinActivate("ahk_id " . config_ui.Hwnd)
    update_preferences_version_text()
    configure_update_controls_for_runtime()
}

is_exe_runtime() {
    return A_IsCompiled
}

get_app_version() {
    version_value := "dev"
    try {
        if FileExist(app_version_file) {
            version_value := Trim(FileRead(app_version_file))
            if (version_value = "")
                version_value := "dev"
        }
    }
    return version_value
}

; Copy bundled PDF into AppData after an installer update (version.txt changes) so shortcuts stay in sync with the build.
sync_keyboard_shortcuts_pdf_after_update() {
    if !is_exe_runtime()
        return
    current := get_app_version()
    last := IniRead(config_path, windows_ahk_section, "keyboard_shortcuts_pdf_sync_version", "")
    if (current = last && FileExist(keyboard_shortcut_path))
        return
    if !FileExist(keyboard_shortcut_asset_path)
        return
    try {
        if !DirExist(config_dir)
            DirCreate(config_dir)
        FileCopy(keyboard_shortcut_asset_path, keyboard_shortcut_path, 1)
        IniWrite(current, config_path, windows_ahk_section, "keyboard_shortcuts_pdf_sync_version")
    } catch {
    }
}

normalize_version(version_text) {
    cleaned := RegExReplace(Trim(version_text), "^[^0-9]+")
    cleaned := RegExReplace(cleaned, "[^0-9\.].*$")
    if (cleaned = "")
        cleaned := "0"
    return cleaned
}

compare_versions(version_a, version_b) {
    a := StrSplit(normalize_version(version_a), ".")
    b := StrSplit(normalize_version(version_b), ".")
    max_parts := (a.Length > b.Length) ? a.Length : b.Length

    Loop max_parts {
        a_part := (A_Index <= a.Length) ? Integer(a[A_Index]) : 0
        b_part := (A_Index <= b.Length) ? Integer(b[A_Index]) : 0
        if (a_part > b_part)
            return 1
        if (a_part < b_part)
            return -1
    }
    return 0
}

http_get(url) {
    request := ComObject("WinHttp.WinHttpRequest.5.1")
    request.Open("GET", url, false)
    request.SetRequestHeader("User-Agent", "windows-ahk-updater")
    request.SetRequestHeader("Accept", "application/vnd.github+json")
    request.Send()
    return { status: request.Status, body: request.ResponseText }
}

extract_json_value(json_text, key_name) {
    pattern := '"' . key_name . '"\s*:\s*"([^"]*)"'
    if RegExMatch(json_text, pattern, &match)
        return StrReplace(match[1], '\/', '/')
    return ""
}

extract_installer_url(json_text) {
    ; Prefer the installer generated by release workflow.
    if RegExMatch(json_text, '"browser_download_url"\s*:\s*"([^"]*windows-ahk-setup[^"]*\.exe)"', &match)
        return StrReplace(match[1], '\/', '/')

    ; Fallback to first exe asset if naming differs.
    if RegExMatch(json_text, '"browser_download_url"\s*:\s*"([^"]*\.exe)"', &fallback)
        return StrReplace(fallback[1], '\/', '/')

    return ""
}

update_preferences_version_text() {
    if IsObject(config_version_text) {
        runtime_text := is_exe_runtime() ? "EXE runtime" : "Script runtime (.ahk)"
        config_version_text.Text := "Current version: " . get_app_version() . " (" . runtime_text . ")"
    }
}

set_update_status(message, color := "0x666666") {
    if IsObject(config_update_status_text) {
        config_update_status_text.Opt("c" . color)
        config_update_status_text.Text := message
    }
}

configure_update_controls_for_runtime() {
    global config_install_update_btn

    if !is_exe_runtime() {
        if IsObject(config_install_update_btn)
            config_install_update_btn.Enabled := false
        set_update_status("Auto-update is EXE-only.", "0x666666")
    }
}

check_for_updates(show_feedback := true, startup := false) {
    global update_latest_version, update_installer_url, config_install_update_btn

    if !is_exe_runtime() {
        configure_update_controls_for_runtime()
        return false
    }

    if !startup
        set_update_status("Checking for updates...", "0x666666")
    update_latest_version := ""
    update_installer_url := ""
    if IsObject(config_install_update_btn)
        config_install_update_btn.Enabled := false

    try {
        response := http_get("https://api.github.com/repos/" . github_repo . "/releases/latest")
        if (response.status != 200) {
            set_update_status("Unable to check updates (HTTP " . response.status . ").", "0xC00000")
            return false
        }

        latest_tag := extract_json_value(response.body, "tag_name")
        installer_url := extract_installer_url(response.body)

        if (latest_tag = "" || installer_url = "") {
            set_update_status("Release metadata missing installer asset.", "0xC00000")
            return false
        }

        current_version := get_app_version()
        update_latest_version := latest_tag
        update_installer_url := installer_url

        if (compare_versions(latest_tag, current_version) > 0) {
            set_update_status("Update available: " . latest_tag, "0x008000")
            if IsObject(config_install_update_btn)
                config_install_update_btn.Enabled := true
            if show_feedback
                TrayTip("Update available", "Version " . latest_tag . " is ready to install.", "Iconi")
            return true
        }

        set_update_status("You are up to date (" . current_version . ").", "0x666666")
        return false
    } catch Error as err {
        set_update_status("Update check failed: " . err.Message, "0xC00000")
        return false
    }
}

install_available_update(*) {
    global update_latest_version, update_installer_url

    if !is_exe_runtime() {
        configure_update_controls_for_runtime()
        return
    }

    if (update_installer_url = "") {
        ; Try one fresh check in case user clicks install directly.
        has_update := check_for_updates(false)
        if !has_update {
            set_update_status("No update available to install.", "0x666666")
            return
        }
    }

    target_version := (update_latest_version = "") ? "latest" : update_latest_version
    confirm := MsgBox(
        "Install update " . target_version . " now?`n`nThe installer will launch and the current app will close.",
        "Install Update",
        "YesNo Icon?"
    )
    if (confirm != "Yes")
        return

    installer_path := A_Temp . "\windows-ahk-setup-" . normalize_version(target_version) . ".exe"

    try {
        set_update_status("Downloading installer...", "0x666666")
        Download(update_installer_url, installer_path)

        set_update_status("Launching installer...", "0x666666")
        Run('"' . installer_path . '"')
        ExitApp()
    } catch Error as err {
        set_update_status("Failed to install update.", "0xC00000")
        MsgBox("Update install failed: " . err.Message, "Update Error", "Icon!")
    }
}

open_config_file(*) {
    ; Opens the directory where the current script is located.
    Run(config_path)
}

open_config_file_dir(*) {
    ; Opens the directory where the current script is located.
    Run(config_dir)
}


restore_default_config(*) {
    ; default config
    load_default_config(config_path)
}

launch_splash_screen(*) {
    splash_ui.Show()
}


view_github_source(*) {
    ; Opens the script's source code on GitHub.
    Run("https://github.com/arlbibek/windows-ahk/")
}

view_ahk_doc(*) {
    ; Opens the official AutoHotkey v2 documentation.
    Run("https://www.autohotkey.com/docs/v2/")
}

reload_script(*) {
    Reload()
}

exit_script(*) {
    ExitApp()
}

toggle_suspend_hotkey(*) {
    Suspend(-1)
}


; == FUNCTIONS ====================>


get_default_browser() {
    ; Function: get_default_browser
    ; Description: Returns the path of the user's default browser's executable (e.g., C:\Program Files\Google\Chrome\Application\chrome.exe).
    ; Returns: (string) The path of the default browser executable.

    ; Retrieve the ProgID associated with the default browser for HTML files
    browserProgID := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice", "ProgID")

    ; Retrieve the executable command associated with the ProgID
    browserFullCommand := RegRead("HKCR\" . browserProgID . "\shell\open\command")

    ; Define the regular expression pattern to match the path within double quotes
    pattern := '"(.*\.exe)"'

    ; Use RegExMatch to extract the path
    if RegExMatch(browserFullCommand, pattern, &pathMatch) {
        ; The extracted path will be in pathMatch[1]
        defaultBrowserPath := pathMatch[1]
        return defaultBrowserPath
    } else {
        ; Return an empty string if no match is found
        return ""
    }
}


manage_program_windows(programPath, ahkType := "ahk_exe", programExe := "") {
    ; Function: manage_program_windows
    ; Description: Manage windows (active, cycle or minimize) of a specified program.
    ; Parameters:
    ; - programPath: The path or name of the program to manage windows for.
    ; - ahkType: (Optional) The type of AHK identifier (default: "ahk_exe").
    ; - programExe: (Optional) The program executable path (if different from programPath).

    ; Define the AHK type and program for use in Win functions
    ahkProgram := ahkType . " " . programPath

    if StrLen(programPath) < 1 || StrLower(programPath) == StrLower(A_ThisHotkey) {
        ; Check if the program path is empty and return if it is
        ; hot_key := StrLower(A_ThisHotkey)
        Hotkey(A_ThisHotkey, "Off")

    } else if not WinExist(ahkProgram) {
        ; Check if any windows of the specified program exist
        ; If no windows exist, run the program to start it
        if StrLen(programExe) > 1 {
            Run(programExe)
            WinWait("ahk_exe " programExe)
            WinActivate("ahk_exe " programExe)
        } else {
            Run(programPath)
            WinWait(ahkProgram)
            WinActivate(ahkProgram)
        }
    } else {
        ; Check if the program's window is currently active
        if WinActive(ahkProgram) {
            ; Get the count of windows with the specified program
            winCount := WinGetCount(ahkProgram)
            if (winCount > 1) {
                ; If multiple windows exist, activate the bottom one to cycle through
                WinActivateBottom(ahkProgram)
            } else {
                ; If only one window exists, minimize it
                WinMinimize(ahkProgram)
            }
        } else {
            ; If the program's window is not active, activate it
            WinActivate(ahkProgram)
        }
    }
}


get_selected_text() {
    ; Function: getSelectedText
    ; Description: Copies the selected text to the clipboard and returns it.
    ; Returns: (string) The selected text.

    ; Save the current clipboard contents
    savedClipboard := A_Clipboard
    A_Clipboard := ""  ; Clear the clipboard

    ; Send the appropriate key combination based on the active window
    if WinActive("ahk_group terminalGroup") {
        Send("^+c")  ; Copy selected text in terminalGroup
    } else {
        Send("^c")   ; Copy selected text in other windows
    }

    ; ; Wait for the clipboard to be updated
    ClipWait(3)
    copiedText := A_Clipboard

    ; ; Restore the previous clipboard contents
    A_Clipboard := savedClipboard

    return copiedText
}

perform_web_search(searchStr, cmd := "#s") {
    ; Function: performWebSearch
    ; Description: Searches for a query or URL in a web browser or opens a DuckDuckGo search.
    ; Parameters:
    ;   - searchStr (string): The search query or URL to search for.
    ;   - cmd (string): The command to resend if nothing is selected.

    ; Remove all CR+LF's and extra spaces from the search string
    searchStr := RegExReplace(searchStr, "(\r|\n|\s{2,})")

    ; Only search if something has been selected
    if (StrLen(searchStr) == 0) {
        ; Resend the command if nothing is selected
        Send(cmd)
        return
    }

    if WinActive("ahk_group browserGroup") {
        ; Check if the active window is a browser
        Send("^t")        ; Open a new tab
        Sleep(300)
        SendText(searchStr)   ; Type the search string
        Sleep(200)
        Send("{Enter}")   ; Press Enter to initiate the search
    } else if (RegExMatch(searchStr, "^(https?:\/\/|www\.)")) {
        ; Check if the search string is a URL
        Run(searchStr)    ; Open the URL in the default web browser
    } else {
        ; Replace spaces with pluses and escape special characters for a DuckDuckGo search
        searchStr := StrReplace(searchStr, " ", "+")  ; Replace spaces with plus signs
        searchStr := RegExReplace(searchStr, "([&|<>])", "\$1")  ; Escape special characters

        ; Run a DuckDuckGo search with the modified search string
        Run("https://duckduckgo.com/?q=" . searchStr . "&ia=answer")
    }
}

change_case(text, txt_case, re_select := False) {
    ; Function: changeCase
    ; Description: Changes the case of a string and types it.
    ; Parameters:
    ;   - text (string): The input string.
    ;   - txt_case (string): The desired case ("lower," "titled," or "upper").
    ;   - re_select (boolean, optional): Whether to re-select the text after typing.

    ; Validate the case parameter
    switch (txt_case) {
        case "lower":
            cased_text := StrLower(text)
        case "titled":
            cased_text := StrTitle(text)
        case "upper":
            cased_text := StrUpper(text)
        default:
            MsgBox("Invalid parameter value: " txt_case "`nThe parameter should be either 'lower', 'titled', or 'upper'.")
            return
    }

    ; Type the Cased text
    SendText(cased_text)

    ; Attempt to Re-select the text if requested
    if (re_select) {
        Send("+{left " . StrLen(RegExReplace(text, "(\n)")) . "}")
    }
}


; Manages program windows based on the provided path for function keys.
; path {string} - The path indicating the desired action or program window(s) to manage.
manage_function_key(path) {
    ; Switch statement to handle different paths
    if (StrLower(path) == "default_browser") {
        ; Manage windows for the default browser
        manage_program_windows(get_default_browser())
    } else if (StrLower(path) == "all_browsers") {
        ; Manage windows for all browsers
        if WinExist("ahk_group browserGroup") {
            manage_program_windows("browserGroup", "ahk_group")
        } else {
            ; If not for the browser exists start the default browser
            manage_program_windows(get_default_browser())
        }
    } else if (StrLower(path) == "browser_tabs") {
        if WinActive("ahk_group browserGroup") {
            Send("^{Tab}")
        } else {
            manage_program_windows(get_default_browser())
        }
    } else if (StrLower(path) == "switch_window") {
        send_alt_tab()
    } else if (StrLower(path) == "switch_tabs") {
        send_ctrl_tab()
    } else {
        ; If the path doesn't match predefined conditions, attempt to manage windows based on the provided path
        manage_program_windows(path)
    }
}

explore_to(path) {
    ; Function: exploreTo
    ; Description: Navigates to a specific path in File Explorer using keyboard shortcuts.
    ; Parameters:
    ;   - path (string): The path to navigate to.

    ; Use Ctrl+L to focus the address bar in File Explorer
    Send("^l")
    Sleep(100)

    ; Type the provided path and press Enter
    SendText(path)
    Sleep(50)
    Send("{Enter}")
}

send_alt_tab(*) {
    ; sends alt + tab to switch window
    Send("{Alt Down}{Tab}{Alt UP}")
}
send_ctrl_tab(*) {
    ; sends Ctrl + tab to switch window
    Send("{Ctrl Down}{Tab}{Ctrl UP}")
}

run_wait_one(command, *) {
    ; command execution
    try {
        shell := ComObject("WScript.Shell")
        exec := shell.Exec(command)
        ; Wait for completion without timeout
        while exec.Status = 0 {
            Sleep(50)
        }
        return exec.StdOut.ReadAll()
    } catch Error as e {
        throw Error("Command execution failed: " e.Message)
    }
}