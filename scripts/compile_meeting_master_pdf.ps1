# scripts/compile_meeting_master_pdf.ps1
# Compiles the comprehensive Master Meeting Dossier with all diagrams embedded inline

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$modulesDir = Join-Path $projectRoot "diagrams\modules"
$docsDir = Join-Path $projectRoot "docs"

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) { $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }

function Clean-Svg($s) {
    return ($s -replace '<\?xml.*?\?>', '').Trim()
}

$svg00 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "00_rough_workflow_paper.svg"), [Text.Encoding]::UTF8))
$svg01 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "01_module_1_ai_detection_sequence.svg"), [Text.Encoding]::UTF8))
$svg02 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "02_module_2_hardware_monitoring_sequence.svg"), [Text.Encoding]::UTF8))
$svg03 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "03_module_3_mobile_app_sequence.svg"), [Text.Encoding]::UTF8))
$svg04 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "04_module_4_web_quality_map_sequence.svg"), [Text.Encoding]::UTF8))
$svg05 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "05_module_5_smart_operations_astm_sequence.svg"), [Text.Encoding]::UTF8))
$svg06 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "06_texeye_ai_class_diagram.svg"), [Text.Encoding]::UTF8))
$svg07 = Clean-Svg ([IO.File]::ReadAllText((Join-Path $modulesDir "07_module_wise_use_cases.svg"), [Text.Encoding]::UTF8))

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>TexEye AI — Supervisor Meeting Rough Workflow &amp; UML Guide</title>
  <style>
    @page {
      size: A4 portrait;
      margin: 10mm 12mm 12mm 12mm;
      @bottom-right {
        content: "Page " counter(page) " of " counter(pages);
        font-size: 8pt;
        color: #64748b;
      }
    }
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      font-size: 9pt;
      line-height: 1.5;
      color: #0f172a;
      background: #ffffff;
      margin: 0;
      padding: 0;
    }
    .cover-page {
      page-break-after: always;
      padding: 20mm 10mm 15mm 10mm;
      text-align: center;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      min-height: 250mm;
      border: 2px solid #0284c7;
      border-radius: 8px;
      background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
    }
    .inst-header {
      font-size: 11pt;
      font-weight: 700;
      letter-spacing: 0.5px;
      color: #0369a1;
      text-transform: uppercase;
      margin-bottom: 2mm;
    }
    .dept-header {
      font-size: 9.5pt;
      color: #475569;
      margin-bottom: 10mm;
    }
    .badge-fyp {
      display: inline-block;
      background: #e0f2fe;
      color: #0369a1;
      font-weight: 800;
      font-size: 9pt;
      padding: 4px 14px;
      border-radius: 20px;
      border: 1px solid #bae6fd;
      margin-bottom: 6mm;
      text-transform: uppercase;
    }
    .project-title {
      font-size: 20pt;
      font-weight: 900;
      color: #0f172a;
      line-height: 1.25;
      margin: 0 0 3mm 0;
    }
    .project-subtitle {
      font-size: 11pt;
      color: #0284c7;
      font-weight: 600;
      margin: 0 0 8mm 0;
    }
    .doc-type-box {
      background: #f1f5f9;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      padding: 10px 18px;
      display: inline-block;
      margin: 0 auto 10mm auto;
      max-width: 90%;
    }
    .doc-type-box h2 {
      margin: 0;
      font-size: 12pt;
      color: #0f172a;
    }
    .doc-type-box p {
      margin: 3px 0 0 0;
      font-size: 8.5pt;
      color: #475569;
    }
    .meta-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
      text-align: left;
      margin-top: 8mm;
      padding-top: 8mm;
      border-top: 1px solid #e2e8f0;
    }
    .meta-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      padding: 10px 14px;
    }
    .meta-card strong {
      display: block;
      font-size: 8.5pt;
      color: #64748b;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 4px;
    }
    .meta-card .name {
      font-size: 10pt;
      font-weight: 700;
      color: #0f172a;
    }
    .meta-card .detail {
      font-size: 8.5pt;
      color: #475569;
    }
    
    .page-break { page-break-after: always; }
    h2.section-header {
      font-size: 12pt;
      font-weight: 800;
      color: #0f172a;
      border-bottom: 2px solid #0284c7;
      padding-bottom: 3px;
      margin: 0 0 6px 0;
      display: flex;
      justify-content: space-between;
      align-items: baseline;
    }
    h2.section-header .subtag {
      font-size: 8pt;
      font-weight: 600;
      color: #64748b;
    }
    p.diagram-desc {
      font-size: 8pt;
      color: #475569;
      margin: 0 0 5px 0;
    }
    .diagram-frame {
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      padding: 3px;
      background: #ffffff;
      margin-bottom: 6px;
    }
    .diagram-frame svg {
      width: 100%;
      height: auto;
      display: block;
    }
    .callout-box {
      background: #f8fafc;
      border-left: 3px solid #0284c7;
      padding: 5px 10px;
      margin: 5px 0 8px 0;
      font-size: 8pt;
      border-radius: 0 4px 4px 0;
    }
    table.data-table {
      width: 100%;
      border-collapse: collapse;
      margin: 6px 0 8px 0;
      font-size: 8pt;
    }
    table.data-table th, table.data-table td {
      border: 1px solid #cbd5e1;
      padding: 4px 7px;
      text-align: left;
    }
    table.data-table th {
      background: #f1f5f9;
      color: #0f172a;
      font-weight: 700;
    }
  </style>
</head>
<body>

  <!-- COVER PAGE -->
  <div class="cover-page">
    <div>
      <div class="inst-header">COMSATS University Islamabad &bull; Wah Cantt Campus</div>
      <div class="dept-header">Department of Computer Science &bull; Final Year Project Meeting Blueprint</div>
      
      <div class="badge-fyp">Supervisor Meeting Presentation Dossier</div>
      <h1 class="project-title">TexEye AI</h1>
      <div class="project-subtitle">AI-Based Fabric Defect Detection and Quality Management System</div>
      
      <div class="doc-type-box">
        <h2>Rough Workflow Blueprint, Module-Wise Sequence &amp; UML Class Guide</h2>
        <p>Paper-Drawing Guidelines, 5 Module Sequence Diagrams, Domain Model &amp; Presentation Talking Points for Dr. Tassawar Iqbal</p>
      </div>
    </div>

    <div>
      <div class="meta-grid">
        <div class="meta-card">
          <strong>Project Supervisor</strong>
          <div class="name">Dr. Tassawar Iqbal</div>
          <div class="detail">Department of Computer Science</div>
          <div class="detail">COMSATS University Islamabad, Wah Cantt Campus</div>
        </div>

        <div class="meta-card">
          <strong>Project Team Members</strong>
          <div class="name">Muhammad Bilal Butt <span style="font-weight:normal; font-size:8pt; color:#64748b;">(FA23-BAI-042)</span></div>
          <div class="detail">&bull; Modules 1 &amp; 2: AI Detection &amp; Hardware Monitoring</div>
          <div class="name" style="margin-top:4px;">Muhammad Afnan Khan <span style="font-weight:normal; font-size:8pt; color:#64748b;">(FA23-BAI-028)</span></div>
          <div class="detail">&bull; Modules 3, 4 &amp; 5: Mobile App &amp; Web Quality Management</div>
        </div>
      </div>

      <div style="margin-top: 6mm; font-size: 8pt; color: #64748b;">
        Bachelor of Science in Artificial Intelligence (BS-AI) &bull; Prototype Scope Specification
      </div>
    </div>
  </div>

  <!-- SECTION 1: ROUGH WORKFLOW ON PAPER -->
  <div class="page-break">
    <h2 class="section-header">1. Rough Workflow Diagram (Paper-Drawing Blueprint) <span class="subtag">Notebook Reproduction</span></h2>
    <p class="diagram-desc">Simplified 4-stage sequential flow designed to be quickly drawn by hand on an A4 sheet of paper or notebook before your meeting with Dr. Tassawar Iqbal.</p>
    
    <div class="diagram-frame">
      $svg00
    </div>

    <div class="callout-box">
      <strong>How to explain to Sir:</strong><br>
      &bull; <strong>4 Stages:</strong> 1. Worker scans QR code on phone. 2. Camera grabs frames, encoder counts distance, and reliability is verified. 3. YOLO detects defects and Kalman tracks without duplicates, saving to local SQLite. 4. FastAPI server runs ASTM D5430 grading, and manager exports the PDF report.<br>
      &bull; <strong>The Reliability Gate:</strong> Emphasize to Sir: <em>"Sir, if lighting drops below 800 lux or frames drop, we NEVER guess. We immediately actuate an amber light and record that span as uninspected."</em>
    </div>
  </div>

  <!-- SECTION 2: MODULE-WISE USE CASES -->
  <div class="page-break">
    <h2 class="section-header">2. Module-Wise Use Case Diagram (All 5 Modules) <span class="subtag">Module Mapping</span></h2>
    <p class="diagram-desc">Shows functional use cases organized strictly across the 5 official project proposal modules with student ownership.</p>
    
    <div class="diagram-frame">
      $svg07
    </div>

    <div class="callout-box">
      <strong>Module Allocation:</strong><br>
      &bull; <strong>Bilal Butt (FA23-BAI-042):</strong> Module 1 (AI Defect Detection &amp; Location) + Module 2 (Hardware &amp; Inspection Monitoring).<br>
      &bull; <strong>Afnan Khan (FA23-BAI-028):</strong> Module 3 (Mobile Floor App) + Module 4 (Web Quality Management &amp; Digital Fabric Map).<br>
      &bull; <strong>Joint Work:</strong> Module 5 (Smart Operations Module &amp; ASTM 4-Point System).
    </div>
  </div>

  <!-- SECTION 3: SEQUENCE DIAGRAM — MODULE 1 -->
  <div class="page-break">
    <h2 class="section-header">3. Sequence Diagram &bull; Module 1: AI Defect Detection &amp; Location <span class="subtag">Bilal Butt</span></h2>
    <p class="diagram-desc">Operational message flow showing real-time frame ingestion, YOLO bounding box inference, rotary encoder metric mapping, and Kalman filter deduplication.</p>
    
    <div class="diagram-frame">
      $svg01
    </div>

    <div class="callout-box">
      <strong>Supervisor Question: "How do you avoid counting the same defect twice?"</strong><br>
      <strong>Answer:</strong> <em>"Sir, since the camera captures at 30 FPS, a flaw is visible across multiple frames. The Kalman tracker projects the flaw's trajectory along fabric motion and merges matching detections into a single unique defect record."</em>
    </div>
  </div>

  <!-- SECTION 4: SEQUENCE DIAGRAM — MODULE 2 -->
  <div class="page-break">
    <h2 class="section-header">4. Sequence Diagram &bull; Module 2: Hardware &amp; Inspection Monitoring <span class="subtag">Bilal Butt</span></h2>
    <p class="diagram-desc">Safety invariant execution trace showing mean lux evaluation, blur detection, physical relay actuation (amber light + siren), and uninspected span logging.</p>
    
    <div class="diagram-frame">
      $svg02
    </div>

    <div class="callout-box">
      <strong>Supervisor Question: "What happens if factory lighting flickers or dims?"</strong><br>
      <strong>Answer:</strong> <em>"Sir, if lux drops below 800, the Reliability Guard trips the physical amber relay, sounds the siren, and logs interval [Y1, Y2] as uninspected in SQLite. It alerts the operator immediately."</em>
    </div>
  </div>

  <!-- SECTION 5: SEQUENCE DIAGRAM — MODULE 3 -->
  <div class="page-break">
    <h2 class="section-header">5. Sequence Diagram &bull; Module 3: Mobile Floor Application <span class="subtag">Afnan Khan</span></h2>
    <p class="diagram-desc">Mobile client interaction flow: QR roll scanning, real-time speed &amp; length display, WebSocket haptic vibration alert, and manual floor defect tagging.</p>
    
    <div class="diagram-frame">
      $svg03
    </div>

    <div class="callout-box">
      <strong>Supervisor Question: "Why do floor operators need a mobile app?"</strong><br>
      <strong>Answer:</strong> <em>"Sir, fabric inspection stands are long. The worker walks around the machine. When a defect passes, their phone vibrates via WebSocket push, letting them immediately inspect the physical flaw."</em>
    </div>
  </div>

  <!-- SECTION 6: SEQUENCE DIAGRAM — MODULE 4 -->
  <div class="page-break">
    <h2 class="section-header">6. Sequence Diagram &bull; Module 4: Web Quality Management &amp; Digital Fabric Map <span class="subtag">Afnan Khan</span></h2>
    <p class="diagram-desc">Web dashboard flow: HTML5 canvas 2D roll defect map, high-res crop gallery zoom, electronic calipers measurement, defect reclassification, and audit logging.</p>
    
    <div class="diagram-frame">
      $svg04
    </div>

    <div class="callout-box">
      <strong>Supervisor Question: "Can the inspector correct an AI classification error?"</strong><br>
      <strong>Answer:</strong> <em>"Sir, yes! Clicking any defect on the 2D map opens the high-res crop photo. The inspector can measure flaw dimensions with digital calipers and reclassify the defect, creating an immutable audit log."</em>
    </div>
  </div>

  <!-- SECTION 7: SEQUENCE DIAGRAM — MODULE 5 -->
  <div class="page-break">
    <h2 class="section-header">7. Sequence Diagram &bull; Module 5: Smart Operations &amp; ASTM 4-Point Grading <span class="subtag">Joint Module</span></h2>
    <p class="diagram-desc">Standard quality grading execution: ASTM D5430-07 penalty calculation (1-4 points, max 4 per meter), area normalization per 100m², roll grade assignment, and SHA-256 PDF signing.</p>
    
    <div class="diagram-frame">
      $svg05
    </div>

    <div class="callout-box">
      <strong>Supervisor Question: "How is ASTM 4-point grading calculated mathematically?"</strong><br>
      <strong>Answer:</strong> <em>"Sir, flaws are assigned 1 to 4 points based on length. Points per 100 square meters are calculated as (Total Points &times; 10,000) / (Roll Length &times; Fabric Width). Under 20 points is Grade A; under 40 is Grade B; above 40 is Scrap."</em>
    </div>
  </div>

  <!-- SECTION 8: UML CLASS DIAGRAM -->
  <div class="page-break">
    <h2 class="section-header">8. Comprehensive UML Class Diagram <span class="subtag">Domain Model</span></h2>
    <p class="diagram-desc">Domain object model showing attributes, data types, public methods, and explicit multiplicities (1-to-1, 1-to-many) across core system classes.</p>
    
    <div class="diagram-frame">
      $svg06
    </div>

    <div class="callout-box">
      <strong>Key Relationships to Explain to Sir:</strong><br>
      &bull; <strong>FabricRoll (1) &mdash; (*) DefectRecord:</strong> One roll contains zero or many detected defects.<br>
      &bull; <strong>FabricRoll (1) &mdash; (*) UninspectedSpan:</strong> One roll contains zero or many flagged uninspected intervals.<br>
      &bull; <strong>FabricRoll (1) &mdash; (1) ASTMPenaltyCalculator:</strong> Each roll is evaluated by the ASTM grading engine.<br>
      &bull; <strong>UserAccount (1) &mdash; (*) FabricRoll:</strong> One operator or inspector supervises multiple rolls.
    </div>
  </div>

  <!-- SECTION 9: TALKING POINTS -->
  <div class="page-break">
    <h2 class="section-header">9. Meeting Presentation Guide for Dr. Tassawar Iqbal <span class="subtag">Speech Script</span></h2>
    
    <div style="background:#f8fafc; border:1px solid #cbd5e1; border-radius:6px; padding:10px 14px; margin-bottom:8px;">
      <h3 style="margin:0 0 6px 0; color:#0369a1; font-size:10pt;">How to Open Your Presentation:</h3>
      <p style="margin:0; font-style:italic; font-size:8.5pt;">
        "Respected Sir, today we are presenting the rough workflow and complete technical architecture for TexEye AI. We have structured our system strictly into the 5 proposal modules you approved, with clear allocation between Bilal and Afnan. Here is our rough workflow on paper..."
      </p>
    </div>

    <table class="data-table">
      <thead>
        <tr>
          <th style="width: 25%;">Section</th>
          <th style="width: 35%;">What You Show on Paper</th>
          <th style="width: 40%;">What You Say to Dr. Tassawar Iqbal</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>1. Rough Workflow</strong></td>
          <td>The 4 horizontal stages (QR Scan &rarr; Sensing &amp; Reliability Gate &rarr; Edge AI &amp; SQLite &rarr; Cloud &amp; ASTM PDF).</td>
          <td>"Sir, this is our end-to-end flow. The physical inspection runs on the stand PC with zero lag, while the cloud backend handles central grading and reports."</td>
        </tr>
        <tr>
          <td><strong>2. Module 1 (AI Detection)</strong></td>
          <td>Sequence 1: Camera &rarr; YOLO &rarr; Encoder &rarr; Kalman &rarr; SQLite.</td>
          <td>"Sir, Bilal trained YOLO for flaw detection and combined it with an optical rotary encoder to get exact millimeter coordinates, deduplicating with Kalman filtering."</td>
        </tr>
        <tr>
          <td><strong>3. Module 2 (Hardware Guard)</strong></td>
          <td>Sequence 2: Lux &lt; 800 / Blur &rarr; Amber Light + Siren &rarr; Uninspected Span.</td>
          <td>"Sir, this is our reliability guarantee. If lighting fails or camera drops, we actuate an amber light and record the exact span [Y1, Y2] as uninspected."</td>
        </tr>
        <tr>
          <td><strong>4. Module 3 (Mobile App)</strong></td>
          <td>Sequence 3: QR Scan &rarr; Live Speed &rarr; Haptic Vibration Alert.</td>
          <td>"Sir, Afnan built the Flutter mobile app so floor operators get instant vibration alerts when a defect occurs without having to look at a PC monitor."</td>
        </tr>
        <tr>
          <td><strong>5. Module 4 (Web Dashboard)</strong></td>
          <td>Sequence 4: 2D Canvas Map &rarr; Crop Gallery Zoom &rarr; Reclassification.</td>
          <td>"Sir, the web dashboard renders the entire roll on an interactive canvas. The inspector can measure flaws with digital calipers and correct tags."</td>
        </tr>
        <tr>
          <td><strong>6. Module 5 (Smart Operations)</strong></td>
          <td>Sequence 5: ASTM D5430 rule &rarr; Grade A/B/Scrap &rarr; Signed PDF.</td>
          <td>"Sir, we implement standard ASTM D5430 4-point rules. Total points per 100m² determine Grade A, B, or Scrap, sealed with a cryptographic SHA-256 hash."</td>
        </tr>
        <tr>
          <td><strong>7. Class Diagram</strong></td>
          <td>Class Diagram showing FabricRoll, DefectRecord, Multiplicities (1 to *).</td>
          <td>"Sir, our domain model clearly separates physical rolls, defect records, uninspected intervals, and grading engines with strict relational integrity."</td>
        </tr>
      </tbody>
    </table>

    <div style="margin-top:6mm; padding:10px 14px; background:#f0fdf4; border:1px solid #86efac; border-radius:6px; text-align:center;">
      <strong style="color:#15803d; font-size:9.5pt;">&check; Ready for Supervisor Review &bull; COMSATS University Islamabad</strong><br>
      <span style="font-size:8pt; color:#166534;">All individual SVG, PNG, and PDF files are saved in <code>diagrams/modules/</code> and pushed to GitHub main branch.</span>
    </div>
  </div>

</body>
</html>
"@

$guideHtmlPath = Join-Path $docsDir "TexEye_AI_Supervisor_Meeting_Rough_Workflow_and_UML_Guide.html"
$guidePdfPath = Join-Path $docsDir "TexEye_AI_Supervisor_Meeting_Rough_Workflow_and_UML_Guide.pdf"
[IO.File]::WriteAllText($guideHtmlPath, $html, [Text.Encoding]::UTF8)

Write-Host "Compiling Supervisor Meeting Master PDF..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $edgeExe -ArgumentList @(
    "--headless", "--disable-gpu", "--run-all-compositor-stages-before-draw",
    "--no-pdf-header-footer", "--print-to-pdf=$guidePdfPath",
    "file:///$($guideHtmlPath.Replace('\', '/'))"
) -Wait -PassThru -NoNewWindow

Write-Host "Master Meeting PDF compiled: $((Get-Item $guidePdfPath).Length) bytes" -ForegroundColor Green
