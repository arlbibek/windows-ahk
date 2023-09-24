#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent(true)


; grouping explorers
GroupAdd("explorerGroup", "ahk_class CabinetWClass")
GroupAdd("explorerGroup", "ahk_class #32770") ; This is for all the Explorer-based "save" and "load" boxes, from any program!

; grouping browsers
GroupAdd("browserGroup", "ahk_exe firefox.exe")
GroupAdd("browserGroup", "ahk_exe chrome.exe")
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


; Define the path to the script's startup shortcut
global startupShortcut := A_Startup "\" A_ScriptName ".lnk"
; Define the path to the script's Start Menu shortcut
global startMenuShortcut := A_StartMenu "\Programs\" A_ScriptName ".lnk"

; Define the URL and keyboardShortcut file/path
global keyboardShortcutUrl := "https://raw.githubusercontent.com/arlbibek/windows-ahk/master/keyboardshortcuts.pdf"
global keyboardShortcutFilename := "keyboardshortcuts.pdf"
global keyboardShortcutPath := A_ScriptDir "\" keyboardShortcutFilename

; Define menu item text
global txtStartup := "Run at startup"
global txtStartMenu := "Start menu entry"
global txtPresentationMode := "Presentation mode {Win+Shift+P}"
global txtKeyboardShortcut := "Keyboard shortcuts {Ctrl+Shift+Alt+\}"

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

; INITIALIZE TRAY MENU
TraySetIcon("shell32.dll", 16) ; this changes the icon into a little laptop thing.
tray := A_TrayMenu
tray.delete() ; Delete existing items from the tray menu

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

    ; TODO: IMPROVE: Check if the program path is empty and return if it is
    if StrLen(programPath) < 1 {
        MsgBox(A_ThisHotkey)
        return
    }

    ; Check if any windows of the specified program exist
    if not WinExist(ahkProgram) {
        ; If no windows exist, run the program to start it
        if StrLen(programExe) > 1 {
            Run(programExe)
        } else {
            Run(programPath)
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
    Clipboard := savedClipboard

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

    ; Check if the active window is a browser
    if WinActive("ahk_group browserGroup") {
        Send("^t")        ; Open a new tab
        SendText(searchStr)   ; Type the search string
        Send("{Enter}")   ; Press Enter to initiate the search
    }
    ; Check if the search string is a URL
    else if (RegExMatch(searchStr, "^(https?:\/\/|www\.)")) {
        Run(searchStr)    ; Open the URL in the default web browser
    }
    else {
        ; Replace spaces with pluses and escape special characters for a DuckDuckGo search
        searchStr := StrReplace(searchStr, " ", "+")  ; Replace spaces with plus signs
        searchStr := RegExReplace(searchStr, "([&|<>])", "\$1")  ; Escape special characters

        ; Run a DuckDuckGo search with the modified search string
        Run("https://duckduckgo.com/?q=" . searchStr . "&ia=answer")
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


toggleStartupShortcut(*) {
    ; Function: toggleStartupShortcut
    ; Description: Toggles the script's startup shortcut in the Windows Startup folder.

    ; Check if the startup shortcut already exists
    if FileExist(startupShortcut) {
        ; If it exists, delete the shortcut
        FileDelete(startupShortcut)

        ; Display a TrayTip indicating the result
        if not FileExist(startupShortcut) {
            tray.unCheck(txtStartup)
            TrayTip("Startup shortcut removed", "This script won't start automatically", "0x1")
        } else {
            TrayTip("Startup shortcut removal failed", "Something went wrong", "0x3")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, startupShortcut)

        ; Display a TrayTip indicating the result
        if FileExist(startupShortcut) {
            tray.check(txtStartup)
            TrayTip("Startup shortcut added", "This script will run at startup", "0x1")
        } else {
            TrayTip("Startup shortcut creation failed", "Something went wrong", "0x3")
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
            tray.unCheck(txtStartMenu)
            TrayTip("Start menu shortcut removed", "The script won't be shown in the Start Menu", "0x1")
        } else {
            TrayTip("Start menu shortcut removal failed", "Something went wrong", "0x3")
        }
    } else {
        ; If it doesn't exist, create the shortcut
        FileCreateShortcut(A_ScriptFullPath, startMenuShortcut)

        ; Display a TrayTip indicating the result
        if FileExist(startMenuShortcut) {
            tray.check(txtStartMenu)
            TrayTip("Start Menu shortcut added", "The script will be shown in the Start Menu", "0x1")
        } else {
            TrayTip("Start menu shortcut creation failed", "Something went wrong", "0x3")
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
        tray.UnCheck(txtPresentationMode)
        TrayTip("Presentation mode has been toggled off.", "Presentation mode: Off", "0x1")
    } else {
        ; Presentation mode is off, turning it on
        ControlSetChecked(1, "Button1", ahk_program)
        ControlSetChecked(1, "Button3", ahk_program) ; check "Turn off screen saver" if not checked
        ControlSetChecked(1, "Button7", ahk_program) ; check OK
        tray.check(txtPresentationMode)
        TrayTip("Presentation mode has been toggled on. Your computer will stay awake indefinitely.", "Presentation mode: On", "0x1")
    }
}


visitAuthorWebsite(*) {
    ; Opens the author's website.
    Run("https://bibeka.com.np/")
}

viewGitHubSource(*) {
    ; Opens the script's source code on GitHub.
    Run("https://github.com/arlbibek/windows-ahk/")
}

viewAHKDocumentation(*) {
    ; Opens the official AutoHotkey v2 documentation.
    Run("https://www.autohotkey.com/docs/v2/")
}

openScriptLocation(*) {
    ; Opens the directory where the current script is located.
    Run(A_ScriptDir)
}

viewKeyboardShortcuts(*) {
    ; Function: viewKeyboardShortcuts
    ; Description: Opens a PDF file containing keyboard shortcuts, or offers to download it if not found.

    ; Check if the PDF file exists locally
    While True {
        if FileExist(keyboardShortcutPath) {
            ; If it exists, open the PDF file
            Run(keyboardShortcutPath)
            tray.check(txtKeyboardShortcut)
            break
        } else {
            ; If it doesn't exist, prompt the user to download it
            response := MsgBox("The '" keyboardShortcutFilename "' file couldn't be located. `nThis PDF file contains a detailed list of keyboard shortcuts for '" A_ScriptName "'.`n`nWould you like to download and open the file?`nURL: " keyboardShortcutUrl, "File not found: Would you like to download?", "0x4")

            if response == "Yes" {
                ; Attempt to download the PDF file
                try {
                    TrayTip("URL: " keyboardShortcutUrl, "Downloading: " keyboardShortcutFilename)
                    Download(keyboardShortcutUrl, keyboardShortcutFilename)
                } catch Error as err {
                    TrayTip("The '" keyboardShortcutFilename "' couldn't be downloaded. Are you offline? Please try again.", "Download failed. Error: " err.message)
                    break
                }
            } else {
                break
            }
        }
    }
}


; == WINDOWS-AHK ==========>

; notify user
TrayTip("Open keyboard shortcuts with {Ctrl + Shift + Alt + \}`n`nMade with ❤️ by Bibek Aryal.", A_ScriptName " started",)


; == CUSTOMIZE TRAY MENU OPTIONS ==

tray.Add("Made with ❤️ by Bibek Aryal.", visitAuthorWebsite)
tray.Add()

; Add the "Run at startup" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txtStartup, toggleStartupShortcut)
if FileExist(startupShortcut) {
    tray.check(txtStartup)
} else {
    tray.unCheck(txtStartup)
}

; Add the "Start menu shortcut" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the Start Menu shortcut
tray.Add(txtStartMenu, toggleStartMenuShortcut)
if FileExist(startMenuShortcut) {
    tray.check(txtStartMenu)
} else {
    tray.unCheck(txtStartMenu)
}

; Add other tray menu items
tray.Add(txtPresentationMode, togglePresentationMode)

; Add the "Keyboard shortcuts" menu item to the tray menu
; Check or uncheck the menu item based on the existence of the startup shortcut
tray.Add(txtKeyboardShortcut, viewKeyboardShortcuts)
if FileExist(keyboardShortcutPath) {
    tray.check(txtKeyboardShortcut)
} else {
    tray.unCheck(txtKeyboardShortcut)
}
tray.Add("Open file location", openScriptLocation)
tray.Add("View in GitHub 🌐", viewGitHubSource)
tray.Add("See AutoHotKey documentation 🌐", viewAHKDocumentation)
tray.Add()
tray.AddStandard()


; == HOTKEYS ==

pf3 := "C:\Users\bibek\AppData\Roaming\Spotify\Spotify.exe"
pf4 := "C:\Users\bibek\AppData\Local\Programs\Microsoft VS Code\Code.exe"
pf6 := "C:\Program Files\SumatraPDF\SumatraPDF.exe"
pf7 := "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
pf8 := "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
pf10 := "powershell.exe"


; == Function Kes

F1:: manageProgramWindows(getDefaultBrowser())
+F1:: Run(getDefaultBrowser())
; F2:: ; is rename
F3:: manageProgramWindows(pf3) ; spotify
F4:: manageProgramWindows(pf4) ; vs code
F6:: manageProgramWindows(pf6) ; sumatraPDF
F7:: manageProgramWindows(pf7) ; ms word
+F7:: Run(pf7) ; ms word
F8:: manageProgramWindows(pf8) ; ms excel
+F8:: Run(pf8) ; ms excel
; F9:: ;
F10:: manageProgramWindows(pf10)
+F10:: Run(pf10)
; F11:: ;
F12:: Send("!{Tab}")

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
^+v:: Send("{AppsKey}t") ; paste as plaintext in MS 365 apps
#HotIf
^+c:: { ;  Copy text without new lines (useful for copying text from a PDF file)
    Send("^c") ; Copy the selected text
    ClipWait(3) ; Wait for up to 3 seconds for the clipboard to contain data
    A_Clipboard := StrReplace(A_Clipboard, "`r`n", " ") ; Replace carriage returns and line feeds with spaces
    A_Clipboard := StrReplace(A_Clipboard, "- ", "") ; Remove hyphens
}
^+`:: manageProgramWindows("C:\Program Files\SyncTrayzor\SyncTrayzor.exe") ; open syncthing


; == Ctrl + Shift + Alt + {Keys} ==

^+!\:: viewKeyboardShortcuts() ; paste as plaintext in MS 365 apps
^+!s:: {
    Suspend
    if (A_IsSuspended = 1) {
        TrayTip("All hotkeys will be suspended (paused). `n`nPress {Ctrl + Shift + Alt + S} or use the tray menu option to toggle back.", A_ScriptName " suspended", "0x1")
    } else {
        TrayTip("All hotkeys resumed (will work as intended). `n`nPress {Ctrl + Shift + Alt + S} to suspend.", A_ScriptName " restored", "0x1")
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
