#Requires AutoHotkey v2.0

ConvertToExe(ahkFileName) {
    ; Define file paths
    ahkFilePath := A_ScriptDir "\" ahkFileName
    exeFileName := StrUpper(StrReplace(ahkFileName, ".", "_")) ".exe"
    exeFilePath := A_ScriptDir "\" exeFileName
    iconPath := A_ScriptDir "\assets\windows-ahk.ico"

    ; Define Ahk2Exe path
    ahk2exe := "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"

    ; Run Ahk2Exe
    RunWait(ahk2exe " /in " ahkFilePath " /out " exeFilePath " /icon " iconPath)

    ; Check if the EXE was created successfully
    if FileExist(exeFilePath) {
        TrayTip("File: " ahkFileName "`nConverted to: " exeFileName "`n`nSee: " exeFilePath, "Convert " ahkFileName " to exe")
    } else {
        TrayTip(exeFileName " not created.", "Something went wrong")
    }
}

ConvertToExe("WINDOWS.ahk")
ExitApp