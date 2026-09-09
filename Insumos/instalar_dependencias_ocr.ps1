$ErrorActionPreference = "Stop"

$Project = $PSScriptRoot
$Requirements = "$Project\requirements_ocr_auditoria.txt"
$Base = Split-Path -Parent $PSScriptRoot
$Venv = "$Base\.venv"
$VenvPython = "$Venv\Scripts\python.exe"

$LocalPython = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
if (Test-Path -LiteralPath $LocalPython) {
  $Python = $LocalPython
  $PythonArgs = @()
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
  $Python = (Get-Command py).Source
  $PythonArgs = @("-3")
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
  $Python = (Get-Command python).Source
  $PythonArgs = @()
} else {
  throw "No se encontro Python 3.12. Instala Python y vuelve a ejecutar este script."
}

if (-not (Test-Path -LiteralPath $VenvPython)) {
  Write-Host "Creando entorno virtual: $Venv"
  & $Python @PythonArgs -m venv $Venv
}
if (-not (Test-Path -LiteralPath $VenvPython)) {
  throw "No se pudo crear el entorno virtual en $Venv"
}

& $VenvPython -m pip install --upgrade pip
& $VenvPython -m pip install -r $Requirements
& $VenvPython -m pip install --force-reinstall "onnxruntime==1.22.1" "numpy==2.3.5"

& $VenvPython -c "import sys, numpy, onnxruntime; import pandas, openpyxl, fitz, cv2; from rapidocr_onnxruntime import RapidOCR; print(sys.executable); print('numpy', numpy.__version__); print('onnxruntime', onnxruntime.__version__); print('Dependencias OCR OK')"
