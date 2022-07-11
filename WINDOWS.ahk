#SingleInstance Force ; Skips the dialog box and replaces the old instance automatically.
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

Menu, Tray, Icon, shell32.dll, 16 ;this changes the icon into a little laptop thing.

; grouping all terminal (WSLs as well)
GroupAdd, TerminalGroup, ahk_exe WindowsTerminal.exe
GroupAdd, TerminalGroup, ahk_exe powershell.exe
GroupAdd, TerminalGroup, ahk_exe cmd.exe
GroupAdd, TerminalGroup, ahk_exe debian.exe
GroupAdd, TerminalGroup, ahk_exe kali.exe
GroupAdd, TerminalGroup, ahk_exe ubuntu.exe

GroupAdd, ExplorerGroup, ahk_class #32770 ;This is for all the Explorer-based "save" and "load" boxes, from any program!
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
arlbibek := userdir . "arlbibek\"
screenshot := userdir . "Documents\ShareX\Screenshots\"

; FUNCTIONs

activate(program, action:="minimize", ahk_type:="ahk_exe"){
    ; Open/Switch/(Minimize/Cycle through) a program
    ; `program` is the name of the program (eg. firefox.exe), 
    ; `action` is the action to perform on when the program window already is in active state, should be either "minimize" or "cycle" (default is minimize)
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
    ; copy selected contents to clipboard 
    ;  return selected contents via clipboard (sends ctrl + c), but restores the previous contents of clipboard

    ClipSave := ClipboardAll ; saving the contents of clipboard
    Clipboard = 
    if WinActive("ahk_group TerminalGroup"){
        Send, ^+c
    }
    else {
        Send, ^c
    }
    ClipWait, 2
    copied = %Clipboard%
    Clipboard := ClipSave ; restoring the contents of clipboard
    return copied
}

exploreTo(path){
    ; navigate to path using ctrl + l in file explorer
    Send, ^l^a
    Sleep, 50
    Send, %path%
    Sleep, 50
    Send, {Enter}
}

pathErrMsgBox(eextra, emessage){
    ; displays path error message to the user
    MsgBox, % "`n"eextra "`n"emessage "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)"
}

errMsgBox(eextra, emessage){
    ; displays error message to the user
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
    SendRaw, %selected_text%

    ; reselecting the text
    Len := Strlen(selected_text)
    Send +{left %Len%}
    Sleep, 10
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

; F6 to Microsoft 
F6::activate("winword.exe")

; F7 to Microsoft Excel 
F7::activate("excel.exe")

; F8 is 
; F8::

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
; close notepad (without saving) on esc
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

    ; only search if something has been selected
    LenSelected := StrLen(selected)
    If (LenSelected != 0){ 
        ; Removes all CR+LF's (? next line).
        selected := StrReplace(selected, "`r`n")
        if WinActive("ahk_group BrowserGroup") 
        {

            Send, ^t
            SendRaw, %selected%
            Send, {Enter}
        }
        else 
        {
            ; TODO: Instead of if conditions add RegEx match to detect url
            if ((InStr(selected, "http://") = 1) or (InStr(selected, "https://") = 1) or (InStr(selected, "www.") = 1))
            {
                Run % selected
            }
            else
            {
                selected := StrReplace(selected, A_Space, "+") ; Replaces all spaces with pluses.
                ; TODO: Find a  way to escape special characters (such as  !*'();:@&=+$,/?#[]) in a variable. 
                Run, https://duckduckgo.com/?t=ffab&q=%selected%&atb=v292-4&ia=web
            }
        }
    } 
return

; change case of selected text(s)
~CapsLock & 7::
    changeCaseTo("lower")
    Send, {CapsLock} ; Resetting CapsLock to previous state
return
~CapsLock & 8::
    changeCaseTo("cap")
    Send, {CapsLock}
return
~CapsLock & 9::
    changeCaseTo("upper")
    Send, {CapsLock}
return

; == File Explore ==

; navigating within the file Explorer
#IfWinActive ahk_group ExplorerGroup
    ^+u::exploreTo(userdir)
    ^+e::exploreTo(pc)
    ^+h::exploreTo(desktop)
    ^+d::exploreTo(documents)
    ^+j::exploreTo(downloads)
    ^+m::exploreTo(music)
    ^+p::exploreTo(pictures)
    ^+v::exploreTo(videos)
    ^+c::exploreTo(c)
    ^+a::exploreTo(arlbibek)
    ^+s::exploreTo(screenshot)
#IfWinActive

; opening programs via file explorer
#IfWinActive ahk_class CabinetWClass 
    ^+t::exploreTo("wt") ; windows terminal
    ^+\::Send, {AppsKey}{Up 4}{Enter} ; vscode in current directory
#IfWinActive

; == TERMINALS ==

#IfWinActive, ahk_group TerminalGroup
^+\::
    ; vscode in current directory
    Send, code .{Enter} 
Return
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

; Terminal Group

#IfWinActive, ahk_group TerminalGroup
::/cud:: 
    ; useful for WSLs
    SendInput, /mnt/c/Users/%A_UserName%/ 
Return
::/nrd::npm run dev
#IfWinActive

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
