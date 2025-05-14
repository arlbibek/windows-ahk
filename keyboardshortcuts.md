# Keyboard shortcuts for WINDOWS-AHK

<table style="border-collapse: collapse; width: 100%;">
  <tr>
    <td style="padding: 1; vertical-align: middle; text-align: center;">
      <img src="https://raw.githubusercontent.com/arlbibek/windows-ahk/master/assets/windows-ahk.png" width="250" alt="Windows-AHK Logo" />
    </td>
    <td style="vertical-align: top;">
      <p>This document lists keyboard shortcuts for <a href="https://github.com/arlbibek/windows-ahk">arlbibek/windows-ahk</a>, a simple and intuitive AutoHotKey script to enhance your Windows workflow.</p>
      <p>For setup instructions, refer to the <a href="https://github.com/arlbibek/windows-ahk#readme">README.md</a> on GitHub.</p>
      <p>Made with ❤️ by <a href="https://bibeka.com.np/">Bibek Aryal</a>.</p>
    </td>
  </tr>
</table>

---

## Tray menu options

Right-click the windows-ahk tray icon to access the following options:

| Option                   | Action                                                                                              | Hotkey                                                              |
| ------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| Run at startup           | Enable or disable script to run automatically at login                                              |                                                                     |
| Start menu shortcut      | Show or hide the script from the Start menu                                                         |                                                                     |
| Presentation mode        | Toggle Windows Presentation Mode on/off                                                             | <kbd>Win</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>                    |
| Keyboard shortcuts       | View keyboard shortcuts, opens (this) shortcut documentation as a PDF                               | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>\\</kbd> |
| Open file location       | Opens the script directory                                                                          |                                                                     |
| View in GitHub           | View source code in GitHub repository                                                               |                                                                     |
| AutoHotKey documentation | Opens the official AutoHotKey v2 documentation                                                      |                                                                     |
| Suspend hotkeys          | Disables (suspends) hotkeys and hotstrings, while the script itself keeps running in the background | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd>  |
| Reload script            | Reloads the script (use after changes)                                                              | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd>  |
| Exit                     | Exits the script                                                                                    | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>E</kbd>  |

---

## Hotkeys

Also known as **shortcut keys** - easily trigger an action (such as launching a program or keyboard macro).

### Function keys actions

> **Note:** You can customize these actions by editing the configuration file at `%appdata%/windows-ahk/config.ini`, under the `[FUNCTION_KEYS]` section.
>
> > To do so, right-click the tray icon → **Launch configuration window**, Click **Open configuration file**, then edit as needed, Save changes and reload the script

| Function Key                      | Value                                                       | Action                                        |
| --------------------------------- | ----------------------------------------------------------- | --------------------------------------------- |
| <kbd>F1</kbd>                     | `default_browser`                                           | Launch or switch to the default browser       |
| <kbd>F2</kbd>                     | _(Unassigned — customize as needed)_                        |                                               |
| <kbd>F3</kbd>                     | `switch_tabs`                                               | Switch between two most recent active windows |
| <kbd>F4</kbd>                     | `notepad.exe`                                               | Launch or cycle through Notepad windows       |
| <kbd>F5</kbd> ... <kbd>F9</kbd>   | _(Unassigned — customize as needed)_                        |                                               |
| <kbd>F10</kbd>                    | `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` | Launch or switch to PowerShell window(s)      |
| <kbd>F11</kbd> ... <kbd>F12</kbd> | _(Unassigned — customize as needed)_                        |                                               |

> 🔧 You can use either one of the **available options** below or an **app path** _- must be a full path or accessible via the system_ [_PATH_](<https://en.wikipedia.org/wiki/PATH_(variable)>).
>
> #### Available options
>
> | Option            | Description                                                                                                                                               |
> | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
> | `default_browser` | Launch the default browser or cycle through its windows                                                                                                   |
> | `all_browsers`    | Launch default browser of cycle through all active browser windows <br/>(includes: firefox, duckduckgo, chrome, arc, brave, msedge, opera, iexplore, zen) |
> | `browser_tabs`    | Launch the default browser or cycle through active browser tabs                                                                                           |
> | `switch_window`   | Switch between two most recent active windows (sends {Alt} + {Tab})                                                                                       |
> | `switch_tabs`     | Switch between two most recent active tab in a active window (sends {Ctrl} + {Tab})                                                                       |
>
> 🔍 See screenshot of example configuration [here](https://raw.githubusercontent.com/arlbibek/windows-ahk/master/assets/config_example.png).

### Global hotkeys

| Hotkey                             | Action                                                                                                               |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| <kbd>Win</kbd> + <kbd>E</kbd>      | Open or switch to File Explorer (Use <kbd>Shift</kbd> to open new window)                                            |
| <kbd>Win</kbd> + <kbd>N</kbd>      | Open or switch to Notepad (Use <kbd>Shift</kbd> for new window)                                                      |
| <kbd>Win</kbd> + <kbd>S</kbd>      | Search selected text using the active or default browser                                                             |
| <kbd>CapsLock</kbd> + <kbd>7</kbd> | Transform selected text to lower case (e.g., `Hello, Word!` to `hello, word!`)                                       |
| <kbd>CapsLock</kbd> + <kbd>8</kbd> | Transform selected text to title case (e.g., `hello, word!` to `Hello, Word!`)                                       |
| <kbd>CapsLock</kbd> + <kbd>9</kbd> | Transform selected text to upper case (e.g., `Hello, Word!` to `HELLO, WORD!`)                                       |
| <kbd>Esc</kbd> ×3                  | Press <kbd>Esc</kbd> three times to close the active window (if the active window is a browser close the active tab) |

### File explorer hotkeys

| Hotkey                                             | Action                               |
| -------------------------------------------------- | ------------------------------------ |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>U</kbd>  | Go to **User** folder 👤             |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd>  | Go to **This PC** 💻                 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>  | Go to **Desktop** 🏠                 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>  | Go to **Documents** 📄               |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>J</kbd>  | Go to **Downloads** 📥               |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd>  | Go to **Music** 🎵                   |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>  | Go to **Pictures** 🖼                 |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd>  | Go to **Videos** 📼                  |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd>  | Open PowerShell in current directory |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>\\</kbd> | Open current directory in VS Code    |

---

### Hotstring

Hotstrings are mainly used to expand abbreviations as you type them (auto-replace), they can also be used to launch any scripted action.

```ahk
; for example
::wtf::Wow that's fantastic
```

| Abbreviation         | Expands To                                         |
| -------------------- | -------------------------------------------------- |
| `/paste`             | _(Pastes clipboard content)_                       |
| `/datetime` or `/dt` | Tuesday, May 13, 2025, 17:38                       |
| `/date`              | May 13, 2025                                       |
| `/time`              | 17:38                                              |
| `/dear`              | (_Time-based email greeting with polite template_) |

#### Customizable hotstrings

> **Note**: You can edit or add custom Hotstrings under the `[HOTSTRINGS]` section in the config file, using the format: `shortcut=your text here`
>
> > To do so, right-click tray icon → **Launch configuration window**, Click **Edit configuration file**, Save and **reload** the script

| Abbreviation | Phrase                                      |
| ------------ | ------------------------------------------- |
| `wtf`        | Wow that's fantastic                        |
| `gm`         | Good morning                                |
| `ge`         | Good evening                                |
| `gn`         | Good night                                  |
| `ty`         | Thank you very much                         |
| `wc`         | Welcome                                     |
| `mp`         | My pleasure                                 |
| `omg`        | Oh my god                                   |
| `pfa`        | Please find the attachment.                 |
| `/lorem`     | _(Lorem Ipsum text)_                        |
| `/plankton`  | _(Plankton description)_                    |
| `/mail`      | <you@example.com> (update your email here)  |
| `/ph`        | 98XXXXXXXX (update your phone number here)  |
| `/addr`      | Kathmandu, Nepal (update your address here) |

💡To restore default configuration, right-click the tray icon → **Launch configuration window** → **Restore default configuration**

---

> Last updated: May 14, 2025
