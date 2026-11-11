@echo off
title TexEye AI - Batch Diagram Render
echo Rendering all SVG diagrams to high-resolution PNGs...
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\export_diagrams.ps1"
echo Done!
pause

