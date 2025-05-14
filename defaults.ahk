load_default_config(filepath) {
    ; Ensure the directory exists
    SplitPath(filepath, &filename, &filedir)  ; Extract directory from filepath

    if !DirExist(filedir) {
        DirCreate(filedir)
    }

    ; Backup existing file if it exists
    if FileExist(filepath) {
        backup_path := filedir . "\" . A_Now . " - " filename
        msg := MsgBox("The configuration file already exists. A backup will be created before overwriting it.", "Configuration File Exists", 0x1)
        if (msg == "OK") {
            FileCopy(filepath, backup_path, true)
            if !FileExist(backup_path) {
                TrayTip("Failed to create a backup of the existing configuration file.", "Default configuration restored", 0x4)
            }
        } else {
            TrayTip("Default configuration will not be restored", "Default configuration not restored", 0x4)
            return
        }
    }

    ; Build the configuration content
    config_content := "
        (LTrim
        ; == WINDOWS-AHK ==
        ; This file provides configurations for the windows-ahk script. 
        ; For more info visit official GitHub page at https://github.com/arlbibek/windows-ahk/  
        ; Made with ❤️ by Bibek Aryal. 

        ; WINDOWS_AHK CONFIGURATION >> 
        
        [WINDOWS_AHK]
        first_launch=true

        ; FUNCTION KEYS CONFIGURATION >>
        ; Configure actions for function keys (e.g., F1, F2, ...)
        ; Options for function key:
        ;   default_browser      # Launch / cycle through / minimize the default browser window(s) e.g. f1=default_browser
        ;   all_browsers         # Launch default browser / cycle through all active browser window(s)
        ;   browser_tabs         # Launch default/active browser window / cycle through active browser tabs
        ;   switch_window        # Switch between two most recent active windows (sends {ALT} + {TAB}) 
        ;   switch_tabs          # Switch between multiple tabs in the same window (sends {CTRL} + {TAB}) e.g. f3=switch_tabs
        ;   <ADD_APP_PATH_HERE>  # Set the app path to launch, switch to, cycle through, or minimize the app. 
        ;                          The path must be a full path or accessible via the system PATH.
        ;                          e.g., f4=notepad.exe or f10=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe


        [FUNCTION_KEYS]
        f1=default_browser
        f2=
        f3=switch_tabs
        f4=notepad.exe
        f5=
        f6=
        f7=
        f8=
        f9=
        f10=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
        f11=
        f12=

        ; HOTSTRINGS CONFIGURATION >>
        ; This section lets you create shortcuts for longer text.
        ; Just use the format: shortcut=text you want to insert
        ; Example: gm=Good morning → typing "gm" will expand to "Good morning"
        ; You can add, edit, or delete hotstrings as needed in the following section.

        [HOTSTRINGS]
        wtf=Wow thats fantastic
        gm=Good morning
        ge=Good evening
        gn=Good night
        ty=Thank you very much
        wc=Welcome
        mp=My pleasure
        omg=Oh my god
        pfa=Please find the attachment.
        /lorem=Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        /plankton=Plankton are the diverse collection of organisms found in water that are unable to propel themselves against a current. The individual organisms constituting plankton are called plankters. In the ocean, they provide a crucial source of food to many small and large aquatic organisms, such as bivalves, fish and whales.
        /mail=you@example.com (update your email here)
        /ph=98XXXXXXXX (update your phone number here)
        /addr=Kathmandu, Nepal (update your address here)
        ; you may add more hotstrings below using the same format: shortcut=your text here

        ; WELL WISHES LIST >>
        ; These messages are used when you type the '/dear' hotstring.
        ; Each line follows the format: key=your message
        ; You can name the key anything (like g01, g02, etc.) - the key name doesn't affect how it works.
        ; Feel free to add, change, or remove messages as you like.
            
        [WELL_WISHES]
        g01=Have a delightful day ahead!
        g02=Wishing you a wonderful day.
        g03=May your day be filled with joy.
        g04=Have an amazing day.
        g05=Hope you have a fantastic day!
        g06=Wishing you a great day ahead.
        g07=Enjoy your day to the fullest.
        g08=Wishing you a day full of positivity and success.
        g09=Hope today brings you closer to your goals.
        g10=Wishing you a day filled with pleasant surprises.
        g11=Have a productive and cheerful day!
        g12=May your day be full of accomplishments and smiles.
        g13=May your day be filled with inspiration and success.
        g14=Hope today is the start of something amazing for you.
        g15=Wishing you a stress-free and joyful day!
        g16=Have a peaceful and fulfilling day ahead.
        g17=May your day be as bright as your smile.
        g18=May today reward your efforts and dedication.
        g19=Let today be the beginning of something new and exciting.
        g20=Hope your day brings you peace and purpose.
        g21=Wishing you calm moments and energizing breakthroughs.
        g22=Hope today fills you with confidence and joy.
        g23=Let your passion lead the way today.
        g24=May today be kind, successful, and full of good surprises.
        )"

    ; Overwrite the file with new content
    file := FileOpen(filepath, "w")
    if (file) {
        file.Write(config_content)
        file.Close()
        TrayTip("Configuration restored with default settings. Reload the script to apply changes.", "Default configuration restored", 0x01)
    } else {
        MsgBox("Failed to open the config file for writing: " . filepath)
    }
}