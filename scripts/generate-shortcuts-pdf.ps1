param(
    [string]$MarkdownFile = "keyboardshortcuts.md",
    [string]$OutputPdf = "assets/keyboardshortcuts.pdf"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$mdPath = Join-Path $repoRoot $MarkdownFile
$pdfOutputPath = Join-Path $repoRoot $OutputPdf
$tempPdfPath = [System.IO.Path]::ChangeExtension($mdPath, ".pdf")

if (-not (Test-Path $mdPath)) {
    throw "Markdown file not found: $mdPath"
}

$outDir = Split-Path -Parent $pdfOutputPath
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

Write-Host "Generating PDF from: $mdPath"
npx --yes md-to-pdf $mdPath
if ($LASTEXITCODE -ne 0) {
    throw "md-to-pdf failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path $tempPdfPath)) {
    throw "Generated PDF not found at expected path: $tempPdfPath"
}

Move-Item -Path $tempPdfPath -Destination $pdfOutputPath -Force
Write-Host "Updated PDF: $pdfOutputPath"
