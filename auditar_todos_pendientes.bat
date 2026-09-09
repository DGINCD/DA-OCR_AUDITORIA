@echo off
set "BASE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BASE%auditar_todos_pendientes.ps1"
pause
