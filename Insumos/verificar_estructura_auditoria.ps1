$ErrorActionPreference = "Stop"

$Base = Split-Path -Parent $PSScriptRoot
$ConfigPath = "$PSScriptRoot\config_auditoria.json"
if (-not (Test-Path -LiteralPath $ConfigPath)) {
  throw "Falta Insumos\config_auditoria.json"
}

$Config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
$PdfDir = Join-Path $Base $Config.pdf_dir
$ExcelPath = Join-Path $Base $Config.excel_file
$OutputPath = "$Base\Salida\auditoria_equipo_consolidado.xlsx"
$VenvPython = "$Base\.venv\Scripts\python.exe"

Write-Host "Verificacion de estructura de auditoria"
Write-Host "Base: $Base"
Write-Host "PDFs: $PdfDir"
Write-Host "Excel: $ExcelPath"
Write-Host "Salida: $OutputPath"
Write-Host ""

if (-not (Test-Path -LiteralPath $PdfDir -PathType Container)) {
  throw "No existe la carpeta configurada de PDFs: $PdfDir"
}
if (-not (Test-Path -LiteralPath $ExcelPath -PathType Leaf)) {
  throw "No existe el Excel configurado: $ExcelPath"
}
if (-not (Test-Path -LiteralPath "$Base\Salida" -PathType Container)) {
  throw "No existe la carpeta Salida: $Base\Salida"
}
if (-not (Test-Path -LiteralPath $VenvPython -PathType Leaf)) {
  Write-Warning "No existe .venv. Ejecuta instalar_auditoria_ocr.bat."
} else {
  Write-Host "Python virtual: OK"
}

$pdfCount = (Get-ChildItem -LiteralPath $PdfDir -File -Filter "*.pdf").Count
Write-Host "PDFs encontrados: $pdfCount"
Write-Host "Excel configurado: OK"
Write-Host "Estructura: OK"
