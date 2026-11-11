@echo off
title TexEye AI - Documentation Portal Launcher
echo Starting TexEye AI Documentation Portal...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\serve_website.ps1"
pause

