#Requires AutoHotkey v2.0

#Include globals.ahk

get_hotstrings(filename, section := hotstrings_section) {
    ; Reads hotstrings from an INI file and registers them dynamically
    ; Get all keys in the section
    try {
        keys_values := IniRead(filename, section)
        for key_value in StrSplit(keys_values, "`n") {
            key := StrSplit(key_value, "=", , 2)[1]
            value := StrSplit(key_value, "=", , 2)[2]
            HotString("::" . key, value)
        }
    } catch as e {
        MsgBox(e.Message . "`n Specifically, section: " . section, , "OK Icon!")
        return
    }
}

send_formatted_dt(format, datetime := "") {
    ; Sends the current (or given) date/time using a specific format
    if (datetime = "") {
        datetime := A_Now
    }
    SendText(FormatTime(datetime, format))
    return
}

get_well_wishes(filename, section := well_wishes_section) {
    ; Reads greeting values from an INI section and returns them as a list
    greetings := []  ; Initialize empty array

    try {
        keys_values := IniRead(filename, section)
        for key_value in StrSplit(keys_values, "`n") {
            parts := StrSplit(key_value, "=", , 2)
            if parts.Length < 2
                continue

            key := Trim(parts[1])
            value := Trim(parts[2])
            greetings.Push(value)  ; Add value to the list
            ; Optional: MsgBox for debug
            ; MsgBox("Key: " . key . "`nValue: " . value, , "OK Icon!")
        }
    } catch as e {
        MsgBox(e.Message . "`n Specifically, section: " . section, , "OK Icon!")
        return []
    }

    return greetings
}

get_random_item(list) {
    ; Returns a random item from a given list
    try {
        index := Random(1, list.Length)
        return list[index]
    } catch as e {
        return e.Message
    }
}

; Composes and sends a greeting message with dynamic time-based and random components
get_greeting(well_wish) {
    ; Get the current hour
    currentHour := A_Hour

    ; Determine the time-based greeting
    if (currentHour < 12) {
        greeting := "Good morning, "
        end_text := ""
    } else if (currentHour < 18) {
        greeting := "Good afternoon, "
        end_text := ""
    } else if (currentHour >= 21 || currentHour < 6) {
        greeting := ""
        end_text := "Good night. "
    }
    else {
        greeting := "Good evening, "
        end_text := ""
    }

    ; Send the date and time-based greeting
    return "Dear Respected Sir/Ma'am, `n`n" . greeting . "I hope that this email finds you well. `n`n ...`n`n" . well_wish . " Thank you. " . end_text
}

; == HOTSTRINGS ==

; Load hotstrings from the config file
get_hotstrings(config_path)


; hotstring to paste clipboard content
::/paste:: {
    SendText(A_Clipboard)
}

; Hotstrings for date and time formatting

::/datetime:: {
    send_formatted_dt("dddd, MMMM dd, yyyy, HH:mm") ; Tuesday, April 29, 2025, 16:10
}
::/dt:: {
    send_formatted_dt("dddd, MMMM dd, yyyy, HH:mm") ; Tuesday, April 29, 2025, 16:10
}

::/date:: {
    send_formatted_dt("MMMM dd, yyyy") ; April 29, 2025
}

::/time:: {
    send_formatted_dt("HH:mm") ; 16:11
}

; Triggers time-aware, polite email greeting
::/dear:: {
    greeting := get_greeting(get_random_item(get_well_wishes(config_path)))
    SendText(greeting)
}