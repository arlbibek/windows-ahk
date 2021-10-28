﻿#SingleInstance Force ; Skips the dialog box and replaces the old instance automatically.
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

Menu, Tray, Icon, shell32.dll, 16 ;this changes the icon into a little laptop thingy.

; grouping all terminal (WSLs as well)
GroupAdd, TerminalGroup, ahk_exe WindowsTerminal.exe
GroupAdd, TerminalGroup, ahk_exe powershell.exe
GroupAdd, TerminalGroup, ahk_exe cmd.exe
GroupAdd, TerminalGroup, ahk_exe debian.exe
GroupAdd, TerminalGroup, ahk_exe kali.exe
GroupAdd, TerminalGroup, ahk_exe ubuntu.exe

GroupAdd, ExplorerGroup, ahk_class #32770 ;This is for all the Explorer-based "save" and "load" boxes, from any program!
GroupAdd, ExplorerGroup, ahk_class CabinetWClass 

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

exp(path){
    ; navigate to path using ctrl + l in file explorer
    Send, ^l^a
    Sleep, 50
    Send, %path%
    Sleep, 50
    Send, {Enter}
}

; HOTKEYS

; Search selected text/clipboard on the web
#s::
    if WinActive("ahk_group TerminalGroup")
        Send, ^+c
    else
        Send, ^c

    Sleep, 100

    IfInString, Clipboard, http
        Run, %Clipboard%
    else
        IfInString, Clipboard, www
        Run, %Clipboard%
    else
        Run https://duckduckgo.com/?t=ffab&q=%Clipboard%&atb=v292-4&ia=web
return

; Notepad
#n::
    IfWinNotExist, ahk_exe notepad.exe
        Run, notepad.exe
    GroupAdd, NotepadGroup, ahk_exe notepad.exe
    if WinActive("ahk_exe notepad.exe"){
        GroupActivate, NotepadGroup, r 
    }
    else
        WinActivate ahk_exe notepad.exe
return
#+n::
    Run, notepad.exe
return

; Joplin - notes
#j::
    try 
    {
        IfWinNotExist, ahk_exe Joplin.exe
            Run, Joplin.exe
    }
    catch e
    {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % "`n"e.extra "`n"e.message "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)" 
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message 
    }
    if WinActive("ahk_exe Joplin.exe")
        WinMinimize, ahk_exe Joplin.exe ; minimize
    else
        WinActivate ahk_exe Joplin.exe
return

; Firefox
F1::
    try 
    {
        IfWinNotExist, ahk_exe firefox.exe
            Run, firefox.exe
    }
    catch e
    {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % "`n"e.extra "`n"e.message "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)" 
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message 
    }
    GroupAdd, FirefoxGroup, ahk_exe firefox.exe
    if WinActive("ahk_exe firefox.exe"){
        GroupActivate, FirefoxGroup, r ; OR REPLACE WITH: Send, ^{Tab}
    }
    else
        WinActivate ahk_exe firefox.exe
return

!F1::
    try 
    {
        IfWinNotExist, ahk_exe Joplin.exe
            Run, firefox.exe
    }
    catch e
    {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % "`n"e.extra "`n"e.message "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)" 
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message 
    }
return

; F2::is Rename

; Spotify
F3::
    try 
    {
        IfWinNotExist ahk_exe spotify.exe
            Run spotify.exe
    }
    catch e
    {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % "`n"e.extra "`n"e.message "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)" 
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message 
    }
    if WinActive("ahk_exe spotify.exe")
        WinMinimize, ahk_exe spotify.exe ; minimize
    else
        WinActivate ahk_exe spotify.exe
return

; VS Code
F4::

    try 
    {
        IfWinNotExist ahk_exe code.exe
            Run code.exe
    }
    catch e
    {
        err := e.extra
        FileNotFound := "The system cannot find the file specified."
        IfInString, err, %FileNotFound%
        {
            MsgBox, % "`n"e.extra "`n"e.message "`n`nNote: Please consider adding the respective program (folder) to the PATH of the System Variables. (This may need system restart to take effect)" 
            return
        }
        else
            MsgBox, 16,, % e.extra "`n"e.message 
    }
    GroupAdd, CodeGroup, ahk_exe code.exe
    if WinActive("ahk_exe code.exe")
        GroupActivate, CodeGroup, r
    else
        WinActivate ahk_exe code.exe
return

; F5::is Refresh
; F6::
; F7::
; F8::
; F9::
; F10::
; F11::is Full Screen
; F12::Opens chrome from my other script

; File Explorer

; open/switch to file explorer 
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

#+e::
    Run, explorer.exe
Return

; navigating within the file Explorer
#IfWinActive ahk_group ExplorerGroup
    ^+u::exp(userdir)
    ^+e::exp(pc)
    ^+h::exp(desktop)
    ^+d::exp(documents)
    ^+j::exp(downloads)
    ^+m::exp(music)
    ^+p::exp(pictures)
    ^+v::exp(videos)
    ^+c::exp(c)
    ^+a::exp(arlbibek)
    ^+s::exp(screenshot)
#IfWinActive

; opening programs via file explorer
#IfWinActive ahk_class CabinetWClass 
    ^+t::exp("wt") ; windows terminal
    ^+\::Send, {AppsKey}{Up}{Up}{Up}{Up}{Enter} ; vscode in current directory
#IfWinActive

; TERMINALs

#IfWinActive, ahk_group TerminalGroup
    ^+\::Send, code .{Enter} ; vscode in current directory
    ^+w:: WinClose, TerminalGroup
::cud:: 
    SendInput, /mnt/c/Users/%A_UserName%/ ; useful for WSLs
Return
#IfWinActive

; HOTSTRINGS

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
::/today::
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
::/mp::My pleasure
::/lorem::Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

; NSFW 😈

#IfWinActive ahk_exe slack.exe
    ::/wct::Hi, Welcome to the team. 🙏 `:play_piano:` 🎊 `:partyparrot:`
#IfWinActive

; That is all. 
; Made with ❤️ by Bibek Aryal. 

