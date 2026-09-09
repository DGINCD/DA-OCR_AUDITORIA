$ErrorActionPreference = "Stop"

$Base = Split-Path -Parent $PSScriptRoot
$Script = "$PSScriptRoot\ocr_validar_pdf_vs_archivo.py"
$CacheDir = "$Base\Cache\.ocr_cache"
$Config = Get-Content -LiteralPath "$PSScriptRoot\config_auditoria.json" -Raw | ConvertFrom-Json
$PdfDir = Join-Path $Base $Config.pdf_dir

$SystemPython = $null
$LocalPython = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
if (Test-Path -LiteralPath $LocalPython) {
  $SystemPython = $LocalPython
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
  $SystemPython = (Get-Command py).Source
  $SystemPythonArgs = @("-3")
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
  $SystemPython = (Get-Command python).Source
  $SystemPythonArgs = @()
}
$VenvPython = "$Base\.venv\Scripts\python.exe"
if (Test-Path -LiteralPath $VenvPython) {
  $Python = $VenvPython
  $PythonArgs = @()
} elseif ($null -ne $SystemPython) {
  $Python = $SystemPython
  $PythonArgs = $SystemPythonArgs
} else {
  throw "No se encontro Python 3.12. Instala Python y vuelve a ejecutar este script."
}

$LimitInput = Read-Host "Cuantos OCR nuevos queres precargar? Enter = todos los pendientes"
$ArgsLimit = @()
if (-not [string]::IsNullOrWhiteSpace($LimitInput)) {
  $Limit = [int]$LimitInput
  $ArgsLimit = @("--max-pdfs", "$Limit")
}

Write-Host ""
Write-Host "Precarga OCR"
Write-Host "PDFs: $PdfDir"
Write-Host "Cache: $CacheDir"
Write-Host "Base local: $CacheDir\ocr_cache.sqlite"
if ($ArgsLimit.Count -gt 0) {
  Write-Host "OCR nuevos a generar: $Limit"
} else {
  Write-Host "OCR nuevos a generar: todos los pendientes"
}
Write-Host ""

& $Python @PythonArgs $Script `
  --pdf-dir $PdfDir `
  --cache-dir $CacheDir `
  --solo-cache-ocr `
  @ArgsLimit `
  --dpi 400 `
  --ocr-engine rapidocr_layout_fast
