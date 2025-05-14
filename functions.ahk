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


toggle_presentation_mode(*) {
    ; Function: togglePresentationMode
    ; Description: Toggles presentation mode on or off.

    ; Define the program name and AHK executable specifier
    program := "presentationsettings.exe"
    ahk_program := "ahk_exe " . program

    ; Run the presentation settings program
    Run(program)

    ; Wait for the program to open
    WinWait(ahk_program)

    ; Get the current presentation mode status
    presentationStatus := ControlGetChecked("Button1", ahk_program)

    ; Toggle presentation mode based on the current status
    if (presentationStatus == 1) {
        ; Presentation mode is on, turning it off
        ControlSetChecked(0, "Button1", ahk_program)
        ControlSetChecked(1, "Button7", ahk_program) ; check OK
        tray.UnCheck(txt_presentation_mode)
        TrayTip("Presentation mode has been toggled off.", "Presentation mode: Off", "Iconi Mute")
    } else {
        ; Presentation mode is off, turning it on
        ControlSetChecked(1, "Button1", ahk_program)
        ControlSetChecked(1, "Button3", ahk_program) ; check "Turn off screen saver" if not checked
        ControlSetChecked(1, "Button7", ahk_program) ; check OK
        tray.check(txt_presentation_mode)
        TrayTip("Presentation mode has been toggled on. Your computer will stay awake indefinitely.", "Presentation mode: On", "Iconi")
    }
}

view_keyboard_shortcuts(*) {
    ; Function: viewKeyboardShortcuts
    ; Description: Opens a PDF file containing keyboard shortcuts, or offers to download it if not found.

    ; Check if the PDF file exists locally
    While True {
        if FileExist(keyboard_shortcut_path) {
            ; If it exists, open the PDF file
            Run(keyboard_shortcut_path)
            tray.check(txt_keyboard_shortcut)
            break
        } else {
            ; If it doesn't exist, prompt the user to download it
            response := MsgBox("The '" keyboard_shortcut_filename "' file couldn't be located. `nThis PDF file contains a detailed list of keyboard shortcuts for '" A_ScriptName "'.`n`nWould you like to download and open the file?`nURL: " keyboard_shortcut_url, "File not found: Would you like to download?", "0x4")

            if response == "Yes" {
                ; Attempt to download the PDF file
                try {
                    TrayTip("URL: " keyboard_shortcut_url, "Downloading: " keyboard_shortcut_filename, "Iconi")
                    Download(keyboard_shortcut_url, keyboard_shortcut_path)
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
    config_ui.show()
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