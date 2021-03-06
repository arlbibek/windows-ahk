#SingleInstance Force ; Skips the dialog box and replaces the old instance automatically.
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

Menu, Tray, Icon, shell32.dll, 16 ; this changes the icon into a little laptop thing.

; grouping all terminal (WSLs as well)
GroupAdd, TerminalGroup, ahk_exe WindowsTerminal.exe
GroupAdd, TerminalGroup, ahk_exe powershell.exe
GroupAdd, TerminalGroup, ahk_exe cmd.exe
GroupAdd, TerminalGroup, ahk_exe debian.exe
GroupAdd, TerminalGroup, ahk_exe kali.exe
GroupAdd, TerminalGroup, ahk_exe ubuntu.exe

GroupAdd, ExplorerGroup, ahk_class #32770 ; This is for all the Explorer-based "save" and "load" boxes, from any program!
GroupAdd, ExplorerGroup, ahk_class CabinetWClass

GroupAdd, BrowserGroup, ahk_exe firefox.exe
GroupAdd, BrowserGroup, ahk_exe chrome.exe
GroupAdd, BrowserGroup, ahk_exe brave.exe
GroupAdd, BrowserGroup, ahk_exe msedge.exe

; dir
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

; adding run at startup option to tray menu
splitPath, a_scriptFullPath, , , script_ext, script_name
global startup_shortcut := a_startup "\" script_name "." script_ext ".lnk"

; ==MODIFYING TRAY MENU==
run_at_startup(){
    ; Toggle run at startup for the current script
    IfExist, %startup_shortcut%
    {
        FileDelete, % startup_shortcut
        Menu, Tray, unCheck, Run at startup
        TrayTip, Startup shortcut removed, This script will not run when you turn on your computer, 5, 1
    }
    else
    {
        FileCreateShortcut, % a_scriptFullPath, % startup_shortcut
        Menu, Tray, check, Run at startup
        TrayTip, Startup shortcut added, This script will now automatically run when your turn on your computer, 5, 1
    }
}
visit_startup(){
    Run, C:\Users\bibek\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
}
view_in_github(){
    Run, https://github.com/arlbibek/windows-ahk
}
view_ahk_doc(){
    Run, https://www.autohotkey.com/docs/AutoHotkey.htm
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

update_tray_menu(){

    Menu, Tray, NoStandard ; removing original menu

    Menu, Tray, Add, Run at startup, run_at_startup
    Menu, Tray, % fileExist(startup_shortcut) ? "check" : "unCheck", Run at startup

    Menu, Tray, Add, Presentation mode {Ctrl+Alt+P}, togglePresentationMode

    Menu, Tray, Add ; create a separator line

    ; adding view on github option
    Menu, Tray, Add, View in GitHub, view_in_github

    ; adding see ahk documentation option
    Menu, Tray, Add, See AutoHotKey documentation, view_ahk_doc

    Menu, Tray, Add ; create a separator line
    Menu, Tray, Standard ; puts original menu back
}

update_tray_menu()

; ==FUNCTIONS==

activate(program, action:="minimize", ahk_type:="ahk_exe"){
    ; Open/Switch/(Minimize/Cycle through) a program
    ; `program` is the name of the program (eg. firefox.exe),
    ; `action` is the action to perform when the program window already is in an active state, it should be either "minimize" or "cycle" (default is minimise)
    ; `ahk_type` is the ahk type either ahk_class or ahk_exe (default is ahk_exe),
    try
    {
        IfWinNotExist %ahk_type% %program%
            Run %program%
    }
    catch e
    {
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
    if WinActive(ahk_program)
    {
        If (action == "minimize"){
            WinMinimize, %ahk_type% %program% ; minimize
        }
        else if (action == "cycle"){
            GroupActivate, %group_name%, r ; cycle
        }
        else {
            MsgBox % "Wrong parameter value: " action "`nThe parameter 'action' should be either 'minimize' or 'cycle'."
        }
    }
    else
    {

        WinActivate, %ahk_type% %program%
    }
}

get_selected(){
    ; copy selected contents to the clipboard
    ;  return selected contents via clipboard (sends ctrl + c), but restores the previous contents of the clipboard

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
    ; Change selected text to "lower", "capitalize" or "upper" case letters
    selected_text := get_selected()
    if (case == "lower"){
        StringLower, selected_text, selected_text
    }
    else if (case == "cap" or case == "capitalize") {
        StringUpper selected_text, selected_text, T
    }
    else if (case == "upper") {
        StringUpper, selected_text, selected_text
    }
    else {
        MsgBox % "Wrong parameter value: " case "`nThe parameter should be either 'lower', 'cap' or 'upper'."
    }
    Sleep, 10
    Send, {Text}%selected_text% ; The {Text} mode is similar to the Raw mode, except that no attempt is made to translate characters (other than `r, `n, `t and `b) to keycodes

    ; attempting to reselect the previously selected text
    str_len := StrLen(selected_text)
    Send +{left %str_len%}
}

pathErrMsgBox(eextra, emessage){
    ; displays a path error message to the user
    MsgBox, % "`n"eextra "`n"emessage "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)"
}

errMsgBox(eextra, emessage){
    ; displays an error message to the user
    MsgBox, 16,, % e.extra "`n"e.message
}

docSheetWr(text){
    ; For Google Docs/Sheets only
    gdoc := " - Google Docs"
    gsheet := " - Google Sheets"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gdoc, True) || InStr(ActiveTitle, gsheet, True) {
        Send, %text%
    }
}

docWr(text){
    ; For Google Docs
    gdoc := " - Google Docs"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gdoc, True) {
        Send, %text%
    }
}

sheetWr(text){
    ; For Google Sheets
    gsheet := " - Google Sheets"
    WinGetActiveTitle, ActiveTitle
    if InStr(ActiveTitle, gsheet, True) {
        Send, %text%
    }
}

; == HOTKEYS ==

; Remapping Function Keys

; F1 to Firefox
F1::activate("firefox.exe", "cycle")
+F1::Run, firefox.exe

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

; Windows Keys Hotkeys

; search selected text/clipboard on the web

; windows file explorer
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
; close notepad (without saving) on ESC
#IfWinActive ahk_exe notepad.exe
Esc::
    Send, ^a
    Sleep, 50
    contents_of_notepad := get_selected()
    contents_len := StrLen(contents_of_notepad)
    if (contents_len > 0 ){
        WinClose, ahk_exe notepad.exe
        Send, {Right}{Enter}
    } else {
        WinClose, ahk_exe notepad.exe

    }
return
#IfWinActive

; search selected text
#s::
    selected := get_selected()
    win_search(selected)
return

; Toggle presentation mode
^!p::togglePresentationMode()

; change the case of selected text(s)
CapsLock & 7::
    changeCaseTo("lower")
    Send, {CapsLock} ; Resetting CapsLock to previous state
return
CapsLock & 8::
    changeCaseTo("cap")
    Send, {CapsLock}
return
CapsLock & 9::
    changeCaseTo("upper")
    Send, {CapsLock}
return

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

; == File Explorer ==

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
    ^+\::Send, {AppsKey}{Up 4}{Enter} ; VS code in current directory
#IfWinActive

; == TERMINALS ==

#IfWinActive, ahk_group TerminalGroup
    ; vs code
    ^+\::Send, code .{Enter}
    ; file explorer
    #e::Send, explorer .{Return}
    ^+u::Send, explorer %userdir%{Return}
    ^+e::Send, explorer %pc%{Return}
    ^+h::Send, explorer %desktop%{Return}
    ^+d::Send, explorer %documents%{Return}
    ^+j::Send, explorer %downloads%{Return}
    ^+m::Send, explorer %music%{Return}
    ^+p::Send, explorer %pictures%{Return}
    ^+v::Send, explorer %videos%{Return}
    ^+a::Send, explorer %arlbibek%{Return}
    ^+s::Send, explorer %screenshot%{Return}
#IfWinActive

; == GOOGLE DOCS/SHEETS ==

^Insert::docSheetWr("^!m")

;  strike selected text
^8::docSheetWr("!+5")

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

; move the current sheet/docs to trash
^Delete::
    docSheetWr("!/Move to trash")
    Sleep, 200
    docSheetWr("{Enter}")
return

; == HOT STRINGS ==

; Current Date and Time

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
::/paste::
    Send, %Clipboard%
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
::/mp::
    SendRaw, My pleasure!
return
::/lorem::Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::/plankton::Plankton are the diverse collection of organisms found in water that are unable to propel themselves against a current. The individual organisms constituting plankton are called plankters. In the ocean, they provide a crucial source of food to many small and large aquatic organisms, such as bivalves, fish and whales.

; Made with ❤️ by Bibek Aryal.

