# Master compilation script for TexEye AI SRDS PDF (COMSATS Wah Standard)
$ErrorActionPreference = "Stop"

Write-Output "=== Starting TexEye AI SRDS Compilation ==="

# Helper function
function New-Page {
    param(
        [int]$PageNumber,
        [string]$Content,
        [bool]$IsCover = $false
    )
    
    $headerHtml = if (-not $IsCover) {
        @"
        <div class="page-header">
          <span>Software Requirement and Design Specification for TexEye AI</span>
          <span>Page $PageNumber</span>
        </div>
"@
    } else { "" }

    return @"
  <div class="page">
    <div class="page-frame">
      <div class="page-inner-frame">
$headerHtml
        <div class="page-content">
$Content
        </div>
      </div>
    </div>
  </div>
"@
}

# Load page generators
. "C:\Users\User\Desktop\FYP\docs\gen_pages_1_10.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_pages_11_20.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_pages_21_36.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_pages_37_50.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_pages_51_62.ps1"

# HTML Shell Header
$htmlShell = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Software Requirement and Design Specification for TexEye AI</title>
<style>
  @page {
    size: A4 portrait;
    margin: 0;
  }
  @media print {
    body {
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }
  }
  * {
    box-sizing: border-box;
  }
  body {
    margin: 0;
    padding: 0;
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    color: #000000;
    background-color: #ffffff;
    font-size: 8.8pt;
    line-height: 1.4;
  }
  .page {
    width: 210mm;
    height: 297mm;
    padding: 12mm 15mm;
    page-break-after: always;
    break-after: page;
    position: relative;
    background: #ffffff;
    overflow: hidden;
  }
  .page-frame {
    width: 100%;
    height: 100%;
    border: 1.5pt solid #000000;
    padding: 2.5mm;
  }
  .page-inner-frame {
    width: 100%;
    height: 100%;
    border: 0.8pt solid #000000;
    padding: 6mm 8mm;
    position: relative;
    display: flex;
    flex-direction: column;
  }
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 9pt;
    font-style: italic;
    border-bottom: 1pt solid #000000;
    padding-bottom: 1.5mm;
    margin-bottom: 2.8mm;
    flex-shrink: 0;
  }
  .page-content {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }
  .chapter-bar {
    background-color: #2d3748;
    color: #ffffff;
    font-size: 13pt;
    font-weight: bold;
    padding: 4px 10px;
    margin-bottom: 2.8mm;
    flex-shrink: 0;
  }
  h2.sec-heading {
    font-size: 10.5pt;
    font-weight: bold;
    margin: 1.8mm 0 1mm 0;
  }
  h3.subsec-heading {
    font-size: 9.5pt;
    font-weight: bold;
    margin: 1.4mm 0 0.8mm 0;
  }
  p {
    margin: 0 0 1.6mm 0;
    text-align: justify;
  }
  ul, ol {
    margin: 0 0 1.6mm 0;
    padding-left: 5mm;
  }
  li {
    margin-bottom: 0.8mm;
    text-align: justify;
  }
  table.formal-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 7.5pt;
    margin: 1mm 0 1.8mm 0;
  }
  table.formal-table th {
    background-color: #e2e8f0;
    border: 1px solid #718096;
    padding: 2.8px 4.5px;
    font-weight: bold;
    text-align: left;
  }
  table.formal-table td {
    border: 1px solid #a0aec0;
    padding: 2px 4.5px;
    vertical-align: top;
  }
  .toc-line {
    display: flex;
    justify-content: space-between;
    margin-bottom: 1.1mm;
    font-size: 8.8pt;
  }
  .toc-dots {
    flex-grow: 1;
    border-bottom: 1px dotted #4a5568;
    margin: 0 4px 3px 4px;
  }
  .diagram-container {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .diagram-img {
    max-width: 100%;
    max-height: 215mm;
    object-fit: contain;
  }
  .caption {
    font-weight: bold;
    font-size: 9.5pt;
    text-align: center;
    margin-top: 2mm;
    flex-shrink: 0;
  }
  pre.code-block {
    background-color: #f8fafc;
    border: 1px solid #cbd5e1;
    padding: 3px 6px;
    font-family: Consolas, "Courier New", monospace;
    font-size: 7pt;
    line-height: 1.3;
    margin: 0.8mm 0 1.5mm 0;
    white-space: pre-wrap;
    word-break: break-word;
  }
</style>
</head>
<body>
"@

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine($htmlShell)

# Helper function
function New-Page {
    param(
        [int]$PageNumber,
        [string]$Content,
        [bool]$IsCover = $false
    )
    
    $headerHtml = if (-not $IsCover) {
        @"
        <div class="page-header">
          <span>Software Requirement and Design Specification for TexEye AI</span>
          <span>Page $PageNumber</span>
        </div>
"@
    } else { "" }

    return @"
  <div class="page">
    <div class="page-frame">
      <div class="page-inner-frame">
$headerHtml
        <div class="page-content">
$Content
        </div>
      </div>
    </div>
  </div>
"@
}

# Collect all 62 pages
Write-Output "Generating Pages 1 to 10..."
$p1_10 = Get-Pages-1-to-10
foreach ($p in $p1_10) { [void]$sb.AppendLine($p) }

Write-Output "Generating Pages 11 to 20..."
$p11_20 = Get-Pages-11-to-20
foreach ($p in $p11_20) { [void]$sb.AppendLine($p) }

Write-Output "Generating Pages 21 to 36..."
$p21_36 = Get-Pages-21-to-36
foreach ($p in $p21_36) { [void]$sb.AppendLine($p) }

Write-Output "Generating Pages 37 to 50..."
$p37_50 = Get-Pages-37-to-50
foreach ($p in $p37_50) { [void]$sb.AppendLine($p) }

Write-Output "Generating Pages 51 to 62..."
$p51_62 = Get-Pages-51-to-62
foreach ($p in $p51_62) { [void]$sb.AppendLine($p) }

[void]$sb.AppendLine("</body></html>")

$htmlPath = "C:\Users\User\Desktop\FYP\docs\srds_pdf_template.html"
$pdfPath = "C:\Users\User\Desktop\FYP\docs\TexEye_AI_SRDS_COMSATS.pdf"

Write-Output "Writing $htmlPath..."
[System.IO.File]::WriteAllText($htmlPath, $sb.ToString(), [System.Text.Encoding]::UTF8)

Write-Output "Compiling PDF via Headless Microsoft Edge..."
$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$htmlUri = "file:///C:/Users/User/Desktop/FYP/docs/srds_pdf_template.html"

Start-Process -FilePath $edgeExe -ArgumentList "--headless", "--disable-gpu", "--run-all-compositor-stages-before-draw", "--no-pdf-header-footer", "--print-to-pdf=$pdfPath", $htmlUri -Wait

if (Test-Path $pdfPath) {
    $pdfItem = Get-Item $pdfPath
    Write-Output "SUCCESS: PDF successfully compiled! File: $($pdfItem.FullName), Size: $($pdfItem.Length) bytes"
} else {
    Write-Error "ERROR: PDF file was not created!"
}
