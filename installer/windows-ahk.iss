#define AppName "WINDOWS-AHK"
#define AppPublisher "Bibek Aryal"
#define AppURL "https://github.com/arlbibek/windows-ahk"
#define AppVersion GetEnv("APP_VERSION")
#if AppVersion == ""
  #define AppVersion "0.0.0"
#endif
#define AppExeName "WINDOWS_AHK.exe"

[Setup]
AppId={{8F4B64A7-2C06-4E76-A4AB-F2A318F9AC5F}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={localappdata}\windows-ahk
DefaultGroupName={#AppName}
OutputBaseFilename=windows-ahk-setup-{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#AppExeName}
ArchitecturesInstallIn64BitMode=x64compatible

[Tasks]
Name: "startupshortcut"; Description: "Run at startup for current user"; GroupDescription: "Additional shortcuts:"

[Files]
Source: "..\dist\WINDOWS_AHK.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\assets\windows-ahk.ico"; DestDir: "{app}\assets"; Flags: ignoreversion
Source: "..\assets\windows-ahk.png"; DestDir: "{app}\assets"; Flags: ignoreversion
Source: "..\assets\keyboardshortcuts.pdf"; DestDir: "{app}\assets"; Flags: ignoreversion
Source: "..\version.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{userstartup}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: startupshortcut

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
