#Requires AutoHotkey v2.0
#Include globals.ahk

#Include functions.ahk
#Include function_keys_ui.ahk

; == HOTKEYS ==

; == FUNCTION KEYS

; Declare variables to store function key values
f1 := f2 := f3 := f4 := f5 := f6 := f7 := f8 := f9 := f10 := f11 := f12 := ""

; Function keys
for index, key in ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12"] {
    ; Read value from the config file
    value := IniRead(config_path, function_keys_section, key)

    ; Assign value to the corresponding variable
    if value == "" {
        %key% := key
    } else {
        %key% := value
    }
}

F1:: manage_function_key(f1)
F2:: manage_function_key(f2)
F3:: manage_function_key(f3)
F4:: manage_function_key(f4)
F5:: manage_function_key(f5)
F6:: manage_function_key(f6)
F7:: manage_function_key(f7)
F8:: manage_function_key(f8)
F9:: manage_function_key(f9)
F10:: manage_function_key(f10)
F11:: manage_function_key(f11)
F12:: manage_function_key(f12)

; == Windows + {Keys}

; File Explorer
#e:: manage_program_windows("CabinetWClass", "ahk_class", "explorer.exe")
#+e:: Run("explorer.exe")

; Notepad
#n:: manage_program_windows("Notepad.exe")
#+n:: Run("Notepad.exe")

; Search via web
#s:: perform_web_search(get_selected_text())

; toggle presentation mode
#+p:: toggle_presentation_mode()

; == CapsLock + {Keys}

CapsLock & 7:: change_case(get_selected_text(), "lower", true)
CapsLock & 8:: change_case(get_selected_text(), "titled", true)
CapsLock & 9:: change_case(get_selected_text(), "upper", true)

; == Ctrl + Shift + {Keys} ==
#HotIf WinActive("ahk_group explorerGroup")
^+u:: explore_to(user_dir)
^+e:: explore_to(this_pc)
^+h:: explore_to(desktop) ; h for home
^+d:: explore_to(documents)
^+j:: explore_to(downloads)
^+m:: explore_to(music)
^+p:: explore_to(pictures)
^+v:: explore_to(videos)
^+t:: explore_to("powershell.exe")
^+\:: Send("{AppsKey}i")
#HotIf


; close current window on three consecutive Esc key presses
~Esc::
{
    static count := 0
    static lastTime := 0

    currentTime := A_TickCount

    if (currentTime - lastTime > 400)
        count := 0 ; Reset count if too much time has passed

    count++
    lastTime := currentTime

    if (count = 3) {
        count := 0 ; Reset count after triple press

        if WinActive("ahk_group browserGroup") {
            Send("^w")
        } else {
            WinClose("A")
        }
    }
}

; == Ctrl + Shift + Alt + {Keys} ==

^+!k:: view_keyboard_shortcuts() ; open keyboard shortcuts
^+!s:: toggle_suspend_hotkey()
^+!r:: reload_script()
^+!e:: exit_script()
!f1:: initialize_fkey_manager()