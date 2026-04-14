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
save_configuration(reload_after_save := false) {
    try {
        current_values := Map()
        has_changes := false

        for index, controls in g_FKeyControls {
            key := "f" . index
            selected_index := controls.dropdown.Value
            selected_value := g_FKeyManager.dropdown_values[selected_index]
            edit_value := controls.edit.Text

            ; Determine what to save based on dropdown selection
            value_to_save := (selected_value = "add_app_path") ? edit_value : selected_value
            current_values[key] := value_to_save

            existing_value := g_FKeyManager.function_keys_details.Get(key, "")
            if (value_to_save != existing_value)
                has_changes := true
        }

        if !has_changes {
            g_FKeyManager.SetStatus("No changes detected. Configuration not changed.", "0x666666")
            return true
        }

        for key, value_to_save in current_values {
            IniWrite(value_to_save, config_path, function_keys_section, key)
        }

        ; Keep in-memory state in sync so subsequent saves detect changes correctly.
        g_FKeyManager.function_keys_details := current_values

        g_FKeyManager.SetStatus("Configuration saved successfully.", "0x008000")

        if (reload_after_save)
            Reload()

        return true
    } catch Error as err {
        g_FKeyManager.SetStatus("Failed to save configuration.", "0xC00000")
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
        this.status_text := ""
    }

    Create() {
        ; Load current configuration
        this.function_keys_details := get_ini_as_map(config_path, function_keys_section)

        ; Create main GUI
        this.gui := Gui(, "Function Keys Manager - " . A_ScriptName)
        this.gui.MarginX := 8
        this.gui.MarginY := 8
        this.gui.OnEvent("Close", this.OnCloseRequested.Bind(this))
        this.gui.OnEvent("Escape", this.OnCloseRequested.Bind(this))
        this.gui.OnEvent("Size", (*) => this.OnResize())

        ; Add header
        this.gui.Add("Text", "w450 h20 x10 y8", "Function Key Assignment Manager").SetFont("s10 Bold")
        this.gui.Add("Text", "w450 h16 x10 y28", "Set what each function key should do, leave it blank for original behaviour").SetFont("s8")

        ; Create controls for each F-key
        this.CreateFKeyControls()

        ; Add action buttons
        this.CreateActionButtons()

        ; Store reference globally for save function
        global g_FKeyControls := this.controls

        return this.gui
    }

    CreateFKeyControls() {
        y_pos := 50

        Loop this.text_labels.Length {
            index := A_Index
            key := this.text_labels[index]
            current_value := this.function_keys_details.Get(key, "")

            ; Create control group for this F-key
            group := {}

            ; F-key label
            group.label := this.gui.Add("Text", "w30 h20 x10 y" . y_pos . " Center", StrUpper(key) . ":")

            ; Dropdown for action type
            group.dropdown := this.gui.Add("DropDownList", "w125 r6 x44 y" . y_pos, this.dropdown_options)
            group.dropdown.OnEvent("Change", this.OnDropdownChange.Bind(this, index))

            ; Edit box for custom path
            group.edit := this.gui.Add("Edit", "w220 h20 x174 y" . y_pos, current_value)
            group.edit.OnEvent("Change", this.OnEditChange.Bind(this, index))

            ; Browse button
            group.browse_btn := this.gui.Add("Button", "w58 h20 x399 y" . y_pos, "Browse")
            group.browse_btn.OnEvent("Click", this.OnBrowseClick.Bind(this, index))

            ; Description text
            group.desc_text := this.gui.Add("Text", "w413 h14 x44 y" . (y_pos + 18), get_reference_text(current_value))
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
            y_pos += 33
        }
    }

    CreateActionButtons() {
        y_pos := 50 + (this.text_labels.Length * 33) + 8

        ; Save button
        save_btn := this.gui.Add("Button", "w85 h26 x10 y" . y_pos, "Save")
        save_btn.OnEvent("Click", (*) => save_configuration())

        ; Save and reload button
        save_reload_btn := this.gui.Add("Button", "w110 h26 x105 y" . y_pos, "Save && Reload")
        save_reload_btn.OnEvent("Click", (*) => save_configuration(true))

        ; Restore button
        restore_btn := this.gui.Add("Button", "w70 h26 x225 y" . y_pos, "Restore")
        restore_btn.OnEvent("Click", (*) => this.RestoreConfig())

        ; Clear button
        clear_btn := this.gui.Add("Button", "w70 h26 x300 y" . y_pos, "Clear All")
        clear_btn.OnEvent("Click", (*) => this.ClearAll())

        ; Close button
        close_btn := this.gui.Add("Button", "w70 h26 x385 y" . y_pos, "Close")
        close_btn.OnEvent("Click", (*) => this.gui.Hide())

        ; Status message (for save/no-change feedback without popups)
        this.status_text := this.gui.Add("Text", "x10 y" . (y_pos + 29) . " w445 h16", "")
        this.status_text.SetFont("s8 c0x666666")
    }

    SetStatus(message, color := "0x666666") {
        this.status_text.Opt("c" . color)
        this.status_text.Text := message
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
        result := MsgBox("Are you sure you want to restore all Function keys from the last saved configuration?`n`nAny unsaved changes will be lost.", "Confirm Restore", "YesNo Icon?")
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
        result := MsgBox("Are you sure you want to clear all Function key assignments?", "Confirm Clear All", "YesNo Icon?")
        if (result != "Yes")
            return

        Loop this.controls.Length {
            group := this.controls[A_Index]
            group.dropdown.Choose(1) ; "Custom Program"
            group.edit.Text := ""
            group.edit.Enabled := true
            group.browse_btn.Enabled := true
            this.UpdateDescription(A_Index)
        }

        this.SetStatus("All assignments were cleared. Click Save to persist changes.", "0x666666")
    }

    HasUnsavedChanges() {
        for index, group in this.controls {
            key := this.text_labels[index]
            selected_index := group.dropdown.Value
            selected_value := this.dropdown_values[selected_index]
            current_value := (selected_value = "add_app_path") ? group.edit.Text : selected_value
            saved_value := this.function_keys_details.Get(key, "")
            if (current_value != saved_value)
                return true
        }
        return false
    }

    OnCloseRequested(*) {
        if this.HasUnsavedChanges() {
            result := MsgBox("You have unsaved changes. Close this window anyway?", "Unsaved Changes", "YesNo Icon?")
            if (result != "Yes")
                return
        }

        this.gui.Hide()
    }

    OnResize() {
        ; Handle window resize if needed
        ; This could be expanded to make the GUI more responsive
    }

    Show() {
        this.gui.Show("AutoSize")
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

    ; Reuse existing window if it is already created.
    if (g_FKeyManager && g_FKeyManager.gui) {
        g_FKeyManager.Show()
        try WinActivate("ahk_id " . g_FKeyManager.gui.Hwnd)
        return
    }

    g_FKeyManager := fkey_manager_gui()
    g_FKeyManager.Create()
    g_FKeyManager.Show()
}