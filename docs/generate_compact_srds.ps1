# Master Compact SRDS PDF Compiler for TexEye AI (COMSATS Wah Standard, 31 Pages)
# Authors: Muhammad Afnan Khan (FA23-BAI-028) & Muhammad Bilal Butt (FA23-BAI-042)
# Supervisor: Dr. Tassawar Iqbal, Department of Computer Science, COMSATS University Islamabad, Wah Cantt Campus

$ErrorActionPreference = "Stop"

Write-Output "=== Starting TexEye AI Compact SRDS Compilation (31 Pages) ==="

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
    font-size: 8.5pt;
    line-height: 1.42;
  }
  .page {
    width: 210mm;
    height: 297mm;
    padding: 10mm 13mm;
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
    padding: 2mm;
  }
  .page-inner-frame {
    width: 100%;
    height: 100%;
    border: 0.8pt solid #000000;
    padding: 5mm 7mm;
    position: relative;
    display: flex;
    flex-direction: column;
  }
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 8.5pt;
    font-style: italic;
    border-bottom: 1pt solid #000000;
    padding-bottom: 1.2mm;
    margin-bottom: 2.2mm;
    flex-shrink: 0;
  }
  .page-content {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
  }
  .chapter-bar {
    background-color: #1a202c;
    color: #ffffff;
    font-size: 11pt;
    font-weight: bold;
    padding: 3px 8px;
    margin-bottom: 2mm;
    flex-shrink: 0;
    letter-spacing: 0.3px;
  }
  h2.sec-heading {
    font-size: 9.8pt;
    font-weight: bold;
    margin: 1.5mm 0 1mm 0;
    color: #000000;
  }
  h3.subsec-heading {
    font-size: 8.8pt;
    font-weight: bold;
    margin: 1.2mm 0 0.8mm 0;
    color: #000000;
  }
  p.body-p {
    margin: 0 0 1.5mm 0;
    text-align: justify;
    color: #000000;
  }
  ul, ol {
    margin: 0 0 1.5mm 0;
    padding-left: 5mm;
  }
  li {
    margin-bottom: 0.6mm;
    text-align: justify;
  }
  /* Comprehensive Table Styling (Matching ReDez COMSATS Standard) */
  table, table.formal-table, table.req-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 7.2pt;
    line-height: 1.35;
    margin: 1.2mm 0 2mm 0;
    border: 1px solid #718096;
    background-color: #ffffff;
  }
  table th, table.formal-table th, table.req-table th {
    background-color: #e2e8f0;
    border: 1px solid #718096;
    padding: 2.8px 4.5px;
    font-weight: bold;
    text-align: left;
    color: #000000;
    vertical-align: middle;
  }
  table td, table.formal-table td, table.req-table td {
    border: 1px solid #a0aec0;
    padding: 2.2px 4.5px;
    vertical-align: top;
    color: #000000;
    background-color: #ffffff;
  }
  table.formal-table th {
    background-color: #edf2f7;
    border: 1px solid #718096;
    font-weight: bold;
    color: #000000;
  }
  .toc-line {
    display: flex;
    justify-content: space-between;
    margin-bottom: 1mm;
    font-size: 8.2pt;
  }
  .toc-dots {
    flex-grow: 1;
    border-bottom: 1px dotted #718096;
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
    font-size: 9pt;
    text-align: center;
    margin-top: 1.5mm;
  }
</style>
</head>
<body>
"@

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine($htmlShell)

# Load parts
. "C:\Users\User\Desktop\FYP\docs\gen_compact_part1.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_compact_part2.ps1"
. "C:\Users\User\Desktop\FYP\docs\gen_compact_part3.ps1"

Write-Output "Gathering Pages 1 to 11..."
$pages1 = Get-Compact-Pages-1-to-11
foreach ($p in $pages1) { [void]$sb.AppendLine($p) }

Write-Output "Gathering Pages 12 to 21..."
$pages2 = Get-Compact-Pages-12-to-21
foreach ($p in $pages2) { [void]$sb.AppendLine($p) }

Write-Output "Gathering Pages 22 to 31..."
$pages3 = Get-Compact-Pages-22-to-31
foreach ($p in $pages3) { [void]$sb.AppendLine($p) }

[void]$sb.AppendLine("</body></html>")

$htmlPath = "C:\Users\User\Desktop\FYP\docs\srds_pdf_template.html"
$pdfPath = "C:\Users\User\Desktop\FYP\docs\TexEye_AI_SRDS_COMSATS.pdf"

Write-Output "Writing $htmlPath..."
[System.IO.File]::WriteAllText($htmlPath, $sb.ToString(), [System.Text.Encoding]::UTF8)

Write-Output "Total pages written: $( $pages1.Count + $pages2.Count + $pages3.Count )"

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
