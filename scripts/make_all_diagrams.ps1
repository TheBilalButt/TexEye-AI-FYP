# make_all_diagrams.ps1
# Complete generator for Diagrams 2 through 7
$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$workflowDir = Join-Path $projectRoot "diagrams\workflow"
$pdfDir = Join-Path $workflowDir "pdf"
$pngDir = Join-Path $workflowDir "png"
$docsDir = Join-Path $projectRoot "docs"

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) { $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }

function Compile-Diagram {
    param(
        [string]$Name,
        [string]$SvgContent,
        [string]$Title,
        [string]$Subtitle,
        [string]$ExplanationHtml
    )

    $svgPath = Join-Path $workflowDir "$Name.svg"
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
        <strong>TexEye AI</strong> &bull; FYP Architecture Series<br>
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

    $htmlPath = Join-Path $workflowDir "$Name.html"
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
        "--window-size=1400,920", "--screenshot=$pngPath",
        "file:///$($htmlPath.Replace('\', '/'))"
    ) -Wait -PassThru -NoNewWindow

    Write-Host "$Name compiled: PDF=$((Get-Item $pdfPath).Length) bytes, PNG=$((Get-Item $pngPath).Length) bytes" -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# DIAGRAM 2: Frontend Architecture
# ------------------------------------------------------------------------------
$svg2 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Frontend Architecture &amp; Client Interaction Flow</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Complete Component Hierarchy for Mobile Floor Application &amp; Web Quality Management Dashboard</text>

  <!-- Left: Mobile Floor App Container -->
  <rect x="25" y="75" width="620" height="460" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="82" width="280" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="172" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">MOBILE FLOOR APP (Flutter / Android)</text>

  <!-- Screen S-01 -->
  <rect x="45" y="120" width="270" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="180" y="142" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">S-01: QR Roll Scanner</text>
  <text x="180" y="158" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Camera Viewfinder &amp; Torch Toggle</text>
  <text x="180" y="172" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Batch ID, Article, GSM Metadata Card</text>
  <text x="180" y="186" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">&bull; Action: 'Start Inspection Run'</text>

  <!-- Screen S-02 -->
  <rect x="355" y="120" width="270" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="490" y="142" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">S-02: Live Floor Monitor</text>
  <text x="490" y="158" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Real-Time Fabric Speed Gauge (m/min)</text>
  <text x="490" y="172" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Cumulative Length Counter &amp; Flaw Count</text>
  <text x="490" y="186" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Recent Defect Thumbnail &amp; Pause/Stop</text>

  <!-- Screen S-03 -->
  <rect x="45" y="240" width="270" height="85" fill="#fff1f2" stroke="#e11d48" stroke-width="1.3" rx="6"/>
  <text x="180" y="262" font-size="11" font-weight="bold" fill="#9f1239" text-anchor="middle">S-03: Urgent Alarm Modal</text>
  <text x="180" y="278" font-size="8.5" fill="#be123c" text-anchor="middle">&bull; High-Contrast Red Warning Banner</text>
  <text x="180" y="292" font-size="8.5" fill="#be123c" text-anchor="middle">&bull; Device Haptic Vibration Pulse</text>
  <text x="180" y="306" font-size="8.5" fill="#be123c" text-anchor="middle">&bull; Action: 'Acknowledge &amp; Silence'</text>

  <!-- Screen S-04 -->
  <rect x="355" y="240" width="270" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="490" y="262" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">S-04: Manual Flaw Tag Sheet</text>
  <text x="490" y="278" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Quick-Tag: Selvage Curl, Shading</text>
  <text x="490" y="292" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Foreign Yarn, Oil Spot, Hole Buttons</text>
  <text x="490" y="306" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Stamped with Current Pulses / Meter</text>

  <!-- Local Mobile Storage -->
  <rect x="180" y="360" width="310" height="50" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="5"/>
  <text x="335" y="381" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">Mobile Local Storage (SQLite / SharedPrefs)</text>
  <text x="335" y="396" font-size="8" fill="#475569" text-anchor="middle">Caches Offline Rolls, Session State &amp; JWT Credentials</text>

  <!-- Right: Web Management Dashboard Container -->
  <rect x="675" y="75" width="620" height="460" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="682" y="82" width="320" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="842" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">WEB QUALITY DASHBOARD (React.js SPA)</text>

  <!-- Screen S-05 & S-06 -->
  <rect x="695" y="120" width="275" height="75" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="832" y="142" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">S-05: Sign-In &amp; Role-Based Access</text>
  <text x="832" y="158" font-size="8.5" fill="#334155" text-anchor="middle">&bull; JWT Token Issuance &amp; Route Guard</text>
  <text x="832" y="172" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Roles: Operator, Inspector, Manager, Admin</text>

  <rect x="1005" y="120" width="270" height="75" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="1140" y="142" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">S-06: Inspected Rolls Master Table</text>
  <text x="1140" y="158" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Filter by Batch, Date, Shift, Grade</text>
  <text x="1140" y="172" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Roll Length, Defect Count, Sync Status</text>

  <!-- Screen S-07 & S-08 -->
  <rect x="695" y="215" width="275" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="832" y="237" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">S-07: Interactive 2D Defect Map</text>
  <text x="832" y="253" font-size="8.5" fill="#334155" text-anchor="middle">&bull; HTML5 Canvas Full Fabric Roll Web</text>
  <text x="832" y="267" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Color-Coded Defect Glyphs by Class</text>
  <text x="832" y="281" font-size="8.5" fill="#e11d48" font-weight="bold" text-anchor="middle">&bull; Highlighted Uninspected Hazard Spans</text>

  <rect x="1005" y="215" width="270" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="1140" y="237" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">S-08: Defect Review Gallery</text>
  <text x="1140" y="253" font-size="8.5" fill="#334155" text-anchor="middle">&bull; High-Res Defect Crop Zoom Viewer</text>
  <text x="1140" y="267" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Digital Calipers &amp; AI Confidence Bar</text>
  <text x="1140" y="281" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&bull; Reclassification Dropdown Selector</text>

  <!-- Screen S-09 & S-10 -->
  <rect x="695" y="320" width="275" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="832" y="342" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">S-09: ASTM 4-Point Scorecard</text>
  <text x="832" y="358" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Automated Points Breakdown (1, 2, 3, 4)</text>
  <text x="832" y="372" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 1-Meter Capping Calculation Engine</text>
  <text x="832" y="386" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">&bull; Roll Grade Badge: Grade A, B, or Scrap</text>

  <rect x="1005" y="320" width="270" height="85" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.3" rx="6"/>
  <text x="1140" y="342" font-size="10.5" font-weight="bold" fill="#15803d" text-anchor="middle">S-10: Certificate &amp; Export Hub</text>
  <text x="1140" y="358" font-size="8.5" fill="#166534" text-anchor="middle">&bull; PDF Quality Certificate Preview &amp; Print</text>
  <text x="1140" y="372" font-size="8.5" fill="#166534" text-anchor="middle">&bull; ERP CSV / JSON Batch Export</text>
  <text x="1140" y="386" font-size="8.5" fill="#166534" font-weight="bold" text-anchor="middle">&bull; Cryptographic SHA-256 Audit Seal</text>

  <!-- Bottom: Frontend-to-Backend Communication Bus -->
  <rect x="25" y="555" width="1270" height="190" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="562" width="340" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="202" y="578" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">FRONTEND-TO-BACKEND COMMUNICATION BUS</text>

  <!-- Channel 1: HTTPS REST API -->
  <rect x="55" y="605" width="360" height="115" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="235" y="628" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">HTTPS REST API Adapter (Axios / Fetch)</text>
  <text x="235" y="647" font-size="8.5" fill="#334155" text-anchor="middle">&bull; POST /api/v1/session/start (QR Initialization)</text>
  <text x="235" y="662" font-size="8.5" fill="#334155" text-anchor="middle">&bull; GET /api/v1/rolls/{id}/defects (2D Map &amp; Gallery Data)</text>
  <text x="235" y="677" font-size="8.5" fill="#334155" text-anchor="middle">&bull; PATCH /api/v1/defects/{id} (Defect Reclassification)</text>
  <text x="235" y="692" font-size="8.5" fill="#334155" text-anchor="middle">&bull; GET /api/v1/reports/{id}/pdf (Download Certificate)</text>

  <!-- Channel 2: WebSocket Real-Time Adapter -->
  <rect x="475" y="605" width="370" height="115" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="660" y="628" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">WebSocket Adapter (WSS / Socket.io)</text>
  <text x="660" y="647" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Event: 'defect_detected' &rarr; Instant Mobile Vibration</text>
  <text x="660" y="662" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Event: 'encoder_tick' &rarr; Real-Time Speed &amp; Length</text>
  <text x="660" y="677" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Event: 'hardware_fault' &rarr; Amber Warning Trigger</text>
  <text x="660" y="692" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Event: 'sync_status' &rarr; Edge Stand Connectivity State</text>

  <!-- Channel 3: Offline Sync Engine -->
  <rect x="905" y="605" width="370" height="115" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="1090" y="628" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Offline Synchronization Engine</text>
  <text x="1090" y="647" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Network Connectivity Ping / Heartbeat Monitor</text>
  <text x="1090" y="662" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Transactional Queue Drain (Auto-Sync upon Reconnect)</text>
  <text x="1090" y="677" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Optimistic UI Updates &amp; Conflict Resolution</text>
  <text x="1090" y="692" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Zero Factory Downtime During Cloud Internet Loss</text>

  <!-- Bottom Legend -->
  <rect x="25" y="760" width="1270" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="780" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (Frontend Architecture):</text>
  <text x="40" y="798" font-size="8.5" fill="#334155">&bull; 2 Independent Frontends: Left is Mobile Floor App (Flutter) for Floor Operator; Right is Web Dashboard (React) for Quality Manager &amp; Inspector.</text>
  <text x="40" y="814" font-size="8.5" fill="#334155">&bull; 2 Communication Modes: REST API handles static queries, logins, and PDF downloads; WebSockets handle real-time speed, live flaw alerts, and buzzer states.</text>
</svg>
"@

$exp2 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Draw and Explain Frontend Architecture to Your Supervisor:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Two Separate Client Applications</strong>
          Explain: "Sir, we have two clients tailored for distinct floor roles: A Flutter Mobile App for the floor operator moving along the stand, and a React Web Dashboard for the quality manager in the inspection office."
        </div>
        <div class="exp-col">
          <strong>2. Real-Time WebSocket Alerts</strong>
          Explain: "Sir, when the AI model detects a defect, the operator does not refresh the page. A WebSocket event triggers instant haptic vibration on the mobile phone and displays a high-contrast alarm modal."
        </div>
        <div class="exp-col">
          <strong>3. Interactive 2D Map &amp; ASTM Grading</strong>
          Explain: "The manager sees the entire fabric roll rendered on an HTML5 canvas map with exact metric locations (X cm, Y m), uninspected spans, and an automated ASTM 4-point scorecard ready for PDF certificate export."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "02_frontend_architecture" -SvgContent $svg2 -Title "Diagram 2: Frontend Architecture & Client Interaction Flow" -Subtitle "Screen Hierarchies, User Interactions, and Dual-Protocol (REST & WebSocket) Communication Layer" -ExplanationHtml $exp2

# ------------------------------------------------------------------------------
# DIAGRAM 3: Backend Architecture
# ------------------------------------------------------------------------------
$svg3 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Backend Architecture &amp; Service Decomposition</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Separation of Concerns between Stand Edge Backend (Python) and Central Cloud Backend (FastAPI)</text>

  <!-- Left: Edge Stand Backend -->
  <rect x="25" y="75" width="620" height="665" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="82" width="340" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="202" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">EDGE STAND BACKEND (Local Python Service)</text>

  <!-- Subsystem 1: Hardware Abstraction Layer -->
  <rect x="45" y="120" width="580" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="60" y="140" font-size="10.5" font-weight="bold" fill="#0369a1">1. Hardware Abstraction &amp; Ingestion Subsystem</text>
  
  <rect x="60" y="150" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="145" y="170" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Camera Ingester</text>
  <text x="145" y="186" font-size="8" fill="#475569" text-anchor="middle">&bull; OpenCV / V4L2</text>
  <text x="145" y="199" font-size="8" fill="#475569" text-anchor="middle">&bull; 1080p @ 30-60 FPS</text>
  <text x="145" y="212" font-size="8" fill="#475569" text-anchor="middle">&bull; Frame Buffer Ring</text>

  <rect x="250" y="150" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="335" y="170" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Encoder Driver</text>
  <text x="335" y="186" font-size="8" fill="#475569" text-anchor="middle">&bull; GPIO / Serial Interrupts</text>
  <text x="335" y="199" font-size="8" fill="#475569" text-anchor="middle">&bull; Optical 1000 PPR</text>
  <text x="335" y="212" font-size="8" fill="#475569" text-anchor="middle">&bull; Pulse &rarr; mm Conversion</text>

  <rect x="440" y="150" width="170" height="75" fill="#fff1f2" stroke="#fca5a5" stroke-width="1" rx="4"/>
  <text x="525" y="170" font-size="9.5" font-weight="bold" fill="#9f1239" text-anchor="middle">Reliability Guard</text>
  <text x="525" y="186" font-size="8" fill="#be123c" text-anchor="middle">&bull; Lux Level &lt; 800 Check</text>
  <text x="525" y="199" font-size="8" fill="#be123c" text-anchor="middle">&bull; Laplacian Blur Detector</text>
  <text x="525" y="212" font-size="8" fill="#be123c" text-anchor="middle">&bull; Dropped Frame Sentinel</text>

  <!-- Subsystem 2: Edge AI & Tracking -->
  <rect x="45" y="255" width="580" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="60" y="275" font-size="10.5" font-weight="bold" fill="#0369a1">2. Edge AI Inference &amp; Deduplication Engine</text>

  <rect x="60" y="285" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="145" y="305" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">YOLO Inference</text>
  <text x="145" y="321" font-size="8" fill="#475569" text-anchor="middle">&bull; Fabric Defect Model</text>
  <text x="145" y="334" font-size="8" fill="#475569" text-anchor="middle">&bull; Flaw Bounding Box</text>
  <text x="145" y="347" font-size="8" fill="#475569" text-anchor="middle">&bull; Class Conf &gt; 0.65</text>

  <rect x="250" y="285" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="335" y="305" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Metric Localization</text>
  <text x="335" y="321" font-size="8" fill="#475569" text-anchor="middle">&bull; Pixel-to-mm Mapping</text>
  <text x="335" y="334" font-size="8" fill="#475569" text-anchor="middle">&bull; X Across Width (cm)</text>
  <text x="335" y="347" font-size="8" fill="#475569" text-anchor="middle">&bull; Y Along Length (m)</text>

  <rect x="440" y="285" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="525" y="305" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Kalman Deduplicator</text>
  <text x="525" y="321" font-size="8" fill="#475569" text-anchor="middle">&bull; Multi-Frame Tracking</text>
  <text x="525" y="334" font-size="8" fill="#475569" text-anchor="middle">&bull; Trajectory Association</text>
  <text x="525" y="347" font-size="8" fill="#475569" text-anchor="middle">&bull; Zero Duplicate Counts</text>

  <!-- Subsystem 3: Local Storage & Sync -->
  <rect x="45" y="390" width="580" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="60" y="410" font-size="10.5" font-weight="bold" fill="#0369a1">3. Local Resilience &amp; Outbox Storage</text>

  <rect x="60" y="420" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="145" y="440" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Local SQLite WAL</text>
  <text x="145" y="456" font-size="8" fill="#475569" text-anchor="middle">&bull; Zero-Delay Commits</text>
  <text x="145" y="469" font-size="8" fill="#475569" text-anchor="middle">&bull; rolls &amp; defects Tables</text>
  <text x="145" y="482" font-size="8" fill="#475569" text-anchor="middle">&bull; uninspected_intervals</text>

  <rect x="250" y="420" width="170" height="75" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="335" y="440" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">NVMe Crop Store</text>
  <text x="335" y="456" font-size="8" fill="#475569" text-anchor="middle">&bull; High-Res JPEG Crops</text>
  <text x="335" y="469" font-size="8" fill="#475569" text-anchor="middle">&bull; 256x256 BBox Region</text>
  <text x="335" y="482" font-size="8" fill="#475569" text-anchor="middle">&bull; Lossless Disk Write</text>

  <rect x="440" y="420" width="170" height="75" fill="#fffbeb" stroke="#fcd34d" stroke-width="1" rx="4"/>
  <text x="525" y="440" font-size="9.5" font-weight="bold" fill="#92400e" text-anchor="middle">Outbox Sync Worker</text>
  <text x="525" y="456" font-size="8" fill="#b45309" text-anchor="middle">&bull; Polling &amp; Heartbeat</text>
  <text x="525" y="469" font-size="8" fill="#b45309" text-anchor="middle">&bull; HTTPS Batch POST</text>
  <text x="525" y="482" font-size="8" fill="#b45309" text-anchor="middle">&bull; Exponential Backoff</text>

  <!-- Subsystem 4: Hardware Relay Controller -->
  <rect x="45" y="525" width="580" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="60" y="545" font-size="10.5" font-weight="bold" fill="#0369a1">4. Physical Actuation &amp; Alarm Controller</text>
  <text x="60" y="565" font-size="8.5" fill="#334155">&bull; USB / GPIO Relay Controller connected to industrial stack light &amp; audible buzzer.</text>
  <text x="60" y="580" font-size="8.5" fill="#334155">&bull; Relays: Relay 1 (Amber Light - Sensor Fault), Relay 2 (Red Light - Critical Flaw), Relay 3 (85dB Audible Siren).</text>
  <text x="60" y="595" font-size="8.5" fill="#334155">&bull; Safety Invariant: Hardware alarm state automatically cleared only on explicit operator acknowledgment.</text>

  <!-- Right: Central Cloud Backend -->
  <rect x="675" y="75" width="620" height="665" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="682" y="82" width="360" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="202" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">CENTRAL ENTERPRISE BACKEND (FastAPI / Cloud)</text>

  <!-- Central Layer 1: API Gateway & Security -->
  <rect x="695" y="120" width="580" height="120" fill="#f8fafc" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="710" y="140" font-size="10.5" font-weight="bold" fill="#0369a1">1. API Gateway, Ingestion &amp; WebSocket Broadcast</text>

  <rect x="710" y="150" width="170" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="795" y="170" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Ingestion REST API</text>
  <text x="795" y="186" font-size="8" fill="#475569" text-anchor="middle">&bull; /api/v1/sync/batch</text>
  <text x="795" y="199" font-size="8" fill="#475569" text-anchor="middle">&bull; Transactional Commit</text>
  <text x="795" y="212" font-size="8" fill="#475569" text-anchor="middle">&bull; High-Throughput JSON</text>

  <rect x="900" y="150" width="170" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="985" y="170" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Auth &amp; RBAC Service</text>
  <text x="985" y="186" font-size="8" fill="#475569" text-anchor="middle">&bull; JWT Token Validation</text>
  <text x="985" y="199" font-size="8" fill="#475569" text-anchor="middle">&bull; Bcrypt Passwords</text>
  <text x="985" y="212" font-size="8" fill="#475569" text-anchor="middle">&bull; Role Permissions Guard</text>

  <rect x="1090" y="150" width="170" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="1175" y="170" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">WebSocket Hub</text>
  <text x="1175" y="186" font-size="8" fill="#475569" text-anchor="middle">&bull; Real-Time Broadcast</text>
  <text x="1175" y="199" font-size="8" fill="#475569" text-anchor="middle">&bull; Multi-Client Fanout</text>
  <text x="1175" y="212" font-size="8" fill="#475569" text-anchor="middle">&bull; Stand Heartbeat Ping</text>

  <!-- Central Layer 2: Business Logic & ASTM Grading -->
  <rect x="695" y="255" width="580" height="120" fill="#f8fafc" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="710" y="275" font-size="10.5" font-weight="bold" fill="#0369a1">2. Quality Computation &amp; Report Intelligence</text>

  <rect x="710" y="285" width="170" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="795" y="305" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">ASTM 4-Point Engine</text>
  <text x="795" y="321" font-size="8" fill="#475569" text-anchor="middle">&bull; Points Formula D5430</text>
  <text x="795" y="334" font-size="8" fill="#475569" text-anchor="middle">&bull; 1-Meter Capping Rule</text>
  <text x="795" y="347" font-size="8" fill="#475569" text-anchor="middle">&bull; Grade A / B / Scrap</text>

  <rect x="900" y="285" width="170" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="985" y="305" font-size="9.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Audit &amp; Review Service</text>
  <text x="985" y="321" font-size="8" fill="#475569" text-anchor="middle">&bull; Flaw Reclassification</text>
  <text x="985" y="334" font-size="8" fill="#475569" text-anchor="middle">&bull; Inspector Timestamp</text>
  <text x="985" y="347" font-size="8" fill="#475569" text-anchor="middle">&bull; Immutable History Log</text>

  <rect x="1090" y="285" width="170" height="75" fill="#f0fdf4" stroke="#86efac" stroke-width="1" rx="4"/>
  <text x="1175" y="305" font-size="9.5" font-weight="bold" fill="#15803d" text-anchor="middle">PDF Certificate Service</text>
  <text x="1175" y="321" font-size="8" fill="#166534" text-anchor="middle">&bull; Vector Document Engine</text>
  <text x="1175" y="334" font-size="8" fill="#166534" text-anchor="middle">&bull; Embedded Defect Table</text>
  <text x="1175" y="347" font-size="8" fill="#166534" text-anchor="middle">&bull; SHA-256 Digital Seal</text>

  <!-- Central Layer 3: Enterprise Persistence -->
  <rect x="695" y="390" width="580" height="120" fill="#f8fafc" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="710" y="410" font-size="10.5" font-weight="bold" fill="#0369a1">3. Enterprise Relational Database &amp; Object Storage</text>

  <rect x="730" y="420" width="240" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="850" y="440" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">PostgreSQL Database</text>
  <text x="850" y="456" font-size="8" fill="#475569" text-anchor="middle">&bull; Normalized Relational Schema</text>
  <text x="850" y="469" font-size="8" fill="#475569" text-anchor="middle">&bull; batches, rolls, defects, audits</text>
  <text x="850" y="482" font-size="8" fill="#475569" text-anchor="middle">&bull; B-Tree Index on (roll_id, Y_m)</text>

  <rect x="1010" y="420" width="240" height="75" fill="#ffffff" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="1130" y="440" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">MinIO Object Store (S3 API)</text>
  <text x="1130" y="456" font-size="8" fill="#475569" text-anchor="middle">&bull; defect-crops-hd/ Bucket</text>
  <text x="1130" y="469" font-size="8" fill="#475569" text-anchor="middle">&bull; inspection-certificates-pdf/ Bucket</text>
  <text x="1130" y="482" font-size="8" fill="#475569" text-anchor="middle">&bull; Pre-Signed URLs for Frontend</text>

  <!-- Central Layer 4: Enterprise Integration -->
  <rect x="695" y="525" width="580" height="85" fill="#f8fafc" stroke="#0f172a" stroke-width="1.2" rx="6"/>
  <text x="710" y="545" font-size="10.5" font-weight="bold" fill="#0369a1">4. ERP Integration &amp; Security Services</text>
  <text x="710" y="565" font-size="8.5" fill="#334155">&bull; ERP Data Exporter: Automated JSON/CSV dispatch to SAP, Oracle Netsuite, or textile ERP.</text>
  <text x="710" y="580" font-size="8.5" fill="#334155">&bull; SHA-256 Hashing Engine: Generates tamper-proof cryptographic audit checksum for every finalized certificate.</text>
  <text x="710" y="595" font-size="8.5" fill="#334155">&bull; Data Retention Policy: Automatic archival of processed rolls while retaining flaw telemetry.</text>

  <!-- Clean Communication Channel Across Backends -->
  <line x1="645" y1="455" x2="675" y2="455" stroke="#2563eb" stroke-width="1.8" marker-end="url(#arr-blue)"/>
  <rect x="625" y="435" width="70" height="16" fill="#eff6ff" stroke="#3b82f6" stroke-width="0.8" rx="3"/>
  <text x="660" y="447" font-size="7.5" font-weight="bold" fill="#1d4ed8" text-anchor="middle">HTTPS Sync</text>

  <!-- Bottom Legend -->
  <rect x="25" y="755" width="1270" height="80" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="775" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (Backend Architecture):</text>
  <text x="40" y="793" font-size="8.5" fill="#334155">&bull; Edge Stand Backend (Left): Runs locally on Stand PC. Owns camera frames, encoder interrupts, YOLO inference, local SQLite buffer, and physical relays.</text>
  <text x="40" y="809" font-size="8.5" fill="#334155">&bull; Central Cloud Backend (Right): Runs FastAPI. Owns cloud sync ingestion, PostgreSQL, MinIO storage, automated ASTM 4-point grading, and PDF report creation.</text>
</svg>
"@

$exp3 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Draw and Explain Backend Architecture to Your Supervisor:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Stand Edge Backend (Left Box)</strong>
          Explain: "Sir, on the inspection stand itself, we run a lightweight local Python backend. It handles real-time tasks: camera frames, rotary encoder pulses, YOLO defect inference, and local SQLite caching."
        </div>
        <div class="exp-col">
          <strong>2. Central Cloud Backend (Right Box)</strong>
          Explain: "Sir, in the cloud or factory server, we run a FastAPI server. It receives synced batches, manages PostgreSQL and MinIO storage, runs the ASTM D5430 grading engine, and generates PDF certificates."
        </div>
        <div class="exp-col">
          <strong>3. Complete Edge Autonomy</strong>
          Explain: "Even if the network cable to the cloud server is cut, the stand edge backend never halts. It continues inspecting fabric, triggers local stack lights, and saves records into SQLite."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "03_backend_architecture" -SvgContent $svg3 -Title "Diagram 3: Backend Architecture & Service Decomposition" -Subtitle "Physical Separation of Edge Inspection Stand Services and Central Enterprise Cloud Backend" -ExplanationHtml $exp3

# ------------------------------------------------------------------------------
# DIAGRAM 4: Database Workflow
# ------------------------------------------------------------------------------
$svg4 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
    <marker id="arr-amber" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#d97706"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Database Workflow &amp; Offline-to-Cloud Data Pipeline</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Complete Data Lifecycle: Edge SQLite Buffer &rarr; Transactional Outbox &rarr; Central PostgreSQL &amp; MinIO &rarr; Analytical Queries</text>

  <!-- Tier 1: Edge Local Buffer -->
  <rect x="25" y="75" width="1270" height="150" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="82" width="280" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="172" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">1. EDGE STAND LOCAL STORAGE (Zero-Latency)</text>

  <rect x="50" y="115" width="270" height="95" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="185" y="135" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">SQLite Table: rolls_active</text>
  <text x="185" y="152" font-size="8.5" fill="#334155" text-anchor="middle">&bull; roll_id (UUID, PK), batch_id</text>
  <text x="185" y="166" font-size="8.5" fill="#334155" text-anchor="middle">&bull; start_time, end_time, total_length_m</text>
  <text x="185" y="180" font-size="8.5" fill="#334155" text-anchor="middle">&bull; operator_id, stand_id, status</text>
  <text x="185" y="195" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">[INSERT on QR Scan]</text>

  <rect x="360" y="115" width="270" height="95" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="495" y="135" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">SQLite Table: defects_local</text>
  <text x="495" y="152" font-size="8.5" fill="#334155" text-anchor="middle">&bull; defect_id (UUID, PK), roll_id (FK)</text>
  <text x="495" y="166" font-size="8.5" fill="#334155" text-anchor="middle">&bull; X_coord_cm, Y_coord_m, flaw_class</text>
  <text x="495" y="180" font-size="8.5" fill="#334155" text-anchor="middle">&bull; confidence, crop_file_path</text>
  <text x="495" y="195" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">[INSERT on AI Detection]</text>

  <rect x="670" y="115" width="270" height="95" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="805" y="135" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">SQLite Table: uninspected_spans</text>
  <text x="805" y="152" font-size="8.5" fill="#334155" text-anchor="middle">&bull; span_id (UUID, PK), roll_id (FK)</text>
  <text x="805" y="166" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Y_start_m, Y_end_m, reason_code</text>
  <text x="805" y="180" font-size="8.5" fill="#334155" text-anchor="middle">&bull; lux_val, blur_score, timestamp</text>
  <text x="805" y="195" font-size="8.5" fill="#be123c" font-weight="bold" text-anchor="middle">[INSERT on Sensor Fault]</text>

  <rect x="980" y="115" width="270" height="95" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="1115" y="135" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Local NVMe Disk Image Store</text>
  <text x="1115" y="152" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Path: /data/crops/{roll_id}/</text>
  <text x="1115" y="166" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Format: High-Res JPEG (256x256)</text>
  <text x="1115" y="180" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Indexed by defect_id.jpg</text>
  <text x="1115" y="195" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">[Direct File System Write]</text>

  <!-- Tier 2: Transactional Outbox State Machine -->
  <rect x="25" y="240" width="1270" height="130" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="247" width="310" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="187" y="263" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">2. TRANSACTIONAL OUTBOX SYNC STATE MACHINE</text>

  <!-- Start Circle -->
  <circle cx="80" cy="305" r="8" fill="#0f172a"/>
  
  <line x1="88" y1="305" x2="190" y2="305" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>
  <rect x="100" y="290" width="75" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="137" y="301" font-size="7.5" font-weight="bold" fill="#0f172a" text-anchor="middle">insert_event</text>

  <!-- State 1: PENDING -->
  <rect x="190" y="280" width="180" height="50" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="5"/>
  <text x="280" y="300" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">PENDING</text>
  <text x="280" y="316" font-size="8" fill="#475569" text-anchor="middle">Committed in SQLite Buffer</text>

  <!-- State 2: IN_FLIGHT -->
  <line x1="370" y1="305" x2="490" y2="305" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>
  <rect x="385" y="290" width="90" height="15" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="430" y="301" font-size="7.5" font-weight="bold" fill="#0f172a" text-anchor="middle">net_online &amp; send</text>

  <rect x="490" y="280" width="180" height="50" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="5"/>
  <text x="580" y="300" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">IN_FLIGHT</text>
  <text x="580" y="316" font-size="8" fill="#475569" text-anchor="middle">HTTPS POST Payload Active</text>

  <!-- Retry Backoff -->
  <path d="M 580 330 L 580 355 L 280 355 L 280 330" fill="none" stroke="#d97706" stroke-width="1.3" marker-end="url(#arr-amber)"/>
  <rect x="360" y="347" width="145" height="16" fill="#fffbeb" stroke="#d97706" rx="3"/>
  <text x="432" y="359" font-size="7.5" font-weight="bold" fill="#92400e" text-anchor="middle">timeout / net_fail [backoff retry &lt; 5]</text>

  <!-- State 3: SYNCED -->
  <line x1="670" y1="305" x2="790" y2="305" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="690" y="290" width="80" height="15" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="730" y="301" font-size="7.5" font-weight="bold" fill="#15803d" text-anchor="middle">HTTP 200 OK</text>

  <rect x="790" y="280" width="180" height="50" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.3" rx="5"/>
  <text x="880" y="300" font-size="10.5" font-weight="bold" fill="#15803d" text-anchor="middle">SYNCED</text>
  <text x="880" y="316" font-size="8" fill="#166534" text-anchor="middle">Marked complete in outbox</text>

  <!-- Terminal Circle -->
  <line x1="970" y1="305" x2="1030" y2="305" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>
  <circle cx="1040" cy="305" r="9" fill="none" stroke="#0f172a" stroke-width="1.3"/>
  <circle cx="1040" cy="305" r="5" fill="#0f172a"/>
  <text x="1110" y="309" font-size="8.5" fill="#475569">Archived after 7 Days</text>

  <!-- Tier 3: Central Enterprise DB & Object Storage -->
  <rect x="25" y="385" width="1270" height="175" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="392" width="310" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="187" y="408" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">3. CENTRAL ENTERPRISE DATA PERSISTENCE</text>

  <!-- PostgreSQL Master Tables -->
  <rect x="50" y="425" width="360" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="230" y="445" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">PostgreSQL: Master Roll &amp; Defect Tables</text>
  <text x="230" y="465" font-size="8.5" fill="#334155" text-anchor="middle">&bull; fabric_rolls: roll_id, batch_id, length_m, grade, astm_points</text>
  <text x="230" y="482" font-size="8.5" fill="#334155" text-anchor="middle">&bull; detected_defects: defect_id, roll_id, X_cm, Y_m, class, verified_class</text>
  <text x="230" y="499" font-size="8.5" fill="#334155" text-anchor="middle">&bull; uninspected_spans: span_id, roll_id, Y_start, Y_end, fault_type</text>
  <text x="230" y="516" font-size="8.5" fill="#334155" text-anchor="middle">&bull; audit_logs: audit_id, defect_id, changed_by, old_class, new_class</text>

  <!-- MinIO S3 Object Buckets -->
  <rect x="450" y="425" width="360" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="630" y="445" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">MinIO Object Store (S3 Buckets)</text>
  <text x="630" y="465" font-size="8.5" fill="#334155" text-anchor="middle">&bull; defect-crops-hd/roll_{id}/{defect_id}.jpg (256x256 Crop)</text>
  <text x="630" y="482" font-size="8.5" fill="#334155" text-anchor="middle">&bull; inspection-certificates-pdf/cert_{roll_id}.pdf (Official PDF)</text>
  <text x="630" y="499" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Immutable Object Lock &amp; Fast CDN Cache Header</text>
  <text x="630" y="516" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Pre-Signed URL Access with 60-Minute Expiry</text>

  <!-- ASTM Scoring Record -->
  <rect x="850" y="425" width="400" height="120" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="1050" y="445" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">PostgreSQL: astm_scorecards Table</text>
  <text x="1050" y="465" font-size="8.5" fill="#334155" text-anchor="middle">&bull; roll_id (FK), pts_1 (length &lt; 75mm), pts_2 (75-150mm)</text>
  <text x="1050" y="482" font-size="8.5" fill="#334155" text-anchor="middle">&bull; pts_3 (150-230mm), pts_4 (&gt; 230mm or holes &gt; 25mm)</text>
  <text x="1050" y="499" font-size="8.5" fill="#334155" text-anchor="middle">&bull; points_per_100_sqm = (Total Points &times; 10000) / (Length &times; Width)</text>
  <text x="1050" y="516" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">&bull; Grade Threshold: Grade A (&le; 20 pts), Grade B (&le; 40), Scrap (&gt; 40)</text>

  <!-- Tier 4: Query & CRUD Patterns -->
  <rect x="25" y="575" width="1270" height="165" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="582" width="280" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="172" y="598" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">4. CRUD ACCESS PATTERNS &amp; CONSUMERS</text>

  <rect x="50" y="615" width="280" height="105" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="190" y="635" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">Pattern 1: 2D Defect Map Render</text>
  <text x="190" y="655" font-size="8" fill="#334155" text-anchor="middle">SELECT X_cm, Y_m, class</text>
  <text x="190" y="670" font-size="8" fill="#334155" text-anchor="middle">FROM detected_defects</text>
  <text x="190" y="685" font-size="8" fill="#334155" text-anchor="middle">WHERE roll_id = :id ORDER BY Y_m;</text>
  <text x="190" y="705" font-size="8" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Consumer: Web Canvas View</text>

  <rect x="360" y="615" width="280" height="105" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="500" y="635" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">Pattern 2: Defect Reclassification</text>
  <text x="500" y="655" font-size="8" fill="#334155" text-anchor="middle">UPDATE detected_defects</text>
  <text x="500" y="670" font-size="8" fill="#334155" text-anchor="middle">SET verified_class = :new_class,</text>
  <text x="500" y="685" font-size="8" fill="#334155" text-anchor="middle">reviewed_by = :inspector_id;</text>
  <text x="500" y="705" font-size="8" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Consumer: Quality Inspector Review</text>

  <rect x="670" y="615" width="280" height="105" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="810" y="635" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">Pattern 3: ASTM Finalization</text>
  <text x="810" y="655" font-size="8" fill="#334155" text-anchor="middle">UPDATE fabric_rolls</text>
  <text x="810" y="670" font-size="8" fill="#334155" text-anchor="middle">SET grade = 'Grade A',</text>
  <text x="810" y="685" font-size="8" fill="#334155" text-anchor="middle">astm_points = :computed_points;</text>
  <text x="810" y="705" font-size="8" fill="#16a34a" font-weight="bold" text-anchor="middle">&rarr; Consumer: Smart Operations Engine</text>

  <rect x="980" y="615" width="270" height="105" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="1115" y="635" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">Pattern 4: PDF Report Generation</text>
  <text x="1115" y="655" font-size="8" fill="#334155" text-anchor="middle">JOIN fabric_rolls, batches,</text>
  <text x="1115" y="670" font-size="8" fill="#334155" text-anchor="middle">detected_defects, scorecards</text>
  <text x="1115" y="685" font-size="8" fill="#334155" text-anchor="middle">Render vector PDF &amp; store S3;</text>
  <text x="1115" y="705" font-size="8" fill="#16a34a" font-weight="bold" text-anchor="middle">&rarr; Consumer: Quality Manager Export</text>

  <!-- Bottom Legend -->
  <rect x="25" y="755" width="1270" height="80" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="775" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (Database Workflow):</text>
  <text x="40" y="793" font-size="8.5" fill="#334155">&bull; Offline-First Guarantee: Inspection never waits for cloud database latency. Detections write instantly to local SQLite WAL file.</text>
  <text x="40" y="809" font-size="8.5" fill="#334155">&bull; Outbox State Machine: PENDING &rarr; IN_FLIGHT &rarr; SYNCED. Guarantees at-least-once delivery with zero data loss even across power outages.</text>
</svg>
"@

$exp4 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Draw and Explain Database Workflow to Your Supervisor:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Local SQLite First (Tier 1)</strong>
          Explain: "Sir, we use an Offline-First pattern. The inspection stand writes all roll data, defect coordinates, and uninspected spans to local SQLite instantly so the physical fabric winder never has to stop."
        </div>
        <div class="exp-col">
          <strong>2. Transactional Outbox (Tier 2)</strong>
          Explain: "Sir, a background worker monitors an outbox table. When factory Wi-Fi is active, it POSTs batches to the cloud server and marks them SYNCED. If network drops, it retries with exponential backoff."
        </div>
        <div class="exp-col">
          <strong>3. Cloud PostgreSQL &amp; MinIO (Tier 3)</strong>
          Explain: "In the cloud, metadata resides in normalized PostgreSQL tables while high-resolution defect crop photos are stored in MinIO object storage. The web dashboard reads from this central store."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "04_database_workflow" -SvgContent $svg4 -Title "Diagram 4: Database Workflow & Offline-to-Cloud Data Pipeline" -Subtitle "Transactional Outbox Pattern, Relational Schemas, and High-Resolution Object Storage Architecture" -ExplanationHtml $exp4

# ------------------------------------------------------------------------------
# DIAGRAM 5: Complete Closed-Loop System Flow
# ------------------------------------------------------------------------------
$svg5 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-red" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#dc2626"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Complete Closed-Loop System Flow</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Step-by-Step Execution Trace: User &rarr; Frontend &rarr; Stand Backend &rarr; Edge DB &rarr; Central DB &rarr; Web Frontend &rarr; Supervisor/User</text>

  <!-- Step 1: User Action -->
  <rect x="40" y="85" width="220" height="75" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="50" y="93" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="85" y="106" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 1</text>
  <text x="150" y="125" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Floor Operator</text>
  <text x="150" y="142" font-size="8.5" fill="#334155" text-anchor="middle">Scans QR tag on fabric roll</text>

  <!-- Step 2: Mobile App Frontend -->
  <line x1="260" y1="122" x2="310" y2="122" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>
  
  <rect x="310" y="85" width="220" height="75" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="320" y="93" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="355" y="106" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 2</text>
  <text x="420" y="125" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Mobile Frontend</text>
  <text x="420" y="142" font-size="8.5" fill="#334155" text-anchor="middle">Sends POST /session/start</text>

  <!-- Step 3: Stand Edge Backend -->
  <line x1="530" y1="122" x2="580" y2="122" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <rect x="580" y="85" width="220" height="75" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="590" y="93" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="625" y="106" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 3</text>
  <text x="690" y="125" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Stand Backend</text>
  <text x="690" y="142" font-size="8.5" fill="#334155" text-anchor="middle">Zeros encoder &amp; starts sensors</text>

  <!-- Step 4: Decision: Reliable? -->
  <line x1="800" y1="122" x2="850" y2="122" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <polygon points="850,122 915,92 980,122 915,152" fill="#ffffff" stroke="#0f172a" stroke-width="1.5"/>
  <text x="915" y="119" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">Reliable?</text>
  <text x="915" y="132" font-size="8" fill="#64748b" text-anchor="middle">(Lux/Blur/FPS)</text>

  <!-- Step 4 Fault Branch (Right) -->
  <line x1="980" y1="122" x2="1050" y2="122" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-red)"/>
  <rect x="990" y="108" width="50" height="15" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="1015" y="119" font-size="7.5" font-weight="bold" fill="#be123c" text-anchor="middle">[NO]</text>

  <rect x="1050" y="85" width="230" height="75" fill="#fff1f2" stroke="#e11d48" stroke-width="1.4" rx="6"/>
  <text x="1165" y="112" font-size="10" font-weight="bold" fill="#9f1239" text-anchor="middle">Safety Trip &amp; Span Mark</text>
  <text x="1165" y="128" font-size="8" fill="#be123c" text-anchor="middle">Fires Amber stack light + buzzer</text>
  <text x="1165" y="142" font-size="8" fill="#be123c" text-anchor="middle">Logs uninspected [Y1, Y2] in SQLite</text>

  <!-- Step 4 YES Branch (Down to Step 5) -->
  <path d="M 915 152 L 915 220 L 150 220 L 150 270" fill="none" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>
  <rect x="880" y="175" width="70" height="18" fill="#f0fdf4" stroke="#16a34a" rx="3"/>
  <text x="915" y="188" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">[YES: Clear]</text>

  <!-- Step 5: YOLO Detection & Tracking -->
  <rect x="40" y="270" width="220" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="50" y="278" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="85" y="291" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 5</text>
  <text x="150" y="312" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">AI Vision Detection</text>
  <text x="150" y="328" font-size="8.5" fill="#334155" text-anchor="middle">YOLO BBox + (X, Y) metric map</text>
  <text x="150" y="342" font-size="8.5" fill="#334155" text-anchor="middle">Multi-frame Kalman deduplication</text>

  <!-- Step 6: Local SQLite Buffer Commit -->
  <line x1="260" y1="312" x2="310" y2="312" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <rect x="310" y="270" width="220" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="320" y="278" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="355" y="291" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 6</text>
  <text x="420" y="312" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Local SQLite Buffer</text>
  <text x="420" y="328" font-size="8.5" fill="#334155" text-anchor="middle">Commits flaw row instantly</text>
  <text x="420" y="342" font-size="8.5" fill="#334155" text-anchor="middle">Saves crop JPEG to local NVMe</text>

  <!-- Step 7: Central Cloud Backend Sync -->
  <line x1="530" y1="312" x2="580" y2="312" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <rect x="580" y="270" width="220" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="590" y="278" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="625" y="291" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 7</text>
  <text x="690" y="312" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Central Cloud Sync</text>
  <text x="690" y="328" font-size="8.5" fill="#334155" text-anchor="middle">FastAPI ingests batch via HTTPS</text>
  <text x="690" y="342" font-size="8.5" fill="#334155" text-anchor="middle">Stores PostgreSQL &amp; MinIO S3</text>

  <!-- Step 8: ASTM 4-Point Grading Engine -->
  <line x1="800" y1="312" x2="850" y2="312" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <rect x="850" y="270" width="220" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="860" y="278" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="895" y="291" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 8</text>
  <text x="960" y="312" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">ASTM 4-Point Grading</text>
  <text x="960" y="328" font-size="8.5" fill="#334155" text-anchor="middle">Computes penalty points/100m²</text>
  <text x="960" y="342" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">Assigns Grade A / B / Scrap</text>

  <!-- Step 8 to Step 9 Route -->
  <path d="M 1070 312 L 1165 312 L 1165 410 L 150 410 L 150 460" fill="none" stroke="#0f172a" stroke-width="1.4" marker-end="url(#arr-black)"/>

  <!-- Step 9: Web Quality Dashboard Map Render -->
  <rect x="40" y="460" width="280" height="90" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <rect x="50" y="468" width="70" height="18" fill="#0284c7" rx="3"/>
  <text x="85" y="481" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 9</text>
  <text x="180" y="503" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Web Dashboard 2D Map</text>
  <text x="180" y="521" font-size="8.5" fill="#334155" text-anchor="middle">Canvas renders fabric roll defect layout</text>
  <text x="180" y="536" font-size="8.5" fill="#334155" text-anchor="middle">Inspector audits &amp; reclassifies flaw tags</text>

  <!-- Step 10: Final PDF Certificate Export -->
  <line x1="320" y1="505" x2="380" y2="505" stroke="#16a34a" stroke-width="1.5" marker-end="url(#arr-green)"/>

  <rect x="380" y="460" width="310" height="90" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.5" rx="6"/>
  <rect x="390" y="468" width="70" height="18" fill="#16a34a" rx="3"/>
  <text x="425" y="481" font-size="8.5" font-weight="bold" fill="#ffffff" text-anchor="middle">STEP 10</text>
  <text x="535" y="503" font-size="11" font-weight="bold" fill="#15803d" text-anchor="middle">Quality Manager / PDF Certificate</text>
  <text x="535" y="521" font-size="8.5" fill="#166534" text-anchor="middle">Official ASTM Quality Certificate generated</text>
  <text x="535" y="536" font-size="8.5" fill="#166534" font-weight="bold" text-anchor="middle">Cryptographic SHA-256 seal &amp; ERP Export</text>

  <!-- Complete System Closed Loop Badge -->
  <rect x="740" y="460" width="540" height="90" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="1010" y="485" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Closed-Loop Architecture Verification:</text>
  <text x="1010" y="505" font-size="9" fill="#334155" text-anchor="middle">User &rarr; Frontend &rarr; Stand Backend &rarr; Edge DB &rarr; Central DB &rarr; Web Frontend &rarr; User</text>
  <text x="1010" y="525" font-size="8.5" fill="#16a34a" font-weight="bold" text-anchor="middle">&check; Every single architectural layer participates with verified traceability.</text>

  <!-- Bottom Legend -->
  <rect x="25" y="585" width="1270" height="85" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="605" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (Complete System Flow):</text>
  <text x="40" y="623" font-size="8.5" fill="#334155">&bull; 10 Numbered Rectangles: Connect them sequentially with arrows. Show Decision 4 (Reliability Gate) branching to safety alarm.</text>
  <text x="40" y="639" font-size="8.5" fill="#334155">&bull; This single diagram answers: "Walk me through how data flows from the moment the worker turns on the machine until the manager prints the certificate."</text>
</svg>
"@

$exp5 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Walk Your Supervisor Through the 10-Step Closed Loop Flow:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>Steps 1 to 4: Ingestion &amp; Reliability</strong>
          Explain: "1. Worker scans QR code on phone. 2. Phone sends session start. 3. Stand zeros encoder and checks camera. 4. If lighting is below 800 lux or frames drop, amber light fires and span is flagged."
        </div>
        <div class="exp-col">
          <strong>Steps 5 to 8: AI &amp; Quality Intelligence</strong>
          Explain: "5. YOLO detects defects and Kalman tracks without duplicates. 6. Saved to local SQLite first. 7. Synced to cloud FastAPI, PostgreSQL, and MinIO. 8. ASTM 4-point engine assigns Grade A, B, or Scrap."
        </div>
        <div class="exp-col">
          <strong>Steps 9 to 10: 2D Review &amp; Official Certificate</strong>
          Explain: "9. Quality manager opens web dashboard to inspect the 2D roll defect map. 10. Manager approves grades and exports the final PDF certificate with a tamper-proof SHA-256 seal."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "05_complete_system_flow" -SvgContent $svg5 -Title "Diagram 5: Complete Closed-Loop System Flow" -Subtitle "Step-by-Step 10-Stage Trace: User &rarr; Frontend &rarr; Stand Backend &rarr; Database &rarr; Backend &rarr; Frontend &rarr; User" -ExplanationHtml $exp5

# ------------------------------------------------------------------------------
# DIAGRAM 6: User Roles & Use Cases
# ------------------------------------------------------------------------------
$svg6 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — User Roles &amp; System Use Cases</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Actors, Functional Boundaries, and Use Case Associations for COMSATS FYP Presentation</text>

  <!-- Left: Floor Actors -->
  <!-- Actor 1: Floor Operator -->
  <rect x="40" y="110" width="180" height="90" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="130" y="135" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="130" y="153" font-size="12" font-weight="bold" fill="#0284c7" text-anchor="middle">Floor Operator</text>
  <text x="130" y="172" font-size="8.5" fill="#475569" text-anchor="middle">(Mobile Floor App)</text>

  <!-- Actor 2: Autonomous Stand -->
  <rect x="40" y="440" width="180" height="90" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="130" y="465" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;System Actor&raquo;</text>
  <text x="130" y="483" font-size="12" font-weight="bold" fill="#0284c7" text-anchor="middle">Hardware Stand</text>
  <text x="130" y="502" font-size="8.5" fill="#475569" text-anchor="middle">(Camera &amp; Encoder)</text>

  <!-- Right: Management Actors -->
  <!-- Actor 3: Quality Inspector -->
  <rect x="1100" y="100" width="180" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="1190" y="125" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="1190" y="143" font-size="12" font-weight="bold" fill="#0284c7" text-anchor="middle">Quality Inspector</text>
  <text x="1190" y="162" font-size="8.5" fill="#475569" text-anchor="middle">(Web Dashboard)</text>

  <!-- Actor 4: Quality Manager -->
  <rect x="1100" y="270" width="180" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="1190" y="295" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="1190" y="313" font-size="12" font-weight="bold" fill="#0284c7" text-anchor="middle">Quality Manager</text>
  <text x="1190" y="332" font-size="8.5" fill="#475569" text-anchor="middle">(Web Dashboard)</text>

  <!-- Actor 5: System Admin -->
  <rect x="1100" y="440" width="180" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="1190" y="465" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">&laquo;Actor&raquo;</text>
  <text x="1190" y="483" font-size="12" font-weight="bold" fill="#0284c7" text-anchor="middle">System Admin</text>
  <text x="1190" y="502" font-size="8.5" fill="#475569" text-anchor="middle">(Admin Portal)</text>

  <!-- System Boundary Container -->
  <rect x="260" y="75" width="800" height="660" fill="#f8fafc" stroke="#0f172a" stroke-width="1.5" rx="8"/>
  <text x="660" y="100" font-size="12" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI Quality Management System Boundary</text>

  <!-- Use Case Pills (Column 1: Floor & Stand Use Cases) -->
  <rect x="290" y="120" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="145" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-01: Scan Roll QR Tag</text>

  <rect x="290" y="180" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="205" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-02: Start / Pause Run</text>

  <rect x="290" y="240" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="265" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-03: Live Defect Alerts</text>

  <rect x="290" y="300" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="325" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-04: Tag Manual Flaw</text>

  <rect x="290" y="390" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="415" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-05: Monitor Reliability</text>

  <rect x="290" y="450" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="475" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-06: Autonomous Detection</text>

  <rect x="290" y="510" width="220" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="400" y="535" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-07: Offline Sync Outbox</text>

  <!-- Use Case Pills (Column 2: Management & Quality Use Cases) -->
  <rect x="560" y="120" width="240" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="680" y="145" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-08: View 2D Defect Map</text>

  <rect x="560" y="180" width="240" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="680" y="205" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-09: Reclassify Flaw Images</text>

  <rect x="560" y="270" width="240" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="680" y="295" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-10: Compute ASTM Grade</text>

  <rect x="560" y="330" width="240" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="680" y="355" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-11: Export PDF Certificate</text>

  <rect x="560" y="440" width="240" height="42" fill="#ffffff" stroke="#0f172a" stroke-width="1.2" rx="21"/>
  <text x="680" y="465" font-size="9" font-weight="bold" fill="#0f172a" text-anchor="middle">UC-12: Manage Users &amp; Stand</text>

  <!-- Clean Associations -->
  <!-- Floor Operator to UC 1-4 -->
  <line x1="220" y1="140" x2="290" y2="140" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="220" y1="150" x2="290" y2="200" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="220" y1="160" x2="290" y2="260" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="220" y1="170" x2="290" y2="320" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Autonomous Stand to UC 5-7 -->
  <line x1="220" y1="470" x2="290" y2="410" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="220" y1="485" x2="290" y2="470" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="220" y1="500" x2="290" y2="530" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Quality Inspector to UC 8-9 -->
  <line x1="1100" y1="140" x2="800" y2="140" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1100" y1="150" x2="800" y2="200" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Quality Manager to UC 8, 10, 11 -->
  <line x1="1100" y1="290" x2="800" y2="155" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1100" y1="310" x2="800" y2="290" stroke="#0f172a" stroke-width="1.2"/>
  <line x1="1100" y1="330" x2="800" y2="350" stroke="#0f172a" stroke-width="1.2"/>

  <!-- System Admin to UC 12 -->
  <line x1="1100" y1="480" x2="800" y2="460" stroke="#0f172a" stroke-width="1.2"/>

  <!-- Bottom Legend -->
  <rect x="25" y="755" width="1270" height="80" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="775" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (User Roles &amp; Use Cases):</text>
  <text x="40" y="793" font-size="8.5" fill="#334155">&bull; 5 Clean Actors: Floor Operator (mobile floor actions), Hardware Stand (autonomous sensing/lighting), Quality Inspector (review/calipers), Quality Manager (grading/reports), Admin (config).</text>
  <text x="40" y="809" font-size="8.5" fill="#334155">&bull; Strict Role Separation: Floor workers never modify grading formulas; managers never operate hardware cameras directly.</text>
</svg>
"@

$exp6 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Draw and Explain User Roles &amp; Use Cases to Your Supervisor:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Five Actors (4 Human + 1 System)</strong>
          Explain: "Sir, we have 4 human actors (Floor Operator, Quality Inspector, Quality Manager, System Admin) plus 1 autonomous system actor: the Hardware Stand itself, which monitors lux and counts pulses."
        </div>
        <div class="exp-col">
          <strong>2. Clear Boundary of Responsibilities</strong>
          Explain: "The Floor Operator uses the mobile app to scan rolls and acknowledge urgent defect alarms. The Quality Inspector reviews defect crops on the web dashboard to correct false positives."
        </div>
        <div class="exp-col">
          <strong>3. Manager &amp; Certificate Authority</strong>
          Explain: "Only the Quality Manager has permission to finalize the roll's ASTM D5430 grade and export the official signed PDF certificate."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "06_user_roles_use_cases" -SvgContent $svg6 -Title "Diagram 6: User Roles & System Use Cases" -Subtitle "Actor Interaction Boundaries and Functional Responsibilities Across Factory Floor and Management" -ExplanationHtml $exp6

# ------------------------------------------------------------------------------
# DIAGRAM 7: Infrastructure & Deployment
# ------------------------------------------------------------------------------
$svg7 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">TexEye AI — Infrastructure &amp; Physical Deployment Topology</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Physical Hardware, Network Topologies, and Distributed Cloud Deployment Specifications</text>

  <!-- Zone 1: Inspection Stand Node -->
  <rect x="25" y="75" width="400" height="665" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="32" y="82" width="310" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="187" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">1. FABRIC INSPECTION STAND (Edge Node)</text>

  <!-- Hardware Sensors -->
  <rect x="45" y="120" width="360" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="225" y="142" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Industrial Camera (USB 3.0 / GigE)</text>
  <text x="225" y="160" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 1080p @ 30-60 FPS &bull; Low distortion C-mount lens</text>
  <text x="225" y="174" font-size="8.5" fill="#334155" text-anchor="middle">&bull; High-CRI LED bar illumination (&gt; 1000 lux)</text>
  <text x="225" y="188" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Connects to Stand PC via USB 3.0</text>

  <rect x="45" y="220" width="360" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="225" y="242" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Rotary Encoder (Optical 1000 PPR)</text>
  <text x="225" y="260" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Mounted on fabric idler roller (200mm circ)</text>
  <text x="225" y="274" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 0.2mm precision displacement tracking</text>
  <text x="225" y="288" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Connects to Stand PC via Serial / GPIO</text>

  <rect x="45" y="320" width="360" height="85" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="225" y="342" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Relay Controller &amp; Stack Light</text>
  <text x="225" y="360" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Amber Light: Sensor Uninspected Fault</text>
  <text x="225" y="374" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Red Light + 85dB Siren: Critical Defect Stop</text>
  <text x="225" y="388" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Connects to Stand PC via USB Relay Module</text>

  <!-- Stand Edge PC -->
  <rect x="45" y="420" width="360" height="200" fill="#ffffff" stroke="#0f172a" stroke-width="1.4" rx="6"/>
  <text x="225" y="445" font-size="12" font-weight="bold" fill="#0f172a" text-anchor="middle">Stand Edge PC (Intel i5 / Mini-PC)</text>
  <text x="225" y="468" font-size="9" fill="#334155" text-anchor="middle">&bull; OS: Ubuntu Linux 22.04 LTS / Windows IoT</text>
  <text x="225" y="488" font-size="9" fill="#334155" text-anchor="middle">&bull; Runtime: Python 3.11 Stand Daemon</text>
  <text x="225" y="508" font-size="9" fill="#334155" text-anchor="middle">&bull; Model: YOLOv8 / YOLOv11 Optimized</text>
  <text x="225" y="528" font-size="9" fill="#334155" text-anchor="middle">&bull; Local Storage: 512GB NVMe SSD (SQLite WAL)</text>
  <text x="225" y="548" font-size="9" fill="#334155" text-anchor="middle">&bull; Network: Dual Gigabit Ethernet + Wi-Fi</text>
  <text x="225" y="575" font-size="9" font-weight="bold" fill="#16a34a" text-anchor="middle">&check; Autonomous Operation Without Cloud Connection</text>

  <!-- Zone 2: Factory Network -->
  <rect x="450" y="75" width="230" height="665" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="457" y="82" width="200" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="557" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">2. FACTORY NETWORK</text>

  <rect x="465" y="150" width="200" height="110" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="565" y="175" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Gigabit Switch (LAN)</text>
  <text x="565" y="198" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Cat6 Shielded Ethernet</text>
  <text x="565" y="215" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 1000 Mbps Full Duplex</text>
  <text x="565" y="232" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Dedicated VLAN for Stands</text>

  <rect x="465" y="320" width="200" height="110" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="565" y="345" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Industrial Wi-Fi AP</text>
  <text x="565" y="368" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 802.11ax (Wi-Fi 6)</text>
  <text x="565" y="385" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 5GHz Band (Low Noise)</text>
  <text x="565" y="402" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Floor Tablet Connectivity</text>

  <rect x="465" y="490" width="200" height="110" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="5"/>
  <text x="565" y="515" font-size="10.5" font-weight="bold" fill="#0f172a" text-anchor="middle">Factory Gateway</text>
  <text x="565" y="538" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Hardware Firewall</text>
  <text x="565" y="555" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Port 443 HTTPS Only</text>
  <text x="565" y="572" font-size="8.5" fill="#334155" text-anchor="middle">&bull; VPN / Zero Trust Access</text>

  <!-- Zone 3: Client Devices -->
  <rect x="705" y="75" width="265" height="665" fill="#f8fafc" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="712" y="82" width="230" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="827" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">3. CLIENT PRESENTATION</text>

  <rect x="720" y="160" width="235" height="150" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="837" y="185" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Floor Tablet / Smartphone</text>
  <text x="837" y="208" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Rugged Android 12+ Tablet</text>
  <text x="837" y="225" font-size="8.5" fill="#334155" text-anchor="middle">&bull; TexEye Mobile App (Flutter)</text>
  <text x="837" y="242" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Camera Viewfinder for QR Scan</text>
  <text x="837" y="259" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Vibration Haptic Alerts</text>
  <text x="837" y="278" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Connects via Factory Wi-Fi</text>

  <rect x="720" y="380" width="235" height="150" fill="#ffffff" stroke="#0f172a" stroke-width="1.3" rx="6"/>
  <text x="837" y="405" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">Quality Manager Workstation</text>
  <text x="837" y="428" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Office Desktop PC / Laptop</text>
  <text x="837" y="445" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Google Chrome / Firefox</text>
  <text x="837" y="462" font-size="8.5" fill="#334155" text-anchor="middle">&bull; TexEye Web SPA (React.js)</text>
  <text x="837" y="479" font-size="8.5" fill="#334155" text-anchor="middle">&bull; 2D Canvas Defect Map &amp; PDF</text>
  <text x="837" y="498" font-size="8.5" fill="#0284c7" font-weight="bold" text-anchor="middle">&rarr; Connects via Office LAN</text>

  <!-- Zone 4: Central Enterprise Server -->
  <rect x="995" y="75" width="300" height="665" fill="#ffffff" stroke="#94a3b8" stroke-width="1.2" rx="6"/>
  <rect x="1002" y="82" width="260" height="24" fill="#e2e8f0" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="1132" y="98" font-size="10.5" font-weight="bold" fill="#1e293b" text-anchor="middle">4. CENTRAL ENTERPRISE SERVER</text>

  <rect x="1010" y="140" width="270" height="130" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="1145" y="165" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">FastAPI Gateway (Port 8000)</text>
  <text x="1145" y="188" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Python 3.11 Async Engine</text>
  <text x="1145" y="205" font-size="8.5" fill="#334155" text-anchor="middle">&bull; HTTPS REST Ingestion Endpoints</text>
  <text x="1145" y="222" font-size="8.5" fill="#334155" text-anchor="middle">&bull; WSS Real-Time WebSocket Hub</text>
  <text x="1145" y="239" font-size="8.5" fill="#334155" text-anchor="middle">&bull; JWT Security &amp; Rate Limiter</text>

  <rect x="1010" y="295" width="270" height="130" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="1145" y="320" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">PostgreSQL DB (Port 5432)</text>
  <text x="1145" y="343" font-size="8.5" fill="#334155" text-anchor="middle">&bull; PostgreSQL 15 Relational Store</text>
  <text x="1145" y="360" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Batches, Rolls, Defects Telemetry</text>
  <text x="1145" y="377" font-size="8.5" fill="#334155" text-anchor="middle">&bull; ASTM Scorecards &amp; Audit Logs</text>
  <text x="1145" y="394" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Automated Nightly Backups</text>

  <rect x="1010" y="450" width="270" height="130" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="1145" y="475" font-size="11" font-weight="bold" fill="#0f172a" text-anchor="middle">MinIO Object Store (Port 9000)</text>
  <text x="1145" y="498" font-size="8.5" fill="#334155" text-anchor="middle">&bull; S3-Compatible Cloud Storage</text>
  <text x="1145" y="515" font-size="8.5" fill="#334155" text-anchor="middle">&bull; High-Res Flaw Crop Images</text>
  <text x="1145" y="532" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Signed PDF Inspection Reports</text>
  <text x="1145" y="549" font-size="8.5" fill="#334155" text-anchor="middle">&bull; Distributed Block Storage</text>

  <!-- Bottom Legend -->
  <rect x="25" y="755" width="1270" height="80" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="775" font-size="10" font-weight="bold" fill="#0f172a">Paper-Reproduction Guide for Supervisor Presentation (Infrastructure &amp; Deployment):</text>
  <text x="40" y="793" font-size="8.5" fill="#334155">&bull; 4 Physical Zones: Stand Node (Edge PC, Camera, Encoder, Relays) &rarr; Factory Network (Switch &amp; Wi-Fi) &rarr; Client Devices &rarr; Enterprise Server (FastAPI, Postgres, MinIO).</text>
  <text x="40" y="809" font-size="8.5" fill="#334155">&bull; Flexible Server Deployment: Can be hosted On-Premises on a factory server room machine or deployed on a Cloud VM (AWS, Azure, DigitalOcean) without changing any code.</text>
</svg>
"@

$exp7 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> How to Draw and Explain Infrastructure &amp; Deployment to Your Supervisor:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Four Physical Zones</strong>
          Explain: "Sir, we have 4 zones: 1. The physical inspection stand node with sensors. 2. Factory floor network. 3. Presentation client devices. 4. Central enterprise server."
        </div>
        <div class="exp-col">
          <strong>2. Stand Edge PC Hardware</strong>
          Explain: "On the stand, the camera connects via USB 3.0, the rotary encoder connects via GPIO/serial, and the relays connect via USB to actuate the stack lights and audible siren."
        </div>
        <div class="exp-col">
          <strong>3. Cloud / On-Premise Hosting</strong>
          Explain: "Sir, as stated in our proposal, our central backend is designed to run either on an on-premises factory server or on a cloud VM. FastAPI, PostgreSQL, and MinIO are containerized for easy deployment."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "07_infrastructure_deployment" -SvgContent $svg7 -Title "Diagram 7: Infrastructure & Physical Deployment Topology" -Subtitle "Physical Stand Edge Hardware, Factory Network Layers, Client Devices, and Enterprise Server Node" -ExplanationHtml $exp7

Write-Host "All Diagrams 2 through 7 successfully compiled!" -ForegroundColor Green
