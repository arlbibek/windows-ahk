#NoTrayIcon

convert2exe(source) {
    ahk2exe = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
    name := StrReplace(source, ".", "-")
    StringUpper, name, name
    exe = %name%.exe
    ico = assets\shell32_16.ico

    Run, %ahk2exe% /in %A_ScriptDir%\%source% /out %A_ScriptDir%\%exe% /icon %A_ScriptDir%\%ico%

    display_message(source, exe)
}

display_message(source, exe) {
    MsgBox,,Create exe,`n%source% converted to %exe%
}

convert2exe("WINDOWS.ahk")
