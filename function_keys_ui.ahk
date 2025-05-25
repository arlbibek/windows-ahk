; AutoHotkey v2 Script - F-Key Manager GUI (Improved)
; This script creates a GUI for managing F1-F12 key assignments

#SingleInstance Force
#Include globals.ahk

; ============================================================================
; UTILITY FUNCTIONS
; ============================================================================

; Check if an array contains a specific value
array_has_value(haystack, needle) {
    for index, value in haystack {
        if (value = needle)
            return true
    }
    return false
}

; Read INI file section and return as Map
get_ini_as_map(ini_file_path, ini_section) {
    section_records := Map()

    if !FileExist(ini_file_path) {
        MsgBox("Config file not found: " . ini_file_path, "Error", "Icon!")
        return section_records
    }

    try {
        section_data := IniRead(ini_file_path, ini_section)
    } catch Error as err {
        MsgBox("Failed to read section '" . ini_section . "' from: " . ini_file_path . "`nError: " . err.message, "Error", "Icon!")
        return section_records
    }

    ; Parse the section data
    loop parse, section_data, "`n", "`r" {
        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";")  ; Skip empty lines and comments
            continue

        pos := InStr(line, "=")
        if (pos > 0) {
            key := Trim(SubStr(line, 1, pos - 1))
            value := Trim(SubStr(line, pos + 1))
            if (key != "")
                section_records[key] := value
        }
    }

    return section_records
}

; File chooser dialog
choose_file() {
    try {
        file_path := FileSelect(3, , "Select an executable file", "Executable Programs (*.exe)")
        return file_path  ; Returns empty string if cancelled, not 0
    } catch Error as err {
        MsgBox("Error selecting file: " . err.message, "File Selection Error", "Icon!")
        return ""
    }
}

; Get description text for function key assignment
get_reference_text(program_path) {
    if (program_path = "")
        return "Click Browse to choose a program to run"

    SplitPath(program_path, &basename)

    switch basename {
        case "default_browser":
            return "Launch / cycle through the default browser window(s)"
        case "all_browsers":
            return "Launch default browser / cycle through all active browsers"
        case "browser_tabs":
            return "Launch default/active browser / cycle through active browser tabs"
        case "switch_window":
            return "Switch between two most recent active windows (Alt+Tab)"
        case "switch_tabs":
            return "Switch between multiple tabs in the same window (Ctrl+Tab)"
        default:
            return "Launch / switch to '" . basename . "'"
    }
}

; Save configuration to INI file
save_configuration() {
    try {
        for index, controls in g_FKeyControls {
            key := "f" . index
            selected_index := controls.dropdown.Value
            selected_value := g_FKeyManager.dropdown_values[selected_index]
            edit_value := controls.edit.Text

            ; Determine what to save based on dropdown selection
            value_to_save := (selected_value = "add_app_path") ? edit_value : selected_value

            IniWrite(value_to_save, config_path, function_keys_section, key)
        }
        MsgBox("Configuration saved successfully!", "Success", "IconI")
        return true
    } catch Error as err {
        MsgBox("Failed to save configuration: " . err.message, "Error", "Icon!")
        return false
    }
}

; ============================================================================
; GUI CLASS DEFINITION
; ============================================================================

class fkey_manager_gui {
    __New() {
        this.gui := ""
        this.controls := []
        this.function_keys_details := Map()
        this.text_labels := ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12"]
        this.dropdown_options := ["Custom Program", "Default Browser", "All Browsers", "Browser Tabs", "Switch Window", "Switch Tabs"]
        this.dropdown_values := ["add_app_path", "default_browser", "all_browsers", "browser_tabs", "switch_window", "switch_tabs"]
    }

    Create() {
        ; Load current configuration
        this.function_keys_details := get_ini_as_map(config_path, function_keys_section)

        ; Create main GUI
        this.gui := Gui(, "Funciont Keys Manager - " . A_ScriptName)
        this.gui.OnEvent("Close", (*) => this.gui.Hide())
        this.gui.OnEvent("Size", (*) => this.OnResize())

        ; Add header
        this.gui.Add("Text", "w420 h30 x10 y10", "Function Key Assignment Manager").SetFont("s12")
        this.gui.Add("Text", "w420 h20 x10 y40", "Configure what each Function key (F1 - F12) should do when pressed").SetFont("s9")

        ; Create controls for each F-key
        this.CreateFKeyControls()

        ; Add action buttons
        this.CreateActionButtons()

        ; Store reference globally for save function
        global g_FKeyControls := this.controls

        return this.gui
    }

    CreateFKeyControls() {
        y_pos := 70

        Loop this.text_labels.Length {
            index := A_Index
            key := this.text_labels[index]
            current_value := this.function_keys_details.Get(key, "")

            ; Create control group for this F-key
            group := {}

            ; F-key label
            group.label := this.gui.Add("Text", "w25 h20 x10 y" . y_pos . " Center", StrUpper(key) . ":")

            ; Dropdown for action type
            group.dropdown := this.gui.Add("DropDownList", "w110 h20 x40 y" . y_pos, this.dropdown_options)
            group.dropdown.OnEvent("Change", this.OnDropdownChange.Bind(this, index))

            ; Edit box for custom path
            group.edit := this.gui.Add("Edit", "w270 h20 x155 y" . y_pos, current_value)
            group.edit.OnEvent("Change", this.OnEditChange.Bind(this, index))

            ; Browse button
            group.browse_btn := this.gui.Add("Button", "w50 h20 x375 y" . y_pos + 22, "Browse")
            group.browse_btn.OnEvent("Click", this.OnBrowseClick.Bind(this, index))

            ; Description text
            group.desc_text := this.gui.Add("Text", "w330 h20 x40 y" . (y_pos + 22), get_reference_text(current_value))
            group.desc_text.SetFont("s8 Italic c0x666666")

            ; Set initial dropdown selection and edit box state
            if (array_has_value(this.dropdown_values, current_value) && current_value != "") {
                ; Find the index of the value and select corresponding option
                for i, val in this.dropdown_values {
                    if (val = current_value) {
                        group.dropdown.Choose(i)
                        break
                    }
                }
                group.edit.Text := current_value
                group.edit.Enabled := false
                group.browse_btn.Enabled := false
            } else {
                group.dropdown.Choose(1) ; "Custom Program"
                group.edit.Text := current_value  ; Show the custom path
                group.edit.Enabled := true
                group.browse_btn.Enabled := true
            }

            this.controls.Push(group)
            y_pos += 45
        }
    }

    CreateActionButtons() {
        y_pos := 70 + (this.text_labels.Length * 45) + 15

        ; Save button
        save_btn := this.gui.Add("Button", "w70 h30 x10 y" . y_pos, "Save")
        save_btn.OnEvent("Click", (*) => save_configuration())

        ; Restore button
        restore_btn := this.gui.Add("Button", "w70 h30 x90 y" . y_pos, "Restore")
        restore_btn.OnEvent("Click", (*) => this.RestoreConfig())

        ; Clear button
        clear_btn := this.gui.Add("Button", "w70 h30 x170 y" . y_pos, "Clear All")
        clear_btn.OnEvent("Click", (*) => this.ClearAll())

        ; Close button
        close_btn := this.gui.Add("Button", "w70 h30 x355 y" . y_pos, "Close")
        close_btn.OnEvent("Click", (*) => this.gui.Hide())
    }

    OnDropdownChange(index, *) {
        group := this.controls[index]
        selected_index := group.dropdown.Value
        selected_value := this.dropdown_values[selected_index]

        if (selected_value = "add_app_path") {
            group.edit.Enabled := true
            group.browse_btn.Enabled := true
            ; Keep the current custom path if it exists
            current_value := this.function_keys_details.Get(this.text_labels[index], "")
            if (!array_has_value(this.dropdown_values, current_value)) {
                group.edit.Text := current_value
            } else {
                group.edit.Text := ""
            }
            group.edit.Focus()
        } else {
            group.edit.Enabled := false
            group.browse_btn.Enabled := false
            group.edit.Text := selected_value
        }

        this.UpdateDescription(index)
    }

    OnEditChange(index, *) {
        this.UpdateDescription(index)
    }

    OnBrowseClick(index, *) {
        group := this.controls[index]
        selected_file := choose_file()

        if (selected_file != "" && selected_file != 0) {  ; choose_file returns 0 on cancel
            group.edit.Text := selected_file
            ; Ensure dropdown is set to "Custom Program" when browsing for custom file
            group.dropdown.Choose(1)
            group.edit.Enabled := true
            group.browse_btn.Enabled := true
            this.UpdateDescription(index)
        }
    }

    UpdateDescription(index) {
        group := this.controls[index]
        selected_index := group.dropdown.Value
        selected_value := this.dropdown_values[selected_index]
        current_value := (selected_value = "add_app_path") ? group.edit.Text : selected_value
        group.desc_text.Text := get_reference_text(current_value)
    }

    RestoreConfig() {
        result := MsgBox("This will restore all Function keys assignments from the last saved configuration. `n`nAny unsaved changes will be lost. Continue?", "Restore Configuration", "YesNo Icon?")
        if (result = "Yes") {
            ; Reload configuration from file
            this.function_keys_details := get_ini_as_map(config_path, function_keys_section)

            ; Update all controls with restored values
            Loop this.controls.Length {
                index := A_Index
                group := this.controls[index]
                key := this.text_labels[index]
                restored_value := this.function_keys_details.Get(key, "")

                ; Set dropdown and edit box based on restored value
                if (array_has_value(this.dropdown_values, restored_value) && restored_value != "") {
                    ; Find the index of the value and select corresponding option
                    for i, val in this.dropdown_values {
                        if (val = restored_value) {
                            group.dropdown.Choose(i)
                            break
                        }
                    }
                    group.edit.Text := restored_value
                    group.edit.Enabled := false
                    group.browse_btn.Enabled := false
                } else {
                    group.dropdown.Choose(1) ; "Custom Program"
                    group.edit.Text := restored_value
                    group.edit.Enabled := true
                    group.browse_btn.Enabled := true
                }

                this.UpdateDescription(index)
            }

            MsgBox("Configuration restored from file successfully!", "Restore Complete", "Icon!")
        }
    }

    ClearAll() {
        Loop this.controls.Length {
            group := this.controls[A_Index]
            group.dropdown.Choose(1) ; "Custom Program"
            group.edit.Text := ""
            group.edit.Enabled := true
            group.browse_btn.Enabled := true
            this.UpdateDescription(A_Index)
        }
    }

    OnResize() {
        ; Handle window resize if needed
        ; This could be expanded to make the GUI more responsive
    }

    Show() {
        this.gui.Show()
    }

    Hide() {
        this.gui.Hide()
    }
}

; ============================================================================
; MAIN EXECUTION
; ============================================================================

; Create global reference
global g_FKeyManager := ""
global g_FKeyControls := []

; Initialize and show GUI
initialize_fkey_manager(*) {
    global g_FKeyManager
    g_FKeyManager := fkey_manager_gui()
    g_FKeyManager.Create()
    g_FKeyManager.Show()
}