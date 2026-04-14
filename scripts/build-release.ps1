param(
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = (Get-Content -Path "$repoRoot\version.txt" -Raw).Trim()
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    throw "Version is empty. Set version.txt or pass -Version."
}

$distDir = "$repoRoot\dist"
if (-not (Test-Path $distDir)) {
    New-Item -Path $distDir -ItemType Directory | Out-Null
}

$ahk2Exe = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
if (-not (Test-Path $ahk2Exe)) {
    throw "Ahk2Exe not found at '$ahk2Exe'. Install AutoHotkey v2 first."
}

$sourceScript = "$repoRoot\WINDOWS.ahk"
$outputExe = "$distDir\WINDOWS_AHK.exe"
$iconPath = "$repoRoot\assets\windows-ahk.ico"

& $ahk2Exe /in $sourceScript /out $outputExe /icon $iconPath
if ($LASTEXITCODE -ne 0) {
    throw "Ahk2Exe failed."
}

$iscc = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $iscc)) {
    throw "Inno Setup compiler not found at '$iscc'."
}

$env:APP_VERSION = $Version
& $iscc "$repoRoot\installer\windows-ahk.iss"
if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup build failed."
}

Write-Host "Build complete for version $Version"
