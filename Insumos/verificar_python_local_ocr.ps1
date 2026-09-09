$ErrorActionPreference = "Stop"

$Base = Split-Path -Parent $PSScriptRoot
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

& $Python @PythonArgs -c "import sys, numpy, onnxruntime; import pandas, openpyxl, fitz, cv2; from rapidocr_onnxruntime import RapidOCR; print(sys.executable); print('numpy', numpy.__version__); print('onnxruntime', onnxruntime.__version__); print('Dependencias OCR OK')"
