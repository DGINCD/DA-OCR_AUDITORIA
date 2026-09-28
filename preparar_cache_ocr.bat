@echo off
set "BASE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BASE%Insumos\preparar_cache_ocr.ps1"
pause
