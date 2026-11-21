# scripts/make_meeting_diagrams_part3.ps1
# Generates Diagrams 04, 05, 06, 07

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$modulesDir = Join-Path $projectRoot "diagrams\modules"
$pdfDir = Join-Path $modulesDir "pdf"
$pngDir = Join-Path $modulesDir "png"
$docsDir = Join-Path $projectRoot "docs"

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) { $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }

function Compile-Diagram {
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

# ------------------------------------------------------------------------------
# 04: SEQUENCE DIAGRAM — MODULE 4: WEB QUALITY MANAGEMENT & DIGITAL MAP
# ------------------------------------------------------------------------------
$svg04 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">Sequence Diagram &bull; Module 4: Web Quality Management &amp; Digital Fabric Map</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Owner: Muhammad Afnan Khan (FA23-BAI-028) &bull; 2D Canvas Roll Web, Crop Gallery, Electronic Calipers &amp; Defect Reclassification</text>

  <!-- Lifeline Headers -->
  <rect x="50" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="130" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:QualityInspector</text>
  <line x1="130" y1="120" x2="130" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="260" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="340" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:WebDashboard (React)</text>
  <line x1="340" y1="120" x2="340" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="470" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="550" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:Canvas2DMap</text>
  <line x1="550" y1="120" x2="550" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="680" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="760" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:FastAPIGateway</text>
  <line x1="760" y1="120" x2="760" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="890" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="970" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:PostgreSQLDB</text>
  <line x1="970" y1="120" x2="970" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="1100" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="1180" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:MinIOObjectStore</text>
  <line x1="1180" y1="120" x2="1180" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <!-- Messages -->
  <line x1="130" y1="150" x2="340" y2="150" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="137" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="149" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">1. select_roll(roll_id)</text>

  <line x1="340" y1="190" x2="760" y2="190" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="470" y="177" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="550" y="189" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">2. GET /api/v1/rolls/{id}/map</text>

  <line x1="760" y1="230" x2="970" y2="230" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="805" y="217" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="865" y="229" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">3. SELECT defects &amp; spans</text>

  <line x1="970" y1="270" x2="760" y2="270" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="805" y="257" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="865" y="269" font-size="8" fill="#166534" text-anchor="middle">defects_list, spans_list</text>

  <line x1="760" y1="310" x2="340" y2="310" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="470" y="297" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="550" y="309" font-size="8" fill="#166534" text-anchor="middle">200 OK (map_payload_json)</text>

  <!-- Canvas Draw -->
  <line x1="340" y1="350" x2="550" y2="350" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="385" y="337" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="445" y="349" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">4. render_2d_web(defects)</text>

  <!-- Inspector clicks flaw glyph -->
  <line x1="130" y1="400" x2="340" y2="400" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="387" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="399" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">5. click_defect_glyph(#14)</text>

  <!-- Fetch High Res Crop -->
  <line x1="340" y1="440" x2="1180" y2="440" stroke="#2563eb" stroke-width="1.3" marker-end="url(#arr-blue)"/>
  <rect x="670" y="427" width="180" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="760" y="439" font-size="8" font-weight="bold" fill="#1d4ed8" text-anchor="middle">6. fetch_crop_url(defect_id)</text>

  <line x1="1180" y1="480" x2="340" y2="480" stroke="#2563eb" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-blue)"/>
  <rect x="670" y="467" width="180" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="760" y="479" font-size="8" fill="#1e40af" text-anchor="middle">crop_image_blob (256x256)</text>

  <!-- Display Modal & Calipers -->
  <line x1="340" y1="520" x2="130" y2="520" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="507" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="519" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">7. show_gallery_modal()</text>

  <!-- Reclassification Action -->
  <line x1="130" y1="570" x2="340" y2="570" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="557" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="569" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">8. reclassify('Foreign Yarn')</text>

  <line x1="340" y1="610" x2="760" y2="610" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="470" y="597" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="550" y="609" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">9. PATCH /api/v1/defects/{id}</text>

  <line x1="760" y1="650" x2="970" y2="650" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="805" y="637" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="865" y="649" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">10. UPDATE &amp; INSERT audit</text>

  <line x1="970" y1="690" x2="340" y2="690" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="580" y="677" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="660" y="689" font-size="8" fill="#166534" text-anchor="middle">200 OK (reclassified, audit_id)</text>

  <!-- Bottom Legend -->
  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module 4 Defense Summary (Afnan Khan):</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; 2D Defect Map renders the full fabric roll as an interactive canvas map with color-coded defect glyphs and highlighted uninspected hazard spans.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Inspector has full audit capability: clicking any defect brings up the high-res crop photo for caliper measurement and reclassification.</text>
</svg>
"@

$exp04 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> Module 4 Sequence Walkthrough for Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Interactive 2D Fabric Map</strong>
          Explain: "Sir, on the web dashboard, the entire roll (e.g. 500 meters) is rendered on an HTML5 canvas. Flaws are color-coded: red for holes, yellow for stains, purple for thread flaws."
        </div>
        <div class="exp-col">
          <strong>2. Defect Crop Verification</strong>
          Explain: "When the inspector clicks on any defect glyph, the high-res 256x256 image patch is loaded from MinIO object storage. The inspector can measure flaw length using digital electronic calipers."
        </div>
        <div class="exp-col">
          <strong>3. Immutable Audit Trail</strong>
          Explain: "If the AI misclassified a stain as a hole, the inspector reclassifies it. The system updates the record and logs who made the change with an immutable timestamp."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "04_module_4_web_quality_map_sequence" -SvgContent $svg04 -Title "Sequence Diagram &bull; Module 4: Web Quality Management & Digital Map" -Subtitle "Step-by-Step Execution Trace: 2D Canvas Roll Map, Crop Gallery Modal & Audit Reclassification" -ExplanationHtml $exp04

# ------------------------------------------------------------------------------
# 05: SEQUENCE DIAGRAM — MODULE 5: SMART OPERATIONS & ASTM 4-POINT GRADING
# ------------------------------------------------------------------------------
$svg05 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">Sequence Diagram &bull; Module 5: Smart Operations Module &amp; ASTM 4-Point Grading</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Joint Collaboration: Bilal &amp; Afnan &bull; ASTM D5430 Penalty Calculation, Grade Assignment &amp; PDF Quality Certificate Export</text>

  <!-- Lifeline Headers -->
  <rect x="50" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="130" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:QualityManager</text>
  <line x1="130" y1="120" x2="130" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="260" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="340" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:WebDashboard</text>
  <line x1="340" y1="120" x2="340" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="470" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="550" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:FastAPIServer</text>
  <line x1="550" y1="120" x2="550" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="680" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="760" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:ASTMEngine</text>
  <line x1="760" y1="120" x2="760" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="890" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="970" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:PostgreSQLDB</text>
  <line x1="970" y1="120" x2="970" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="1100" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="1180" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:PDFExportService</text>
  <line x1="1180" y1="120" x2="1180" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <!-- Messages -->
  <line x1="130" y1="150" x2="340" y2="150" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="137" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="149" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">1. click_finalize_roll()</text>

  <line x1="340" y1="190" x2="550" y2="190" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="385" y="177" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="445" y="189" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">2. POST /rolls/{id}/grade</text>

  <line x1="550" y1="230" x2="760" y2="230" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="580" y="217" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="660" y="229" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">3. compute_astm_d5430(roll_id)</text>

  <line x1="760" y1="270" x2="970" y2="270" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="805" y="257" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="865" y="269" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">4. SELECT all defects</text>

  <line x1="970" y1="310" x2="760" y2="310" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="805" y="297" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="865" y="309" font-size="8" fill="#166534" text-anchor="middle">defects with length_mm</text>

  <!-- ASTM Calculation Logic -->
  <line x1="760" y1="350" x2="760" y2="390" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="760" y1="390" x2="790" y2="390" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="790" y1="390" x2="790" y2="350" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="790" y1="350" x2="765" y2="350" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="770" y="360" width="160" height="16" fill="#f8fafc" stroke="#cbd5e1" rx="3"/>
  <text x="850" y="372" font-size="7.5" font-weight="bold" fill="#0f172a" text-anchor="middle">calc: max 4 pts / meter</text>

  <!-- Commit Grade -->
  <line x1="760" y1="430" x2="970" y2="430" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="805" y="417" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="865" y="429" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">5. UPDATE grade = 'Grade A'</text>

  <line x1="760" y1="470" x2="550" y2="470" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="580" y="457" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="660" y="469" font-size="8" fill="#166534" text-anchor="middle">grade_summary (14.2 pts/100m²)</text>

  <!-- Generate PDF -->
  <line x1="550" y1="510" x2="1180" y2="510" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="790" y="497" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="870" y="509" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">6. render_pdf(roll, defects, astm)</text>

  <!-- Sign PDF -->
  <line x1="1180" y1="550" x2="1180" y2="590" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="1180" y1="590" x2="1210" y2="590" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="1210" y1="590" x2="1210" y2="550" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="1210" y1="550" x2="1185" y2="550" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="1190" y="560" width="110" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="1245" y="572" font-size="7.5" font-weight="bold" fill="#15803d" text-anchor="middle">sign_sha256_hash()</text>

  <!-- Return Download URL -->
  <line x1="1180" y1="630" x2="550" y2="630" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="790" y="617" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="870" y="629" font-size="8" fill="#166534" text-anchor="middle">pdf_url, sha256_seal</text>

  <line x1="550" y1="670" x2="340" y2="670" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="385" y="657" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="445" y="669" font-size="8" fill="#166534" text-anchor="middle">200 OK (grade_report_ready)</text>

  <line x1="340" y1="710" x2="130" y2="710" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="175" y="697" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="235" y="709" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">7. display_download_button()</text>

  <!-- Bottom Legend -->
  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module 5 Defense Summary (Joint: Bilal &amp; Afnan):</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; ASTM D5430 4-Point System is computed mathematically: 1 to 4 penalty points per flaw, capped at 4 points per linear meter.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Official PDF Inspection Certificate is signed with a cryptographic SHA-256 seal to prevent tampering by fabric buyers or sellers.</text>
</svg>
"@

$exp05 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> Module 5 Sequence Walkthrough for Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Standard 4-Point Rules</strong>
          Explain: "Sir, we follow the commercial standard ASTM D5430-07. Flaws are scored 1 to 4 points based on length. No meter can score more than 4 points."
        </div>
        <div class="exp-col">
          <strong>2. Area Normalization</strong>
          Explain: "Points are normalized to 100 square meters: (Total Points &times; 10000) / (Length &times; Width). &le;20 points is Grade A; &le;40 is Grade B; above 40 is Scrap."
        </div>
        <div class="exp-col">
          <strong>3. Tamper-Proof Certificate</strong>
          Explain: "A vector PDF is compiled with roll metadata, defect distribution charts, and a cryptographic SHA-256 hash printed at the bottom."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "05_module_5_smart_operations_astm_sequence" -SvgContent $svg05 -Title "Sequence Diagram &bull; Module 5: Smart Operations & ASTM Grading" -Subtitle "Step-by-Step Execution Trace: ASTM D5430 4-Point Penalty Accumulation & Cryptographic PDF Generation" -ExplanationHtml $exp05

# ------------------------------------------------------------------------------
# 06: COMPREHENSIVE UML CLASS DIAGRAM
# ------------------------------------------------------------------------------
$svg06 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Comprehensive UML Class Diagram</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Domain Object Model: Attributes, Methods, Multiplicities (1-to-1, 1-to-Many) &amp; Component Composition</text>

  <!-- Row 1: Core Domain Entities -->

  <!-- Class 1: UserAccount -->
  <rect x="45" y="80" width="220" height="150" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="45" y="80" width="220" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="155" y="96" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">UserAccount</text>
  <text x="55" y="118" font-size="8" fill="#334155">+ user_id: UUID (PK)</text>
  <text x="55" y="132" font-size="8" fill="#334155">+ username: String</text>
  <text x="55" y="146" font-size="8" fill="#334155">+ password_hash: String</text>
  <text x="55" y="160" font-size="8" fill="#334155">+ role: RoleEnum [Operator, QA, Mgr]</text>
  <line x1="45" y1="168" x2="265" y2="168" stroke="#cbd5e1" stroke-width="1"/>
  <text x="55" y="184" font-size="8" fill="#0284c7">+ authenticate(password): Bool</text>
  <text x="55" y="198" font-size="8" fill="#0284c7">+ generate_jwt_token(): String</text>
  <text x="55" y="212" font-size="8" fill="#0284c7">+ has_permission(perm): Bool</text>

  <!-- Association User to FabricRoll -->
  <line x1="265" y1="150" x2="355" y2="150" stroke="#0f172a" stroke-width="1.3"/>
  <text x="275" y="142" font-size="8.5" font-weight="bold">1</text>
  <text x="335" y="142" font-size="8.5" font-weight="bold">*</text>

  <!-- Class 2: FabricRoll -->
  <rect x="355" y="80" width="260" height="175" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="355" y="80" width="260" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="485" y="96" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">FabricRoll</text>
  <text x="365" y="118" font-size="8" fill="#334155">+ roll_id: String (PK)</text>
  <text x="365" y="132" font-size="8" fill="#334155">+ batch_id: String</text>
  <text x="365" y="146" font-size="8" fill="#334155">+ length_meters: Float</text>
  <text x="365" y="160" font-size="8" fill="#334155">+ width_mm: Float</text>
  <text x="365" y="174" font-size="8" fill="#334155">+ final_grade: GradeEnum [A, B, Scrap]</text>
  <text x="365" y="188" font-size="8" fill="#334155">+ total_penalty_points: Int</text>
  <line x1="355" y1="196" x2="615" y2="196" stroke="#cbd5e1" stroke-width="1"/>
  <text x="365" y="212" font-size="8" fill="#0284c7">+ calculate_area_sqm(): Float</text>
  <text x="365" y="226" font-size="8" fill="#0284c7">+ get_all_defects(): List[DefectRecord]</text>
  <text x="365" y="240" font-size="8" fill="#0284c7">+ set_grade(grade, points): Void</text>

  <!-- Association FabricRoll to DefectRecord -->
  <line x1="615" y1="150" x2="705" y2="150" stroke="#0f172a" stroke-width="1.3"/>
  <text x="625" y="142" font-size="8.5" font-weight="bold">1</text>
  <text x="685" y="142" font-size="8.5" font-weight="bold">*</text>

  <!-- Class 3: DefectRecord -->
  <rect x="705" y="80" width="260" height="175" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="705" y="80" width="260" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="835" y="96" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">DefectRecord</text>
  <text x="715" y="118" font-size="8" fill="#334155">+ defect_id: UUID (PK)</text>
  <text x="715" y="132" font-size="8" fill="#334155">+ roll_id: String (FK)</text>
  <text x="715" y="146" font-size="8" fill="#334155">+ flaw_class: DefectCategoryEnum</text>
  <text x="715" y="160" font-size="8" fill="#334155">+ coord_x_cm: Float</text>
  <text x="715" y="174" font-size="8" fill="#334155">+ coord_y_m: Float</text>
  <text x="715" y="188" font-size="8" fill="#334155">+ length_mm: Float</text>
  <line x1="705" y1="196" x2="965" y2="196" stroke="#cbd5e1" stroke-width="1"/>
  <text x="715" y="212" font-size="8" fill="#0284c7">+ compute_astm_pts(): Int [1, 2, 3, 4]</text>
  <text x="715" y="226" font-size="8" fill="#0284c7">+ reclassify(new_class, inspector_id)</text>
  <text x="715" y="240" font-size="8" fill="#0284c7">+ get_crop_url(): String</text>

  <!-- Association FabricRoll to UninspectedSpan -->
  <line x1="485" y1="255" x2="485" y2="340" stroke="#0f172a" stroke-width="1.3"/>
  <text x="495" y="270" font-size="8.5" font-weight="bold">1</text>
  <text x="495" y="325" font-size="8.5" font-weight="bold">*</text>

  <!-- Class 4: UninspectedSpan -->
  <rect x="355" y="340" width="260" height="150" fill="#fff1f2" stroke="#e11d48" stroke-width="1.4" rx="5"/>
  <rect x="355" y="340" width="260" height="24" fill="#fee2e2" stroke="#e11d48" stroke-width="1" rx="4"/>
  <text x="485" y="356" font-size="10.5" font-weight="bold" fill="#9f1239" text-anchor="middle">UninspectedSpan</text>
  <text x="365" y="378" font-size="8" fill="#9f1239">+ span_id: UUID (PK)</text>
  <text x="365" y="392" font-size="8" fill="#9f1239">+ roll_id: String (FK)</text>
  <text x="365" y="406" font-size="8" fill="#9f1239">+ start_meter: Float</text>
  <text x="365" y="420" font-size="8" fill="#9f1239">+ end_meter: Float</text>
  <text x="365" y="434" font-size="8" fill="#9f1239">+ fault_reason: String (Lux &lt; 800 | Blur)</text>
  <line x1="355" y1="442" x2="615" y2="442" stroke="#fca5a5" stroke-width="1"/>
  <text x="365" y="458" font-size="8" fill="#be123c">+ get_span_length(): Float</text>
  <text x="365" y="472" font-size="8" fill="#be123c">+ is_hazard_critical(): Bool</text>

  <!-- Class 5: ASTMPenaltyCalculator -->
  <rect x="1035" y="80" width="250" height="175" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.4" rx="5"/>
  <rect x="1035" y="80" width="250" height="24" fill="#dcfce7" stroke="#16a34a" stroke-width="1" rx="4"/>
  <text x="1160" y="96" font-size="10.5" font-weight="bold" fill="#15803d" text-anchor="middle">ASTMPenaltyCalculator</text>
  <text x="1045" y="118" font-size="8" fill="#166534">+ standard: String = "ASTM D5430-07"</text>
  <text x="1045" y="132" font-size="8" fill="#166534">+ max_penalty_per_linear_meter: 4</text>
  <text x="1045" y="146" font-size="8" fill="#166534">+ grade_a_cutoff: Float = 20.0</text>
  <text x="1045" y="160" font-size="8" fill="#166534">+ grade_b_cutoff: Float = 40.0</text>
  <line x1="1035" y1="170" x2="1285" y2="170" stroke="#86efac" stroke-width="1"/>
  <text x="1045" y="186" font-size="8" fill="#15803d">+ score_defects(defects): Int</text>
  <text x="1045" y="200" font-size="8" fill="#15803d">+ compute_100sqm_pts(roll): Float</text>
  <text x="1045" y="214" font-size="8" fill="#15803d">+ assign_grade(points): GradeEnum</text>
  <text x="1045" y="228" font-size="8" fill="#15803d">+ generate_certificate(roll): PDF</text>

  <!-- Association DefectRecord to ASTMPenaltyCalculator -->
  <line x1="965" y1="150" x2="1035" y2="150" stroke="#0f172a" stroke-width="1.3"/>
  <text x="975" y="142" font-size="8.5" font-weight="bold">*</text>
  <text x="1015" y="142" font-size="8.5" font-weight="bold">1</text>

  <!-- Row 2: Stand & Hardware Engine Classes -->

  <!-- Class 6: HardwareStandController -->
  <rect x="45" y="340" width="260" height="160" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="45" y="340" width="260" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="175" y="356" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">HardwareStandController</text>
  <text x="55" y="378" font-size="8" fill="#334155">+ stand_id: String</text>
  <text x="55" y="392" font-size="8" fill="#334155">+ current_speed_mpm: Float</text>
  <text x="55" y="406" font-size="8" fill="#334155">+ is_healthy: Bool</text>
  <line x1="45" y1="416" x2="305" y2="416" stroke="#cbd5e1" stroke-width="1"/>
  <text x="55" y="432" font-size="8" fill="#0284c7">+ initialize_hardware(): Bool</text>
  <text x="55" y="446" font-size="8" fill="#0284c7">+ trip_safety_alarm(color, siren)</text>
  <text x="55" y="460" font-size="8" fill="#0284c7">+ reset_alarm(): Void</text>
  <text x="55" y="474" font-size="8" fill="#0284c7">+ read_sensors_telemetry(): Dict</text>

  <!-- Class 7: YOLODetector -->
  <rect x="705" y="340" width="260" height="160" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="705" y="340" width="260" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="835" y="356" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">YOLODetector</text>
  <text x="715" y="378" font-size="8" fill="#334155">+ model_weights_path: String</text>
  <text x="715" y="392" font-size="8" fill="#334155">+ confidence_threshold: Float = 0.65</text>
  <text x="715" y="406" font-size="8" fill="#334155">+ target_classes: List[String]</text>
  <line x1="705" y1="416" x2="965" y2="416" stroke="#cbd5e1" stroke-width="1"/>
  <text x="715" y="432" font-size="8" fill="#0284c7">+ load_model(): Void</text>
  <text x="715" y="446" font-size="8" fill="#0284c7">+ infer_frame(image_frame): List[BBox]</text>
  <text x="715" y="460" font-size="8" fill="#0284c7">+ crop_flaw_patch(bbox): Image</text>

  <!-- Class 8: KalmanTracker -->
  <rect x="1035" y="340" width="250" height="160" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="1035" y="340" width="250" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="1160" y="356" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">KalmanTracker</text>
  <text x="1045" y="378" font-size="8" fill="#334155">+ max_disappeared_frames: 5</text>
  <text x="1045" y="392" font-size="8" fill="#334155">+ spatial_gate_distance_mm: 35.0</text>
  <text x="1045" y="406" font-size="8" fill="#334155">+ active_tracks: Dict[track_id, state]</text>
  <line x1="1035" y1="416" x2="1285" y2="416" stroke="#cbd5e1" stroke-width="1"/>
  <text x="1045" y="432" font-size="8" fill="#0284c7">+ predict_next_position(): Matrix</text>
  <text x="1045" y="446" font-size="8" fill="#0284c7">+ update_tracks(detections): List[Track]</text>
  <text x="1045" y="460" font-size="8" fill="#0284c7">+ deduplicate(track): Bool</text>

  <!-- Row 3: Offline Resilience & Outbox -->

  <!-- Class 9: OutboxSyncEvent -->
  <rect x="355" y="550" width="260" height="150" fill="#fffbeb" stroke="#d97706" stroke-width="1.4" rx="5"/>
  <rect x="355" y="550" width="260" height="24" fill="#fef3c7" stroke="#d97706" stroke-width="1" rx="4"/>
  <text x="485" y="566" font-size="10.5" font-weight="bold" fill="#92400e" text-anchor="middle">OutboxSyncEvent</text>
  <text x="365" y="588" font-size="8" fill="#92400e">+ event_id: UUID (PK)</text>
  <text x="365" y="602" font-size="8" fill="#92400e">+ payload_json: String</text>
  <text x="365" y="616" font-size="8" fill="#92400e">+ sync_state: SyncStatus [PENDING, SENT]</text>
  <text x="365" y="630" font-size="8" fill="#92400e">+ retry_count: Int</text>
  <line x1="355" y1="638" x2="615" y2="638" stroke="#fde68a" stroke-width="1"/>
  <text x="365" y="654" font-size="8" fill="#b45309">+ mark_synced(): Void</text>
  <text x="365" y="668" font-size="8" fill="#b45309">+ increment_backoff(): Void</text>
  <text x="365" y="682" font-size="8" fill="#b45309">+ should_retry(): Bool</text>

  <!-- Association FabricRoll to OutboxSyncEvent -->
  <line x1="485" y1="490" x2="485" y2="550" stroke="#0f172a" stroke-width="1.3"/>
  <text x="495" y="505" font-size="8.5" font-weight="bold">1</text>
  <text x="495" y="535" font-size="8.5" font-weight="bold">*</text>

  <!-- Class 10: InspectionSession -->
  <rect x="705" y="550" width="260" height="150" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <rect x="705" y="550" width="260" height="24" fill="#f1f5f9" stroke="#0f172a" stroke-width="1" rx="4"/>
  <text x="835" y="566" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">InspectionSession</text>
  <text x="715" y="588" font-size="8" fill="#334155">+ session_id: UUID (PK)</text>
  <text x="715" y="602" font-size="8" fill="#334155">+ roll_id: String (FK)</text>
  <text x="715" y="616" font-size="8" fill="#334155">+ operator_id: UUID (FK)</text>
  <text x="715" y="630" font-size="8" fill="#334155">+ start_time / end_time: Timestamp</text>
  <line x1="705" y1="638" x2="965" y2="638" stroke="#cbd5e1" stroke-width="1"/>
  <text x="715" y="654" font-size="8" fill="#0284c7">+ start_session(): Void</text>
  <text x="715" y="668" font-size="8" fill="#0284c7">+ pause_session(): Void</text>
  <text x="715" y="682" font-size="8" fill="#0284c7">+ finalize_session(): RollSummary</text>

  <!-- Bottom Legend -->
  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Class Diagram Multiplicity &amp; Architecture Notes:</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; 1 FabricRoll has Many (*) DefectRecords and Many (*) UninspectedSpans. 1 UserAccount supervises Many (*) Rolls.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Complete Separation: AI inference (YOLODetector) and tracking (KalmanTracker) are decoupled from storage entities (FabricRoll, OutboxSyncEvent).</text>
</svg>
"@

$exp06 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Explain the Class Diagram to Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Core Domain Hierarchy</strong>
          Explain: "Sir, FabricRoll is the root aggregate. 1 roll contains many DefectRecords and many UninspectedSpans. It is evaluated by 1 ASTMPenaltyCalculator."
        </div>
        <div class="exp-col">
          <strong>2. Explicit Multiplicities</strong>
          Explain: "Relationships are strictly typed: UserAccount (1) to FabricRoll (*), FabricRoll (1) to DefectRecord (*), and FabricRoll (1) to OutboxSyncEvent (*)."
        </div>
        <div class="exp-col">
          <strong>3. Real-Time Engine Encapsulation</strong>
          Explain: "The YOLODetector, KalmanTracker, and HardwareStandController encapsulate sensing and AI algorithms with clean public methods."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "06_texeye_ai_class_diagram" -SvgContent $svg06 -Title "TexEye AI &bull; Comprehensive UML Class Diagram" -Subtitle "Domain Entities, Attributes, Methods, 1-to-1 and 1-to-Many Multiplicities" -ExplanationHtml $exp06

# ------------------------------------------------------------------------------
# 07: MODULE-WISE USE CASES DIAGRAM (ALL 5 MODULES)
# ------------------------------------------------------------------------------
$svg07 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Module-Wise Use Case Diagram (All 5 Modules)</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Partitioned by the 5 Official Project Modules with Assigned Team Ownership</text>

  <!-- Actors Left -->
  <rect x="40" y="110" width="160" height="80" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <text x="120" y="135" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="120" y="153" font-size="11" font-weight="bold" fill="#0284c7" text-anchor="middle">Floor Operator</text>
  <text x="120" y="168" font-size="8" fill="#64748b" text-anchor="middle">(Mobile Floor App)</text>

  <rect x="40" y="390" width="160" height="80" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <text x="120" y="415" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;System Actor&raquo;</text>
  <text x="120" y="433" font-size="11" font-weight="bold" fill="#0284c7" text-anchor="middle">Hardware Stand</text>
  <text x="120" y="448" font-size="8" fill="#64748b" text-anchor="middle">(Sensors &amp; Relays)</text>

  <!-- Actors Right -->
  <rect x="1120" y="110" width="160" height="80" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <text x="1200" y="135" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="1200" y="153" font-size="11" font-weight="bold" fill="#0284c7" text-anchor="middle">Quality Inspector</text>
  <text x="1200" y="168" font-size="8" fill="#64748b" text-anchor="middle">(Web Dashboard)</text>

  <rect x="1120" y="390" width="160" height="80" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="5"/>
  <text x="1200" y="415" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="1200" y="433" font-size="11" font-weight="bold" fill="#0284c7" text-anchor="middle">Quality Manager</text>
  <text x="1200" y="448" font-size="8" fill="#64748b" text-anchor="middle">(Web Management)</text>

  <!-- 5 Module Boundaries -->

  <!-- Module 1 -->
  <rect x="230" y="80" width="280" height="150" fill="#f8fafc" stroke="#0284c7" stroke-width="1.3" rx="6"/>
  <text x="370" y="100" font-size="9.5" font-weight="bold" fill="#0369a1" text-anchor="middle">Module 1: AI Defect Detection (Bilal)</text>
  <rect x="250" y="115" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="134" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-1.1: Detect Flaws via YOLO</text>
  <rect x="250" y="150" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="169" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-1.2: Map Metric Coordinates (X, Y)</text>
  <rect x="250" y="185" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="204" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-1.3: Kalman Multi-Frame Deduplication</text>

  <!-- Module 2 -->
  <rect x="230" y="245" width="280" height="180" fill="#fff1f2" stroke="#e11d48" stroke-width="1.3" rx="6"/>
  <text x="370" y="265" font-size="9.5" font-weight="bold" fill="#9f1239" text-anchor="middle">Module 2: Hardware Monitoring (Bilal)</text>
  <rect x="250" y="278" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="297" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-2.1: Monitor Camera Lux &amp; Blur</text>
  <rect x="250" y="313" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="332" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-2.2: Detect Dropped Video Frames</text>
  <rect x="250" y="348" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="367" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-2.3: Actuate Amber Relays &amp; Siren</text>
  <rect x="250" y="383" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="402" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-2.4: Log Uninspected Span [Y1, Y2]</text>

  <!-- Module 3 -->
  <rect x="230" y="440" width="280" height="180" fill="#f8fafc" stroke="#0284c7" stroke-width="1.3" rx="6"/>
  <text x="370" y="460" font-size="9.5" font-weight="bold" fill="#0369a1" text-anchor="middle">Module 3: Mobile Floor App (Afnan)</text>
  <rect x="250" y="473" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="492" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-3.1: Scan QR Code &amp; Start Run</text>
  <rect x="250" y="508" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="527" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-3.2: View Real-Time Speed Gauge</text>
  <rect x="250" y="543" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="562" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-3.3: Receive Haptic Vibration Alerts</text>
  <rect x="250" y="578" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="370" y="597" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-3.4: Tag Manual Floor Flaws</text>

  <!-- Module 4 -->
  <rect x="540" y="80" width="280" height="230" fill="#f8fafc" stroke="#0284c7" stroke-width="1.3" rx="6"/>
  <text x="680" y="100" font-size="9.5" font-weight="bold" fill="#0369a1" text-anchor="middle">Module 4: Web Quality Map (Afnan)</text>
  <rect x="560" y="115" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="134" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-4.1: Render 2D Fabric Defect Map</text>
  <rect x="560" y="150" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="169" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-4.2: Zoom Crop Gallery with Calipers</text>
  <rect x="560" y="185" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="204" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-4.3: Review &amp; Reclassify Flaw Tags</text>
  <rect x="560" y="220" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="239" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-4.4: Rolls Master Table &amp; Filter</text>
  <rect x="560" y="255" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="274" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-4.5: Auto-Sync Offline SQLite</text>

  <!-- Module 5 -->
  <rect x="540" y="330" width="280" height="230" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.3" rx="6"/>
  <text x="680" y="350" font-size="9.5" font-weight="bold" fill="#15803d" text-anchor="middle">Module 5: Smart Operations (Joint)</text>
  <rect x="560" y="365" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="384" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-5.1: Calculate ASTM 4-Point Score</text>
  <rect x="560" y="400" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="419" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-5.2: Assign Grade A, B, or Scrap</text>
  <rect x="560" y="435" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="454" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-5.3: Track Scrap &amp; Inventory History</text>
  <rect x="560" y="470" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="489" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-5.4: Generate Signed PDF Certificate</text>
  <rect x="560" y="505" width="240" height="30" fill="#ffffff" stroke="#0f172a" rx="15"/>
  <text x="680" y="524" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-5.5: ERP Batch Export (JSON/CSV)</text>

  <!-- Association Lines -->
  <!-- Floor Operator to Module 3 -->
  <line x1="200" y1="150" x2="250" y2="488" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="200" y1="160" x2="250" y2="523" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="200" y1="170" x2="250" y2="558" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Stand to Module 1 & 2 -->
  <line x1="200" y1="430" x2="250" y2="130" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="200" y1="440" x2="250" y2="293" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="200" y1="450" x2="250" y2="363" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Quality Inspector to Module 4 -->
  <line x1="1120" y1="150" x2="800" y2="130" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1120" y1="160" x2="800" y2="165" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1120" y1="170" x2="800" y2="200" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Quality Manager to Module 5 -->
  <line x1="1120" y1="430" x2="800" y2="380" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1120" y1="440" x2="800" y2="415" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1120" y1="450" x2="800" y2="485" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Bottom Legend -->
  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module-Wise Use Case Ownership Summary:</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; Bilal Butt owns Modules 1 &amp; 2 (AI Defect Detection &amp; Hardware Inspection Monitoring).</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Afnan Khan owns Modules 3 &amp; 4 (Mobile Floor Application &amp; Web Quality Management). Module 5 (Smart Operations) is jointly implemented.</text>
</svg>
"@

$exp07 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Explain the 5 Module Use Cases to Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Exactly 5 Modules</strong>
          Explain: "Sir, as written in our proposal, we have 5 distinct modules: 1. AI Defect Detection, 2. Hardware Monitoring, 3. Mobile Floor App, 4. Web Quality Dashboard, 5. Smart Operations."
        </div>
        <div class="exp-col">
          <strong>2. Clear Student Ownership</strong>
          Explain: "Bilal is responsible for the AI vision and physical sensor monitoring (Modules 1 &amp; 2). Afnan is responsible for the mobile app and web dashboard (Modules 3 &amp; 4)."
        </div>
        <div class="exp-col">
          <strong>3. Joint Smart Operations</strong>
          Explain: "Module 5 binds the system together: computing standard ASTM D5430 grades and generating official PDF certificates."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "07_module_wise_use_cases" -SvgContent $svg07 -Title "TexEye AI &bull; Module-Wise Use Case Diagram (All 5 Modules)" -Subtitle "Functional Use Cases Organized Strictly by the 5 Project Proposal Modules" -ExplanationHtml $exp07

Write-Host "All remaining diagrams successfully compiled!" -ForegroundColor Green
