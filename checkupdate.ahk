#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

chekForUpdate() {
    whr := ComObject("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", "https://api.github.com/repos/arlbibek/windows-ahk/releases/latest", true)
    whr.Send()
    ; Using 'true' above and the call below allows the script to remain responsive.
    whr.WaitForResponse()
    ; version := whr.ResponseText

    ; Simpler RegEx pattern
    RegExMatch(whr.ResponseText, 'tag_name":"(.*?)"', &match)
    version := match[1]
    MsgBox version
}
f5:: chekForUpdate()