# AHK for Windows

A simple and useful AutoHotKey script for Windows.

> ## AutoHotKey
>
> AutoHotkey is a free and open-source custom scripting language for Microsoft Windows, initially aimed at providing easy keyboard shortcuts or hotkeys, fast macro-creation, and software automation that allows users of most levels of computer skill to automate repetitive tasks in any Windows application.
>
> - Homepage: [autohotkey.com](https://www.autohotkey.com "Go to autohotkey homepage")
> - Downloading page: [/download](https://www.autohotkey.com/download "Go to autohotkey download page")
> - Direct download: [/ahk-install.exe](https://www.autohotkey.com/download/ahk-install.exe "Directly download autohotkey")

**It is important to note that all the pre-existing hotkeys/shortcuts will be overridden.**

```text
+------------------------------------------+
| CAUTION!                                 |
| These scripts tend to be very addictive. |
+------------------------------------------+
```

## Usages

### Option 1

[ *Recommend* ]

1. Download and Run the `WINDOWS_AHK.exe` from one of the [releases](https://github.com/arlbibek/windows-ahk.git "Visit releases page").
2. Done! _You shall now see the `WINDOWS_AHK.exe` file running on the system tray._

### Option 2

[ _If you have trust issues with .exe(s) and/or want to make some changes_ ]

1. First, Download and Install AutoHotKey [ *from one of the links above* ].
2. Then, Download and Run the `WINDOWS.ahk` file from one of the [releases](https://github.com/arlbibek/windows-ahk.git "Visit releases page") (or you may clone the repo).
3. Done! _You shall now see the `WINDOWS_AHK.ahk` file running on the system tray._

> **To automatically start the script when you log on to the computer.**
>
> Simply, Create a shortcut of (or place) the exe/ahk on the startup folder (i.e. `C:\Users\<USERNAME>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`)

---

## Keyboard Shortcuts

- _Anything with this_ (🤵) _emoji is a custom/specific shortcut that might not work or suit your needs._

### Hotkey

aka **shortcut keys** - easily trigger an action (such as launching a program or keyboard macro)
[[See documentation](https://www.autohotkey.com/docs/Hotkeys.htm "See hotkey documentation")].

#### Global

| Key                                              | Action                                   |
| ------------------------------------------------ | ---------------------------------------- |
| <kbd>F1</kbd>                                    | Open/Switch/Cycle through Firefox        |
| <kbd>Alt</kbd> + <kbd>F1</kbd>                   | Open Firefox (new window)                |
| <kbd>Alt</kbd> + <kbd>F2</kbd>                   | Open/Switch/Cycle through VS Code        |
| <kbd>Alt</kbd> + <kbd>F3</kbd>                   | Open/Switch/Close Spotify                |
| <kbd>Win</kbd> + <kbd>E</kbd>                    | Open/Switch/Cycle through File Explorer  |
| <kbd>Win</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd> | Open File Explorer (new window)          |
| <kbd>Win</kbd> + <kbd>N</kbd>                    | Open/Switch/Cycle through Notepad        |
| <kbd>Win</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> | Open Notepad (new window)                |
| <kbd>Win</kbd> + <kbd>S</kbd>                    | Search selected text via default browser |

#### File Explorer

| Key                                                | Action                                                                                                                                    |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| <kbd>Win</kbd> + <kbd>E</kbd>                      | Cycle through all the active File Explorers                                                                                               |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>U</kbd>  | Navigate to User directory 👤                                                                                                             |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd>  | Navigate to This Pc 💻                                                                                                                    |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>  | Navigate to the Desktop (H for Home 😅)                                                                                                   |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>  | Navigate to the Documents directory 📄                                                                                                    |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>J</kbd>  | Navigate to the Downloads directory 📥                                                                                                    |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd>  | Navigate to the Music directory 🎵                                                                                                        |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>  | Navigate to the Pictures directory 🖼                                                                                                      |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd>  | Navigate to the Videos directory 📼                                                                                                       |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd>  | Navigate to `C:\` 💾                                                                                                                      |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>  | Navigate to arlbibek directory 🤵                                                                                                         |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>  | Navigate to Screenshot directory 🤵                                                                                                       |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd>  | Open Windows Terminal in Current Working Directory                                                                                        |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>\\</kbd> | Open VS Code in Current Working Directory (_uses context menu_); <br/> _And if a file/folder is selected this will create it's shortcut;_ |

> _This works for all the Explorer-based "save" and "load" boxes as well!_

#### Terminal Groups

`WindowsTerminal` `PowerShell` `Command Prompt` `Debian (wsl)` `Kali (wsl)` `Ubuntu (wsl)`

| Keyboard Shortcuts                                 | Action                                                      |
| -------------------------------------------------- | ----------------------------------------------------------- |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>\\</kbd> | Open VS Code in Current Working Directory (_uses `code .`_) |

> **Note:** _For those hotkeys that throw an error saying `Error. Failed attempt to launch program or document:` ... `Specifically: The system cannot find the file specified.`, please consider adding the respective program (folder) to the [path of your system variables](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/ "See: Add to the PATH on Windows 10")._

### Hotstring

**What is a hotstring?**

Hotstrings are mainly used to expand abbreviations as you type them (auto-replace), they can also be used to launch any scripted action [[ahk]](https://www.autohotkey.com/docs/Hotstrings.htm "See hotstring documentation").

```ahk
; For example:
::wtf::Wow that's fantastic
```

#### Date and time

Assuming today's date and time is `Sunday, October 10, 2021, 02:55 PM`

| Abbreviation  | Phrase                            |
| ------------- | --------------------------------- |
| `/datetime`   | Sunday, October 10, 2021, 14:55   |
| `/datetimett` | Sunday, October 10, 2021 02:55 PM |
| `/time`       | 14:55                             |
| `/timett`     | 02:55 PM                          |
| `/date`       | October 10, 2021                  |
| `/daten`      | 10/10/2021                        |
| `/today`      | Sunday                            |
| `/day`        | 10                                |
| `/month`      | October                           |
| `/monthn`     | 10                                |
| `/year`       | 2021                              |

#### Others

| Abbreviation | Phrase                                                                     |
| ------------ | -------------------------------------------------------------------------- |
| `/gm`        | Good morning                                                               |
| `/ge`        | Good evening                                                               |
| `/gn`        | Good night                                                                 |
| `/ty`        | Thank you                                                                  |
| `/tyvm`      | Thank you very much                                                        |
| `/wc`        | Welcome                                                                    |
| `/mp`        | My pleasure                                                                |
| `/lorem`     | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod... |
| **Misc**     | 🤵                                                                         |
| `/svkm`      | \|को हार्दिक मंगलमय शुभकामना!                                              |
| `/jdksvkm`   | जन्मदिनको धेरै धेरै शुभकामना `NAME\|` ।                                    |
| `/party?`    | पार्टी कहीले? 🥳                                                           |

---

That is all.

Best,

[Bibek Aryal](https://arlbibek.github.io/)
