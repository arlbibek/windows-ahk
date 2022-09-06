#SingleInstance Force ; Skips the dialog box and replaces the old instance automatically.
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Prevent the script from exiting automatically.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

; grouping explorers
GroupAdd, ExplorerGroup, ahk_class CabinetWClass
GroupAdd, ExplorerGroup, ahk_class #32770 ; This is for all the Explorer-based "save" and "load" boxes, from any program!

; grouping browsers
GroupAdd, BrowserGroup, ahk_exe firefox.exe
GroupAdd, BrowserGroup, ahk_exe chrome.exe
GroupAdd, BrowserGroup, ahk_exe brave.exe
GroupAdd, BrowserGroup, ahk_exe msedge.exe
GroupAdd, BrowserGroup, ahk_exe opera.exe
GroupAdd, BrowserGroup, ahk_exe iexplore.exe

; grouping terminals (WSLs as well)
GroupAdd, TerminalGroup, ahk_exe WindowsTerminal.exe
GroupAdd, TerminalGroup, ahk_exe powershell.exe
GroupAdd, TerminalGroup, ahk_exe cmd.exe
GroupAdd, TerminalGroup, ahk_exe debian.exe
GroupAdd, TerminalGroup, ahk_exe kali.exe
GroupAdd, TerminalGroup, ahk_exe ubuntu.exe

; variables
; directory paths
userdir := "C:\Users\" . A_UserName . "\"
pc := "This PC"
desktop := userdir . "Desktop\"
documents := userdir . "Documents\"
downloads := userdir . "Downloads\"
music := userdir . "Music\"
pictures := userdir . "Pictures\"
videos := userdir . "Videos\"
c := "C:\"
arlbibek := documents . "arlbibek\"
screenshot := userdir . "Documents\ShareX\Screenshots\"

; script name and startup path
splitPath, a_scriptFullPath, , , script_ext, script_name
global script_full_name := script_name "." script_ext
global startup_shortcut := a_startup "\" script_full_name ".lnk"

; FUNCTIONS

get_default_browser() {
    ; return ahk_exe name of the users default browser (e.g. firefox.exe) 
    ; referenced from: https://www.autohotkey.com/board/topic/67330-how-to-open-default-web-browser/

    ; Find the Registry key name for the default browser
    RegRead, BrowserKeyName, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice, Progid

    ; Find the executable command associated with the above Registry key
    RegRead, BrowserFullCommand, HKEY_CLASSES_ROOT, %BrowserKeyName%\shell\open\command

    ; The above RegRead will return the path and executable name of the browser contained within quotes and optional parameters
    ; We only want the text contained inside the first set of quotes which is the path and executable
    ; Find the ending quote position (we know the beginning quote is in position 0 so start searching at position 1)
    StringGetPos, pos, BrowserFullCommand, ",,1

    ; Decrement the found position by one to work correctly with the StringMid function
    pos := --pos

    ; Extract and return the path and executable of the browser
    StringMid, BrowserPathandEXE, BrowserFullCommand, 2, %pos%
    splitPath, BrowserPathandEXE, BrowserClassEXE, , script_ext, script_name

    Return BrowserClassEXE
}

activate(program, action:="minimize"){
    ; Open/Switch/(Minimize/Cycle through) a program
    ; `program` is the name of the program (eg. firefox.exe),
    ; `action` is the action to perform when the program window already is in an active state, it should be either "minimize" or "cycle" (default is minimise)
    ahk_type := "ahk_exe"
    try {
        IfWinNotExist %ahk_type% %program%
            Run %program%
    } catch e {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % e.extra "`n"e.message "`n`nNote: Please install and/or consider adding the respective program (folder) to the PATH of the System Variables. `n(This may need system restart to take effect)"
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message
    }
    if (action == "cycle"){
        program_name := StrSplit(program, ".")[1]
        group_name = %program_name%Group
        GroupAdd, %group_name%, %ahk_type% %program%
    }

    ahk_program = %ahk_type% %program%
    if WinActive(ahk_program) {
        If (action == "minimize"){
            WinMinimize, %ahk_type% %program% ; minimize
        } else if (action == "cycle"){
            GroupActivate, %group_name%, r ; cycle
        } else {
            MsgBox % "Wrong parameter value: " action "`nThe parameter 'action' should be either 'minimize' or 'cycle'."
        }
    } else {
        WinActivate, %ahk_type% %program%
    }
}

get_selected(){
    ; copy selected contents to the clipboard
    ; return selected contents via clipboard (sends ctrl + c), but restores the previous contents of the clipboard

    ClipSave := ClipboardAll ; saving the contents of the clipboard
    Clipboard = ; clearing contents of Clipboard
    if WinActive("ahk_group TerminalGroup"){
        Send, ^+c
    }
    else {
        Send, ^c
    }
    ClipWait, 1
    copied = %Clipboard%
    Clipboard := ClipSave ; restoring the contents of the clipboard
    return %copied%
}

win_search(search_str){
    ; Search Of The String Via Active Browser Or Default
    ; Default Search Engine Is DuckDuckGo (& always will be)

    ; only search if something has been selected
    len_str := StrLen(search_str)
    If (len_str == 0) {
        ; resend the command if nothing is selected
        Send, #s
    } else {
        ; Removes all CR+LF's (? next line).
        search_str := StrReplace(search_str, "`r`n")
        if WinActive("ahk_group BrowserGroup") {
            Send, ^t
            SendRaw, %search_str%
            Send, {Enter}
        }
        else {
            ; TODO: Instead of if conditions add RegEx match to detect URL
            if ((InStr(search_str, "http://") = 1) or (InStr(search_str, "https://") = 1) or (InStr(search_str, "www.") = 1))
            {
                Run % search_str
            }
            else {
                search_str := StrReplace(search_str, A_Space, "+") ; Replaces all spaces with pluses.
                ; TODO: Find a  way to escape special characters (such as  !*'();:@&=+$,/?#[]) in a variable.
                Run, https://duckduckgo.com/?t=ffab&q=%search_str%&atb=v292-4&ia=web
            }
        }
    }
}

exploreTo(path){
    ; navigate to a path using ctrl + l in file explorer
    Send, ^l^a
    Sleep, 50
    Send, %path%
    Sleep, 50
    Send, {Enter}
}

changeCaseTo(case){
    ; Change selected text to "lower", "titled" or "upper" case letters
    selected_text := get_selected()
    if (case == "lower"){
        StringLower, selected_text, selected_text
    }
    else if (case == "titled") {
        StringUpper selected_text, selected_text, T
    }
    else if (case == "upper") {
        StringUpper, selected_text, selected_text
    }
    else {
        MsgBox % "Wrong parameter value: " case "`nThe parameter should be either 'lower', 'titled' or 'upper'."
    }
    Sleep, 10
    Send, {Text}%selected_text% ; The {Text} mode is similar to the Raw mode, except that no attempt is made to translate characters (other than `r, `n, `t and `b) to keycodes

    ; attempting to reselect the previously selected text
    str_len := StrLen(selected_text)
    Send, +{left %str_len%}
    Send, {CapsLock} ; resetting CapsLock previous  state
}

; For google docs/sheets
docSheetWr(text){
    ; for google docs/sheets only
    gdoc := " - Google Docs"
    gsheet := " - Google Sheets"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gdoc, True) || InStr(ActiveTitle, gsheet, True) {
        Send, %text%
    }
}

docWr(text){
    ; for google docs
    gdoc := " - Google Docs"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gdoc, True) {
        Send, %text%
    }
}

sheetWr(text){
    ; for google sheets
    gsheet := " - Google Sheets"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gsheet, True) {
        Send, %text%
    }
}

; For modifying tray menu

runAtStartup(){
    ; Toggle run at startup for the current script
    IfExist, %startup_shortcut% {
        FileDelete, % startup_shortcut
        Menu, Tray, unCheck, Run at startup
        TrayTip, Startup shortcut removed, This script will not run when you turn on your computer, 5, 1
    } else
    {
        FileCreateShortcut, % a_scriptFullPath, % startup_shortcut
        Menu, Tray, check, Run at startup
        TrayTip, Startup shortcut added, This script will now automatically run when your turn on your computer, 5, 1
    }
}

togglePresentationMode(){
    ; Toggle presentation mode
    Run, presentationsettings.exe
    Sleep, 500

    ControlGet, presentationMode, Checked, , Button1, Presentation Settings, , ,

    If (presentationMode == 1){
        ; presentationMode is on, turning it off
        Control, UnCheck , , Button1, Presentation Settings, , ,

        TrayTip, Presentation mode has been toggled off, Your computer will sleep accordingly, 5, 1
        Menu, Tray, % "unCheck", Presentation mode {Ctrl+Alt+P} ; updating tray menu status

    } Else {
        ; presentationMode is off, turning it on
        Control, Check , , Button1, Presentation Settings, , ,
        Control, Check , , Button3, Presentation Settings, , ,

        TrayTip, Presentation mode has been toggled on, Your computer will stay awake indefinitely, 5, 1
        Menu, Tray, % "check", Presentation mode {Ctrl+Alt+P} ; updating tray menu status
    }
    ; Closing Presentation Settings window
    Control, Check, , Button7, Presentation Settings, , ,
}

viewInGithub(){
    ; view source code in github
    Run, https://github.com/arlbibek/windows-ahk
}

viewAHKDoc(){
    ; view 
    Run, https://www.autohotkey.com/docs/AutoHotkey.htm
}

openFileLocation(){
    Run % A_ScriptDir
}

updateTrayMenu(){
    ; modifying tray menu

    ; removing original menu
    Menu, Tray, NoStandard 

    ; adding run at startup option
    Menu, Tray, Add, Run at startup, runAtStartup
    Menu, Tray, % fileExist(startup_shortcut) ? "check" : "unCheck", Run at startup

    ; adding toggle Presentation mode option
    Menu, Tray, Add, Presentation mode {Ctrl+Alt+P}, togglePresentationMode

    ; adding open file (script) location
    Menu, Tray, Add, Open file location, openFileLocation

    Menu, Tray, Add ; create a separator line

    ; adding view on github option
    Menu, Tray, Add, View in GitHub, viewInGithub

    ; adding see ahk documentation option
    Menu, Tray, Add, See AutoHotKey documentation, viewAHKDoc

    ; puts original menu back
    Menu, Tray, Add 
    Menu, Tray, Standard 
}

; ====================================

; showing a tray notification that the script has started
TrayTip, , %script_full_name% started, 5, 1
updateTrayMenu()

; == HOTKEYS ==

; Remapping function keys

; F1 to Firefox
F1::activate(get_default_browser(), "cycle")
+F1::Run % get_default_browser()

; F2 is Rename
; F2::

; F3 to Spotify
F3::activate("spotify.exe")

; F4 to VS Code
F4::activate("code.exe", "cycle")

; F5 is Refresh
; F5::

; F6 is SumatraPDF
F6::activate("SumatraPDF.exe")

; F7 to Microsoft
F7::activate("winword.exe")

; F8 to Microsoft Excel
F8::activate("excel.exe")

; F9 is
; F9::

; F10 is
; F10::

; F11 is
; F11::

; F12 is
; F12::

; Windows hotkeys

; file explorer
#e::
    IfWinNotExist, ahk_class CabinetWClass
        Run, explorer.exe
    GroupAdd, ActiveExplorers, ahk_class CabinetWClass
    if WinActive("ahk_exe explorer.exe"){
        GroupActivate, ActiveExplorers, r
    }
    else
        WinActivate ahk_class CabinetWClass
return
#+e::Run, explorer.exe

; notepad
#n::activate("notepad.exe", "cycle")
+#n::Run, notepad.exe

; search selected text/clipboard on the web
#s::win_search(get_selected())
+#s::win_search(Clipboard)

;  center window
#c::
    WinGetTitle, ActiveWindowTitle, A
    WinGetPos,,, Width, Height, %ActiveWindowTitle%
    TargetX := (A_ScreenWidth / 2) - (Width / 2)
    TargetY := (A_ScreenHeight / 2) - (Height / 2)
    WinMove, %ActiveWindowTitle%,, %TargetX%, %TargetY%
Return

; Other Hotkeys

; Copy text without the new line (useful for copying text from pdf file)
^!c:: 
    Clipboard=
    Send, ^c
    ClipWait, 3
    Clipboard := StrReplace(Clipboard, "`r`n", " ") ; trim Next line
    Clipboard := StrReplace(Clipboard, "- ", "") ; trim
Return

; Toggle presentation mode
^!p::togglePresentationMode()

; Change the case of selected text(s)
CapsLock & 7::changeCaseTo("lower")
CapsLock & 8::changeCaseTo("titled")
CapsLock & 9::changeCaseTo("upper")

; Easy Window Dragging (requires XP/2k/NT)
; https://www.autohotkey.com
; Normally, a window can only be dragged by clicking on its title bar.
; This script extends that so that any point inside a window can be dragged.
; To activate this mode, hold down CapsLock or the middle mouse button while
; clicking, then drag the window to a new position.

; Note: You can optionally release CapsLock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.
; This script requires v1.0.25+.

CapsLock & LButton::
    CoordMode, Mouse ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState = 0 ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U ; Button has been released, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, Off
        return
    }
    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D ; Escape has been pressed, so drag is cancelled.
    {
        SetTimer, EWD_WatchMouse, Off
        WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
        return
    }
    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse:
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
    SetWinDelay, -1 ; Makes the below move faster/smoother.
    WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    EWD_MouseStartX := EWD_MouseX ; Update for the next timer-call to this subroutine.
    EWD_MouseStartY := EWD_MouseY
return

; Replace A_Space with underscore
+Space::
    str := get_selected()
    str := StrReplace(str, A_Space, "_")
    SendRaw % str

    ; attempting to reselect the previously selected text
    str_len := StrLen(str)
    Send, +{left %str_len%}
Return

$Escape:: ; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
    KeyWait, Escape, T0.5 ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
    If ErrorLevel ; timeout, so key is still down...
    {
        SoundPlay *64 ; Play an asterisk
        WinGet, X, ProcessName, A
        SplashTextOn,,150,,`nRelease button to close %x%`n`nKeep pressing it to NOT close window...
        KeyWait, Escape, T3 ; Wait no more than 3 more sec for key to be released
        SplashTextOff
        If !ErrorLevel ; No timeout, so key was released
        {
            PostMessage, 0x112, 0xF060,,, A ; ...so close window      
            Return
        }
        ; Otherwise,                
        SoundPlay *64
        KeyWait, Escape ; Wait for button to be released
        ; Then do nothing...            
        Return
    }

    Send {Esc}
    ; REFERENCED FROM: https://www.autohotkey.com/board/topic/80697-long-keypress-hotkeys-wo-modifiers/
Return

; Hotkeys within file explorers

; navigating within the file explorer
#IfWinActive ahk_group ExplorerGroup
    ^+u::exploreTo(userdir)
    ^+e::exploreTo(pc)
    ^+h::exploreTo(desktop)
    ^+d::exploreTo(documents)
    ^+j::exploreTo(downloads)
    ^+m::exploreTo(music)
    ^+p::exploreTo(pictures)
    ^+v::exploreTo(videos)
    ^+a::exploreTo(arlbibek)
    ^+s::exploreTo(screenshot)
#IfWinActive

; opening programs via file explorer
#IfWinActive ahk_class CabinetWClass
    ^+t::exploreTo("wt") ; windows terminal
    ^+\::exploreTo("code .") ; VS code in current directory
#IfWinActive

; Hotkeys within google docs and sheets

^Insert::docSheetWr("^!m") ; open comment box

; Move the current sheet/docs to trash
^Delete::
    docSheetWr("!/Move to trash")
    Sleep, 200
    docSheetWr("{Enter}")
return

; Highlight selected text/shell
!1::
    docSheetWr("!/Highlight color: yellow")
    Sleep, 200
    docSheetWr("{Enter}")
return

; Remove Highlight for selected text/shell(s)
!+1::
    docSheetWr("!/Highlight color: none")
    Sleep, 200
    docSheetWr("{Enter}")
return

; Wrap selected shell (Sheets only)
!2::
    sheetWr("!/Wrap text{Down 2}{Enter}")
    Sleep, 200
    sheetWr("{Enter}")
return

; Trim whitespace (Sheets only)
!3::
    sheetWr("!/Trim whitespace")
    Sleep, 200
    docSheetWr("{Enter}")
return

; Spell check
!4::
    docSheetWr("!/Spell check")
    Sleep, 200
    docSheetWr("{Enter}")
return

;  Strike selected text
!8::docSheetWr("!+5")

; == HOT STRINGS ==

; Current date and time

::/datetime::
    FormatTime, CurrentDateTime,, dddd, MMMM dd, yyyy, HH:mm
    SendInput, %CurrentDateTime%
Return
::/datetimett::
    FormatTime, CurrentDateTime,, dddd, MMMM dd, yyyy hh:mm tt
    SendInput, %CurrentDateTime%
Return
::/time::
    FormatTime, CurrentDateTime,, HH:mm
    SendInput, %CurrentDateTime%
Return
::/timett::
    FormatTime, CurrentDateTime,, hh:mm tt
    SendInput, %CurrentDateTime%
Return
::/date::
    FormatTime, CurrentDate,, MMMM dd, yyyy
    SendInput, %CurrentDate%
Return
::/daten::
    FormatTime, CurrentDate,, MM/dd/yyyy
    SendInput, %CurrentDate%
Return
::/week::
    FormatTime, CurrentDate,, dddd
    SendInput, %CurrentDate%
Return
::/day::
    FormatTime, CurrentDate,, dd
    SendInput, %CurrentDate%
Return
::/month::
    FormatTime, CurrentDate,, MMMM
    SendInput, %CurrentDate%
Return
::/monthn::
    FormatTime, CurrentDate,, MM
    SendInput, %CurrentDate%
Return
::/year::
    FormatTime, CurrentDate,, yyyy
    SendInput, %CurrentDate%
Return

; Others
::wtf::Wow that's fantastic
::/paste::
    Send % Clipboard
Return
::/cud::
    ; useful for WSLs
    SendInput, /mnt/c/Users/%A_UserName%/
Return
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

; Made with ❤️ by Bibek Aryal.
