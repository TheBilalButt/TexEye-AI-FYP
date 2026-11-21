# ==============================================================================
# build_meeting_suite.ps1
# Generates all diagrams requested by the user for the supervisor meeting:
#  1. Rough Workflow Diagram (Paper-friendly handwritten style blueprint)
#  2. Module-Wise Use Cases Diagram (All 5 Modules with explicit mappings)
#  3. Sequence Diagram for Module 1 (AI Defect Detection & Location)
#  4. Sequence Diagram for Module 2 (Hardware & Inspection Monitoring)
#  5. Sequence Diagram for Module 3 (Mobile Floor Application)
#  6. Sequence Diagram for Module 4 (Web Quality Management & Digital Fabric Map)
#  7. Sequence Diagram for Module 5 (Smart Operations Module & ASTM 4-Point Grading)
#  8. Comprehensive UML Class Diagram (Domain Model with 1-to-1 and 1-to-many relationships)
# ==============================================================================

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$modulesDir = Join-Path $projectRoot "diagrams\modules"
$pdfDir = Join-Path $modulesDir "pdf"
$pngDir = Join-Path $modulesDir "png"
$docsDir = Join-Path $projectRoot "docs"

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) { $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }

function Compile-ModuleDiagram {
    param(
        [string]$Name,
        [string]$SvgContent,
        [string]$Title,
        [string]$Subtitle,
        [string]$ExplanationHtml,
        [int]$Width = 1400,
        [int]$Height = 920
    )

    $svgPath = Join-Path $modulesDir "$Name.svg"
    [IO.File]::WriteAllText($svgPath, $SvgContent, [Text.Encoding]::UTF8)

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>$Title | TexEye AI</title>
  <style>
    @page { size: A4 landscape; margin: 6mm; }
    * { box-sizing: border-box; }
    body { margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; background: #ffffff; color: #0f172a; }
    .page-container { width: 100%; max-width: 1320px; margin: 0 auto; padding: 10px 14px; }
    .header-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0284c7; padding-bottom: 6px; margin-bottom: 8px; }
    .header-title h1 { margin: 0; font-size: 15pt; font-weight: 800; color: #0f172a; }
    .header-title p { margin: 2px 0 0 0; font-size: 8.5pt; color: #475569; }
    .header-badge { text-align: right; font-size: 8pt; color: #64748b; line-height: 1.3; }
    .header-badge strong { color: #0284c7; }
    .svg-wrapper { width: 100%; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 6px; padding: 4px; }
    .svg-wrapper svg { width: 100%; height: auto; display: block; }
    .explanation-box { margin-top: 8px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px 12px; font-size: 8pt; line-height: 1.4; }
    .explanation-box h3 { margin: 0 0 4px 0; font-size: 9.5pt; color: #0f172a; display: flex; align-items: center; gap: 6px; }
    .explanation-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 4px; }
    .exp-col { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 4px; padding: 6px 8px; }
    .exp-col strong { color: #0369a1; display: block; margin-bottom: 2px; font-size: 8pt; }
  </style>
</head>
<body>
  <div class="page-container">
    <div class="header-bar">
      <div class="header-title">
        <h1>$Title</h1>
        <p>$Subtitle</p>
      </div>
      <div class="header-badge">
        <strong>TexEye AI</strong> &bull; Supervisor Meeting Blueprint Series<br>
        COMSATS University Islamabad, Wah Campus<br>
        Supervisor: Dr. Tassawar Iqbal
      </div>
    </div>
    <div class="svg-wrapper">
      $SvgContent
    </div>
    $ExplanationHtml
  </div>
</body>
</html>
"@

    $htmlPath = Join-Path $modulesDir "$Name.html"
    [IO.File]::WriteAllText($htmlPath, $html, [Text.Encoding]::UTF8)

    $pdfPath = Join-Path $pdfDir "$Name.pdf"
    $pngPath = Join-Path $pngDir "$Name.png"

    Write-Host "Compiling $Name PDF and PNG..." -ForegroundColor Cyan

    $procPdf = Start-Process -FilePath $edgeExe -ArgumentList @(
        "--headless", "--disable-gpu", "--run-all-compositor-stages-before-draw",
        "--no-pdf-header-footer", "--print-to-pdf=$pdfPath",
        "file:///$($htmlPath.Replace('\', '/'))"
    ) -Wait -PassThru -NoNewWindow

    $procPng = Start-Process -FilePath $edgeExe -ArgumentList @(
        "--headless", "--disable-gpu", "--run-all-compositor-stages-before-draw",
        "--window-size=$Width,$Height", "--screenshot=$pngPath",
        "file:///$($htmlPath.Replace('\', '/'))"
    ) -Wait -PassThru -NoNewWindow

    Write-Host "$Name compiled: PDF=$((Get-Item $pdfPath).Length) bytes, PNG=$((Get-Item $pngPath).Length) bytes" -ForegroundColor Green
}

Write-Host "Helper initialized." -ForegroundColor Green
