#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent(true)

; grouping explorers
GroupAdd("explorerGroup", "ahk_class CabinetWClass")
GroupAdd("explorerGroup", "ahk_class #32770") ; This is for all the Explorer-based "save" and "load" boxes, from any program!

; grouping browsers
GroupAdd("browserGroup", "ahk_exe firefox.exe")
GroupAdd("browserGroup", "ahk_exe duckduckgo.exe")
GroupAdd("browserGroup", "ahk_exe chrome.exe")
GroupAdd("browserGroup", "ahk_exe arc.exe")
GroupAdd("browserGroup", "ahk_exe brave.exe")
GroupAdd("browserGroup", "ahk_exe msedge.exe")
GroupAdd("browserGroup", "ahk_exe opera.exe")
GroupAdd("browserGroup", "ahk_exe iexplore.exe")

; grouping terminals (WSLs as well)
GroupAdd("terminalGroup", "ahk_exe WindowsTerminal.exe")
GroupAdd("terminalGroup", "ahk_exe powershell.exe")
GroupAdd("terminalGroup", "ahk_exe cmd.exe")
GroupAdd("terminalGroup", "ahk_exe debian.exe")
GroupAdd("terminalGroup", "ahk_exe kali.exe")
GroupAdd("terminalGroup", "ahk_exe ubuntu.exe")

; grouping Micorsoft 365 apps
GroupAdd("ms365Group", "ahk_exe winword.exe")
GroupAdd("ms365Group", "ahk_exe powerpnt.exe")
GroupAdd("ms365Group", "ahk_exe onenote.exe")
groupadd("ms365Group", "ahk_exe outlook.exe")
groupadd("ms365Group", "ahk_exe excel.exe")

; file explorer directory path
global userdir := "C:\Users\" A_UserName "\"
global pc := "This PC"
global desktop := userdir "Desktop\"
global documents := userdir "Documents\"
global downloads := userdir "Downloads\"
global music := userdir "Music\"
global pictures := userdir "Pictures\"
global videos := userdir "Videos\"
global c := "C:\"

; Define the path to the script's Start Up and Start Menu shortcut
global startupShortcut := A_Startup "\" A_ScriptName ".lnk"
global startMenuShortcut := A_StartMenu "\Programs\" A_ScriptName ".lnk"

; Define the URL and keyboardShortcut file/path
global keyboardShortcutFilename := "keyboardshortcuts.pdf"
global keyboardShortcutUrl := "https://raw.githubusercontent.com/arlbibek/windows-ahk/master/" . keyboardShortcutFilename
global keyboardShortcutPath := A_ScriptDir . "\" . keyboardShortcutFilename

; Define path to script configfile
global config_dir := A_AppData . "\windows-ahk"
global config_file := "config.ini"
global config_path := config_dir . "\" . config_file


; Define path to script assets directoryconfigfile
global assets_dir := A_ScriptDir . "\assets\"
global trayIconPath := A_ScriptDir "\assets\windows-ahk.ico"

; INITIALIZE TRAY MENU

; Define menu item text
global txt_aurthor := "Made with ❤️ by Bibek Aryal."
global txt_startup := "Run at startup"
global txt_startmenu := "Start menu entry"
global txt_presentationmode := "Presentation mode {Win+Shift+P}"
global txt_keyboardshortcut := "Keyboard shortcuts {Ctrl+Shift+Alt+\}"
global txt_locatefile := "Open file location"
global txt_launchconfig := "Launch configuratoi window"
global txt_github := "View in GitHub ↗️"
global txt_ahkdoc := "See AutoHotKey documentation ↗️"

if FileExist(trayIconPath) {
    TraySetIcon(trayIconPath)
}

tray := A_TrayMenu
tray.delete() ; Delete existing items from the tray menu

; CALL BACK FUNCTIONS

visitAuthorWebsite(*) {
    ; Opens the author's website.
    Run("https://bibeka.com.np/")
}

toggleStartupShortcut(*) {
    ; Function: toggleStartupShortcut
    ; Description: Toggles the script's startup shortcut in the Windows Startup folder.

    ; Check if the startup shortcut already exists
    if FileExist(startupShortcut) {
        ; If it exists, delete the shortcut
        FileDelete(startupShortcut)

        ; Display a TrayTip indicating the result
        if not FileExist(startupShortcut) {
            tray.unCheck(txt_startup)
            TrayTip("Startup shortcut removed", "This script won't start automatically", "Iconi Mute")
        } else {
            TrayTip("Startup shortcut removal failed", "Something went wrong", "Iconx")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, startupShortcut)

        ; Display a TrayTip indicating the result
        if FileExist(startupShortcut) {
            tray.check(txt_startup)
            TrayTip("Startup shortcut added", "This script will run at startup", "Iconi Mute")
        } else {
            TrayTip("Startup shortcut creation failed", "Something went wrong", "Iconx")
        }
    }
}


toggleStartMenuShortcut(*) {
    ; Function: toggleStartMenuShortcut
    ; Description: Toggles the script's Start Menu shortcut.

    ; Check if the Start Menu shortcut already exists
    if FileExist(startMenuShortcut) {
        ; If it exists, delete the shortcut
        FileDelete(startMenuShortcut)

        ; Display a TrayTip indicating the result
        if not FileExist(startMenuShortcut) {
            tray.unCheck(txt_startmenu)
            TrayTip("Start menu shortcut removed", "The script won't be shown in the Start Menu", "Iconx Mute")
        } else {
            TrayTip("Start menu shortcut removal failed", "Something went wrong", "Iconx")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, startMenuShortcut)

        ; Display a TrayTip indicating the result
        if FileExist(startMenuShortcut) {
            tray.check(txt_startmenu)
            TrayTip("Start Menu shortcut added", "The script will be shown in the Start Menu", "Iconx Mute")
        } else {
            TrayTip("Start menu shortcut creation failed", "Something went wrong", "Iconx")
        }
    }
}


togglePresentationMode(*) {
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
        tray.UnCheck(txt_presentationmode)
        TrayTip("Presentation mode has been toggled off.", "Presentation mode: Off", "Iconi Mute")
    } else {
        ; Presentation mode is off, turning it on
        ControlSetChecked(1, "Button1", ahk_program)
        ControlSetChecked(1, "Button3", ahk_program) ; check "Turn off screen saver" if not checked
        ControlSetChecked(1, "Button7", ahk_program) ; check OK
        tray.check(txt_presentationmode)
        TrayTip("Presentation mode has been toggled on. Your computer will stay awake indefinitely.", "Presentation mode: On", "Iconi Mute")
    }
}

viewKeyboardShortcuts(*) {
    ; Function: viewKeyboardShortcuts
    ; Description: Opens a PDF file containing keyboard shortcuts, or offers to download it if not found.

    ; Check if the PDF file exists locally
    While True {
        if FileExist(keyboardShortcutPath) {
            ; If it exists, open the PDF file
            Run(keyboardShortcutPath)
            tray.check(txt_keyboardshortcut)
            break
        } else {
            ; If it doesn't exist, prompt the user to download it
            response := MsgBox("The '" keyboardShortcutFilename "' file couldn't be located. `nThis PDF file contains a detailed list of keyboard shortcuts for '" A_ScriptName "'.`n`nWould you like to download and open the file?`nURL: " keyboardShortcutUrl, "File not found: Would you like to download?", "0x4")

            if response == "Yes" {
                ; Attempt to download the PDF file
                try {
                    TrayTip("URL: " keyboardShortcutUrl, "Downloading: " keyboardShortcutFilename, "Iconi Mute")
                    Download(keyboardShortcutUrl, keyboardShortcutFilename)
                } catch Error as err {
                    TrayTip("The '" keyboardShortcutFilename "' couldn't be downloaded. Are you offline? Please try again.", "Download failed. Error: " err.message, "Iconx")
                    break
                }
            } else {
                break
            }
        }
    }
}

openScriptLocation(*) {
    ; Opens the directory where the current script is located.
    Run(A_ScriptDir)
}

launchConfigUI(*) {
    configUI.show()
}

openConfigFile(*) {
    ; Opens the directory where the current script is located.
    Run(config_path)
}

openConfigFileDir(*) {
    ; Opens the directory where the current script is located.
    Run(config_dir)
}

loadDefaultConfig(*) {

    if not FileExist(config_path) {
        ; Ensure the directory exists before writing the file
        if not FileExist(config_dir) {
            DirCreate(config_dir)
            TrayTip("Default configuration file created.", , "0x4 Mute")
        }

        default_apps := [
            "default_browser", ; f1
            "", ; f2
            "C:\Users\" A_UserName "\AppData\Roaming\Spotify\Spotify.exe", ; f3
            "C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe", ; f4
            "", ; f5
            "C:\Program Files\SumatraPDF\SumatraPDF.exe", ; f6
            "winword.exe", ; f7
            "excel.exe", ; f8
            "C:\Users\" A_UserName "\AppData\Local\Obsidian\Obsidian.exe", ; f9
            "powershell.exe", ; f10
            "", ; f11
            "" ; f12
        ]

        FileAppend("; == WINDOWS-AHK CONFIGURATION ===========================================`n;`n", config_path)
        FileAppend("; This file provides different configurations for the windows-ahk script. `n;`n", config_path)
        FileAppend("; For more info visit: https://github.com/arlbibek/windows-ahk/           `n", config_path)
        FileAppend("; ------------------------------------------------------------------------`n`n", config_path)

        section_window_ahk := "WINDOWS-AHK"
        IniWrite("", config_path, section_window_ahk)
        IniWrite("true", config_path, section_window_ahk, "first_launch")
        IniWrite("true", config_path, section_window_ahk, "splash_screen")
        FileAppend("`n`n", config_path)

        FileAppend("; == FUNCTION KEYS CONFIGURATION >>`n", config_path)
        FileAppend("; Configure actions for function keys (e.g., F1, F2, ...)`n", config_path)
        FileAppend("; Go aheade and update the path for each function key as needed`n", config_path)
        FileAppend("; App options for function key: `n", config_path)
        FileAppend("; default_browser, all_browsers `n", config_path)
        FileAppend("`n", config_path)

        section_function_keys := "FUNCTION KEYS"
        IniWrite("", config_path, section_function_keys) ; wtite section name
        ; Write default keys, values
        Loop default_apps.Length ; Loop through the array
        {
            key := "f" A_Index
            IniWrite(default_apps[A_Index], config_path, section_function_keys, key)
        }
        FileAppend("`n`n", config_path)


        TrayTip("Configuration file resotred with default configuration. , Configuration restored.")
    }

}

restoreDefaultConfig(*) {
    ; default config

    if MsgBox("Configuration file will be restored back to default? `n`nContinue?", A_ScriptName . " - Restore configuration", "0x1") {
        if FileExist(config_path) {
            FileDelete(config_path)
        }
        loadDefaultConfig()
    }
}

launchSplashScreen(*) {
    splashUI.Show()
}

reloadScript(*) {
    Reload
}

viewGitHubSource(*) {
    ; Opens the script's source code on GitHub.
    Run("https://github.com/arlbibek/windows-ahk/")
}

viewAHKDocumentation(*) {
    ; Opens the official AutoHotkey v2 documentation.
    Run("https://www.autohotkey.com/docs/v2/")
}

; == FUNCTIONS ====================>

getDefaultBrowser() {
    ; Function: getDefaultBrowser
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


manageProgramWindows(programPath, ahkType := "ahk_exe", programExe := "") {
    ; Function: manageProgramWindows
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


getSelectedText() {
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


performWebSearch(searchStr, cmd := "#s") {
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
        SendText(searchStr)   ; Type the search stringfkalsjlksdjffjasdlkjf
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

changeCase(text, txt_case, re_select := False) {
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

exploreTo(path) {
    ; Function: exploreTo
    ; Description: Navigates to a specific path in File Explorer using keyboard shortcuts.
    ; Parameters:
    ;   - path (string): The path to navigate to.

    ; Use Ctrl+L to focus the address bar in File Explorer
    Send("^l")
    Sleep(50)

    ; Type the provided path and press Enter
    SendText(path)
    Sleep(50)
    Send("{Enter}")
}


; Manages program windows based on the provided path for function keys.
; path {string} - The path indicating the desired action or program window(s) to manage.
manageFunctionKey(path) {
    ; Switch statement to handle different paths
    if (StrLower(path) == "default_browser") {
        ; Manage windows for the default browser
        manageProgramWindows(getDefaultBrowser())
    } else if (StrLower(path) == "all_browsers") {
        ; Manage windows for all browsers
        if WinExist("ahk_group browserGroup") {
            manageProgramWindows("browserGroup", "ahk_group")
        } else {
            ; If not for the browser exists start the default browser
            manageProgramWindows(getDefaultBrowser())
        }
    } else {
        ; If the path doesn't match predefined conditions, attempt to manage windows based on the provided path
        manageProgramWindows(path)
    }
}


; CONFIGURATION FILE

splashUI := Gui("MinimizeBox", "Welcome! - " . A_ScriptName)
img_app := A_ScriptDir . "\assets\windows-ahk.png"
if FileExist(img_app) {
    splashUI.AddPicture("w85 h-1", img_app)
}
splashUI.Add("Text", "w250 h50 y5 x115", A_ScriptName).SetFont("s12")
splashUI.Add("Text", "w300 h50 y30 x115 Wrap", "A simple and intuitive AutoHotKey script designed to enhance Windows shortcuts and improve your workflow. ")
splashUI.Add("Button", "w85 y65 x115", "View on GitHub ↗️").OnEvent("Click", viewGitHubSource)
splashUI.Add("Button", "w105 y65 x205", "Keyboard Shortcuts").OnEvent("Click", viewKeyboardShortcuts)
splashUI.Add("Button", "w100 y65 x315 Default", "Launch config window").OnEvent("Click", launchConfigUI)


configUI := Gui("MinimizeBox", A_ScriptName . " - Preferences")
if FileExist(img_app) {
    configUI.AddPicture("w70 h-1 y5 x5", img_app)
}
configUI.Add("Text", "w200 h50 y5 x100 ", "Manage/edit configuratioins").SetFont("s10")
configUI.Add("Button", "w200 y25 x100 ", "&Edit configuration file").OnEvent("Click", openConfigFile)
configUI.Add("Button", "w200 y50 x100", "&Open configuration file location").OnEvent("Click", openConfigFileDir)
configUI.Add("Button", "w200 y75 x100", "&Restore default configuration").OnEvent("Click", restoreDefaultConfig)
configUI.Add("Button", "w90 y75 x5", "&Learn more ↗️").OnEvent("Click", viewGitHubSource)
configUI.Add("Button", "w295 y100 x5 Default ", "Reload script with new configuration").OnEvent("Click", reloadScript)


; == CUSTOMIZE TRAY MENU OPTIONS ==

A_IconTip := A_ScriptName . "`nRight click for more options. "
tray.Add(txt_aurthor, visitAuthorWebsite)
tray.Add()

; Add the "Run at startup" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txt_startup, toggleStartupShortcut)
if FileExist(startupShortcut) {
    tray.check(txt_startup)
} else {
    tray.unCheck(txt_startup)
}

; Add the "Start menu shortcut" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the Start Menu shortcut
tray.Add(txt_startmenu, toggleStartMenuShortcut)
if FileExist(startMenuShortcut) {
    tray.check(txt_startmenu)
} else {
    tray.unCheck(txt_startmenu)
}

; Add other tray menu items
tray.Add(txt_presentationmode, togglePresentationMode)

; Add the "Keyboard shortcuts" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txt_keyboardshortcut, viewKeyboardShortcuts, "Radio")
if FileExist(keyboardShortcutPath) {
    tray.check(txt_keyboardshortcut)
} else {
    tray.unCheck(txt_keyboardshortcut)
}

tray.Add(txt_locatefile, openScriptLocation)
tray.SetIcon(txt_locatefile, "shell32.dll", 4)

tray.Add(txt_launchconfig, launchConfigUI)
tray.SetIcon(txt_launchconfig, "shell32.dll", 70)


tray.Add(txt_github, viewGitHubSource)
tray.SetIcon(txt_github, "shell32.dll", 14)

tray.Add(txt_ahkdoc, viewAHKDocumentation)
tray.SetIcon(txt_ahkdoc, "shell32.dll", 15)
tray.Add()
tray.AddStandard()


toggleSplashScreen(*) {
    splash_screen := IniRead(config_path, "WINDOWS-AHK", "splash_screen")
    if StrLower(splash_screen) == "true" {
        IniWrite("false", config_path, "WINDOWS-AHK", "splash_screen")
    } else {
        IniWrite("true", config_path, "WINDOWS-AHK", "splash_screen")
    }
}


; == START: WINDOWS-AHK ==========>

loadDefaultConfig()

first_launch := IniRead(config_path, "WINDOWS-AHK", "first_launch")
splash_screen := IniRead(config_path, "WINDOWS-AHK", "splash_screen")

; notify
TrayTip("Open keyboard shortcuts with {Ctrl + Shift + Alt + \}`n`n" . txt_aurthor, A_ScriptName " started", "Mute")


if StrLower(splash_screen) == "true" {
    launchSplashScreen()
}
if StrLower(first_launch) == "true" {
    IniWrite("false", config_path, "WINDOWS-AHK", "first_launch")
    IniWrite("false", config_path, "WINDOWS-AHK", "splash_screen")
}

; == HOTKEYS ==

; == FUNCTION KEYS
; // loaded from config file

; Declare variables to store function key values
f1 := f2 := f3 := f4 := f5 := f6 := f7 := f8 := f9 := f10 := f11 := f12 := ""

; Function keys
for index, key in ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12"] {
    ; Read value from the config file
    value := IniRead(config_path, "FUNCTION KEYS", key)

    ; Assign value to the corresponding variable
    if value == "" {
        %key% := key
    } else {
        %key% := value
    }
}


F1:: manageFunctionKey(f1)
F2:: manageFunctionKey(f2)
F3:: manageFunctionKey(f3)
F4:: manageFunctionKey(f4)
F5:: manageFunctionKey(f5)
F6:: manageFunctionKey(f6)
F7:: manageFunctionKey(f7)
F8:: manageFunctionKey(f8)
F9:: manageFunctionKey(f9)
F10:: manageFunctionKey(f10)
F11:: manageFunctionKey(f11)
F12:: manageFunctionKey(f12)


; == Windows + {Keys}

; File Explorer
#e:: manageProgramWindows("CabinetWClass", "ahk_class", "explorer.exe")
#+e:: Run("explorer.exe")

; Notepad
#n:: manageProgramWindows("Notepad.exe")
#+n:: Run("Notepad.exe")

; Search via web
#s:: performWebSearch(getSelectedText())
#+s:: performWebSearch(A_Clipboard, "#+s")

; toggle presentation mode
#+p:: togglePresentationMode()

; == Capslock + {Keys}

CapsLock & 7:: changeCase(getSelectedText(), "lower", true)
CapsLock & 8:: changeCase(getSelectedText(), "titled", true)
CapsLock & 9:: changeCase(getSelectedText(), "upper", true)

; == Ctrl + Shift + {Keys} ==

#HotIf WinActive("ahk_group ms365Group")
^+v:: { ; paste as plaintext in MS 365 apps
    Send("{AppsKey}")
    Send("T")
}
#HotIf

^+c:: { ;  Copy text ithout new lines (useful for copying text from a PDF file)
    Send("^c") ; Copy the selected text
    ClipWait(3) ; Wait for up to 3 seconds for the clipboard to contain data
    A_Clipboard := StrReplace(A_Clipboard, "`r`n", " ") ; Replace carriage returns and line feeds with spaces
    A_Clipboard := StrReplace(A_Clipboard, "- ", "") ; Remove hyphens
}
^+`:: manageProgramWindows("C:\Program Files\SyncTrayzor\SyncTrayzor.exe") ; open syncthing


; == Ctrl + Shift + Alt + {Keys} ==
^+!k:: viewKeyboardShortcuts() ; open keyboard shortcuts

^+!s:: {
    Suspend
    if (A_IsSuspended = 1) {
        TrayTip("All hotkeys will be suspended (paused). `n`nPress {Ctrl + Shift + Alt + S} or use the tray menu option to toggle back.", A_ScriptName " suspended", "Iconi Mute")
    } else {
        TrayTip("All hotkeys resumed (will work as intended). `n`nPress {Ctrl + Shift + Alt + S} to suspend.", A_ScriptName " restored", "Iconi Mute")
    }
}
; == Other keys

; Replace space(s) with underscore(s) in the selected text (e.g., `Hello World` to `Hello_World`)
+Space:: {
    text := getSelectedText() ; Get the currently selected text
    formattedText := StrReplace(text, " ", "_") ; Replace spaces with underscores in the selected text
    SendText(formattedText) ; Send the formatted text
    Send("+{left " . StrLen(RegExReplace(text, "(\n)")) . "}") ; Attempt to re-select the selected text
}

; == File Explorer

#HotIf WinActive("ahk_group explorerGroup")
^+u:: exploreTo(userdir)
^+e:: exploreTo(pc)
^+h:: exploreTo(desktop) ; h for home
^+d:: exploreTo(documents)
^+j:: exploreTo(downloads)
^+m:: exploreTo(music)
^+p:: exploreTo(pictures)
^+v:: exploreTo(videos)

^+t:: exploreTo("powershell")
; ^+\:: TODO: open vs code
#HotIf

; TODO: Close the active window if esc is consecutvely pressed 3 timer                                                                                                                                |
; Esc:: ;

; == HOTSTRINGS ==

; ; Current date and time
sendFormattedDt(format, datetime := "") {
    if (datetime = "") {
        datetime := A_Now
    }
    SendText(FormatTime(datetime, format))
    return
}

; == Hotstrings ==========>

; == Date and time

::/datetime:: {
    sendFormattedDt("dddd, MMMM dd, yyyy, HH:mm") ; Sunday, September 24, 2023, 16:31
}
::/datetimet:: {
    sendFormattedDt("dddd, MMMM dd, yyyy hh:mm tt") ; Sunday, September 24, 2023 04:31 PM
}
::/time:: {
    sendFormattedDt("HH:mm") ; 16:31
}
::/timet:: {
    sendFormattedDt("hh:mm tt") ; 04:31 PM
}
::/date:: {
    sendFormattedDt("MMMM dd, yyyy") ; September 24, 2023
}
::/daten:: {
    sendFormattedDt("MM/dd/yyyy") ; 09/24/2023
}
::/datet:: {
    sendFormattedDt("yyyy.MM.dd") ; 2023.09.24
}
::/week:: {
    sendFormattedDt("dddd") ; Sunday
}
::/day:: {
    sendFormattedDt("dd") ; 24
}
::/month:: {
    sendFormattedDt("MMMM") ; September
}
::/monthn:: {
    sendFormattedDt("MM") ; 09
}
::/year:: {
    sendFormattedDt("yyyy") ; 2023
}

; == Others

::wtf::Wow that's fantastic
::/paste:: {
    SendInput(A_Clipboard)
}
::/cud:: {
    SendText("/mnt/c/Users/" A_UserName)
}
::/nrd::npm run dev
::/gm::Good morning
::/ge::Good evening
::/gn::Good night
::/ty::Thank you
::/tyvm::Thank you very much
::/wc::Welcome
::/mp::My pleasure
::/lorem::Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::/plankton::Plankton are the diverse collection of organisms found in water that are unable to propel themselves against a current. The individual organisms constituting plankton are called plankters. In the ocean, they provide a crucial source of food to many small and large aquatic organisms, such as bivalves, fish and whales.

; ---
; Made with ❤️ by Bibek Aryal
;
