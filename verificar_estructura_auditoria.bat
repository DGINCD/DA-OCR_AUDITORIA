@echo off
set "BASE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BASE%Insumos\verificar_estructura_auditoria.ps1"
pause
