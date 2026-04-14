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

$ahkCandidates = @(
    "C:\Program Files\AutoHotkey\v2\Compiler\Ahk2Exe.exe",
    "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe",
    "${env:ChocolateyInstall}\lib\autohotkey\tools\Ahk2Exe.exe",
    "${env:ChocolateyInstall}\lib\autohotkey.install\tools\Ahk2Exe.exe"
)
$ahk2Exe = $ahkCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $ahk2Exe) {
    $commandCandidate = Get-Command Ahk2Exe.exe -ErrorAction SilentlyContinue
    if ($commandCandidate) {
        $ahk2Exe = $commandCandidate.Source
    }
}
if (-not $ahk2Exe) {
    $pfCandidates = @("$env:ProgramFiles\AutoHotkey", "${env:ProgramFiles(x86)}\AutoHotkey")
    foreach ($root in $pfCandidates) {
        if (Test-Path $root) {
            $found = Get-ChildItem -Path $root -Filter Ahk2Exe.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $ahk2Exe = $found.FullName
                break
            }
        }
    }
}
if (-not $ahk2Exe) {
    throw "Ahk2Exe not found in expected locations. Install AutoHotkey v2 first."
}
Write-Host "Using Ahk2Exe: $ahk2Exe"

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
