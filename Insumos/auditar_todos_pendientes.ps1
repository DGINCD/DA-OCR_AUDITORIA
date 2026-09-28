$ErrorActionPreference = "Stop"

$Base = Split-Path -Parent $PSScriptRoot
$Script = "$PSScriptRoot\ocr_validar_pdf_vs_archivo.py"
$Runtime = "$Base\Cache\_runtime"
$Salida = "$Base\Salida\auditoria_equipo_consolidado.xlsx"
$Config = Get-Content -LiteralPath "$PSScriptRoot\config_auditoria.json" -Raw | ConvertFrom-Json
$PdfDir = Join-Path $Base $Config.pdf_dir
$ExcelPath = Join-Path $Base $Config.excel_file

$Python = $null
$PythonArgs = @()
$SystemPython = $null
$LocalPython = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
if (Test-Path -LiteralPath $LocalPython) {
  $SystemPython = $LocalPython
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
  $SystemPython = (Get-Command py).Source
  $SystemPythonArgs = @("-3")
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
  $SystemPython = (Get-Command python).Source
}
$VenvPython = "$Base\.venv\Scripts\python.exe"
if (Test-Path -LiteralPath $VenvPython) {
  $Python = $VenvPython
  $PythonArgs = @()
} elseif ($null -ne $SystemPython) {
  $Python = $SystemPython
  $PythonArgs = $SystemPythonArgs
} else {
  throw "No se encontro Python. Instala Python 3.12 y vuelve a ejecutar este BAT."
}

if (-not (Test-Path -LiteralPath $ExcelPath)) {
  throw "No se encontro el Excel configurado en Insumos\config_auditoria.json: $ExcelPath"
}
$ArchivoEntrada = Get-Item -LiteralPath $ExcelPath

$LimitInput = Read-Host "Cuantos PDFs pendientes queres auditar? Limit (ej: 5, 10)"
if ([string]::IsNullOrWhiteSpace($LimitInput)) { $LimitInput = "5" }
$Limit = [int]$LimitInput
$Lote = "pendientes_$(Get-Date -Format 'yyyyMMdd_HHmmss')_limit_${Limit}"

Write-Host ""
Write-Host "Auditoria general de pendientes: cantidad=$Limit"
Write-Host "Entrada: $($ArchivoEntrada.Name)"
Write-Host "Salida: $Salida"
Write-Host "Se omiten filas con Auditoria - DATOS y PDFs ya auditados en el consolidado."
Write-Host ""

New-Item -ItemType Directory -Force -Path $Runtime | Out-Null
Copy-Item -LiteralPath $ArchivoEntrada.FullName -Destination "$Runtime\archivo_equipo.xlsx" -Force

try {
  & $Python @PythonArgs $Script `
    --archivo-equipo "$Runtime\archivo_equipo.xlsx" `
    --columna-id "Origen - DNI" `
    --pdf-dir $PdfDir `
    --salida $Salida `
    --consolidar `
    --omitir-pdfs-procesados `
    --omitir-auditoria-previa `
    --columna-auditoria-previa "Auditoria - DATOS" `
    --lote $Lote `
    --cache-dir "$Base\Cache\.ocr_cache" `
    --max-pdfs $Limit `
    --dpi 400 `
    --ocr-engine rapidocr_layout_fast `
    --reintentar-ocr-profundo
}
finally {
  Remove-Item -LiteralPath "$Runtime\archivo_equipo.xlsx" -Force -ErrorAction SilentlyContinue
}
