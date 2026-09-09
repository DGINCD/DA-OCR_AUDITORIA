@echo off
set "BASE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BASE%Insumos\instalar_dependencias_ocr.ps1"
pause
