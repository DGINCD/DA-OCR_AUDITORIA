@echo off
set "BASE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BASE%Insumos\auditar_todos_pendientes.ps1"
pause
