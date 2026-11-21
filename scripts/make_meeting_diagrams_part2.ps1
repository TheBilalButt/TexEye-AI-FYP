# scripts/make_meeting_diagrams_part2.ps1
# Generates Diagrams 01, 02, 03, 04, 05, 06, 07

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
# 01: SEQUENCE DIAGRAM — MODULE 1: AI DEFECT DETECTION & LOCATION
# ------------------------------------------------------------------------------
$svg01 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">Sequence Diagram &bull; Module 1: AI Defect Detection &amp; Location Module</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Owner: Muhammad Bilal Butt (FA23-BAI-042) &bull; Frame Ingestion, YOLO Inference, Metric Localization &amp; Multi-Frame Tracking</text>

  <!-- Lifeline Headers -->
  <rect x="50" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="130" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:CameraStream</text>
  <line x1="130" y1="120" x2="130" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="260" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="340" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:YOLODetector</text>
  <line x1="340" y1="120" x2="340" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="470" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="550" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:RotaryEncoder</text>
  <line x1="550" y1="120" x2="550" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="680" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="760" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:MetricMapper</text>
  <line x1="760" y1="120" x2="760" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="890" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="970" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:KalmanTracker</text>
  <line x1="970" y1="120" x2="970" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="1100" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="1180" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:SQLiteBuffer</text>
  <line x1="1180" y1="120" x2="1180" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <!-- Messages -->
  <line x1="130" y1="150" x2="340" y2="150" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="137" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="149" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">1. grab_frame(frame_id)</text>

  <line x1="340" y1="190" x2="340" y2="230" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="340" y1="230" x2="370" y2="230" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="370" y1="230" x2="370" y2="190" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="370" y1="190" x2="345" y2="190" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="350" y="200" width="130" height="16" fill="#f8fafc" stroke="#cbd5e1" rx="3"/>
  <text x="415" y="212" font-size="7.5" font-weight="bold" fill="#0f172a" text-anchor="middle">infer_yolo(bbox, conf)</text>

  <line x1="340" y1="270" x2="550" y2="270" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="385" y="257" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="445" y="269" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">2. get_current_pulses()</text>

  <line x1="550" y1="310" x2="340" y2="310" stroke="#94a3b8" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-black)"/>
  <rect x="385" y="297" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="445" y="309" font-size="8" fill="#475569" text-anchor="middle">return pulse_count</text>

  <line x1="340" y1="350" x2="760" y2="350" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="470" y="337" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="550" y="349" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">3. compute_coords(bbox, pulses)</text>

  <line x1="760" y1="390" x2="340" y2="390" stroke="#94a3b8" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-black)"/>
  <rect x="470" y="377" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="550" y="389" font-size="8" fill="#475569" text-anchor="middle">return (X_cm, Y_meters)</text>

  <line x1="340" y1="430" x2="970" y2="430" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="580" y="417" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="660" y="429" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">4. track_flaw(bbox, X_cm, Y_m)</text>

  <line x1="970" y1="470" x2="340" y2="470" stroke="#94a3b8" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-black)"/>
  <rect x="580" y="457" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="660" y="469" font-size="8" fill="#475569" text-anchor="middle">return is_new_defect (true/false)</text>

  <rect x="280" y="505" width="940" height="160" fill="none" stroke="#0284c7" stroke-width="1.3" stroke-dasharray="4 2" rx="4"/>
  <rect x="280" y="505" width="120" height="18" fill="#e0f2fe" stroke="#0284c7" rx="2"/>
  <text x="340" y="518" font-size="8" font-weight="bold" fill="#0369a1" text-anchor="middle">alt [is_new_defect == true]</text>

  <line x1="340" y1="550" x2="1180" y2="550" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="670" y="537" width="180" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="760" y="549" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">5. insert_defect(flaw_data, crop_jpg)</text>

  <line x1="1180" y1="590" x2="340" y2="590" stroke="#16a34a" stroke-width="1.2" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="670" y="577" width="180" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="760" y="589" font-size="8" fill="#166534" text-anchor="middle">commit_ok (defect_id)</text>

  <line x1="340" y1="630" x2="1180" y2="630" stroke="#2563eb" stroke-width="1.3" marker-end="url(#arr-blue)"/>
  <rect x="670" y="617" width="180" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="760" y="629" font-size="8" font-weight="bold" fill="#1d4ed8" text-anchor="middle">6. emit_ws('defect_detected', data)</text>

  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module 1 Defense Summary (Bilal Butt):</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; Rotary Encoder pulses guarantee exact real-world (X cm, Y m) location without guessing.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Multi-frame Kalman filter deduplication ensures a defect visible across 15 frames is recorded exactly ONCE.</text>
</svg>
"@

$exp01 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> Module 1 Sequence Walkthrough for Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Real-Time Inference</strong>
          Explain: "Sir, when a frame arrives, the YOLO model detects the flaw bounding box. Concurrently, we read the rotary encoder pulse counter to establish the precise distance."
        </div>
        <div class="exp-col">
          <strong>2. Coordinate Transformation</strong>
          Explain: "Pixel coordinates are converted to metric width (X cm), while encoder pulses convert to metric length (Y meters) with 0.2mm mechanical resolution."
        </div>
        <div class="exp-col">
          <strong>3. Kalman Deduplication</strong>
          Explain: "The Kalman tracker evaluates whether the flaw was already seen in prior frames. Only if it is genuinely new do we commit it to SQLite and push an alert."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "01_module_1_ai_detection_sequence" -SvgContent $svg01 -Title "Sequence Diagram &bull; Module 1: AI Defect Detection & Location" -Subtitle "Step-by-Step Execution Trace: Frame Ingestion, YOLO BBox, Encoder Mapping & Multi-Frame Deduplication" -ExplanationHtml $exp01

# ------------------------------------------------------------------------------
# 02: SEQUENCE DIAGRAM — MODULE 2: HARDWARE & INSPECTION MONITORING
# ------------------------------------------------------------------------------
$svg02 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-red" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#dc2626"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">Sequence Diagram &bull; Module 2: Hardware &amp; Inspection Monitoring Module</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Owner: Muhammad Bilal Butt (FA23-BAI-042) &bull; Lux Sensor Guard, Blur Sentinel, Physical Relays &amp; Uninspected Span Flagging</text>

  <!-- Lifeline Headers -->
  <rect x="50" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="130" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:StandSensors</text>
  <line x1="130" y1="120" x2="130" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="260" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="340" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:ReliabilityGuard</text>
  <line x1="340" y1="120" x2="340" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="470" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="550" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:USBRelayBox</text>
  <line x1="550" y1="120" x2="550" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="680" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="760" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:AmberLightSiren</text>
  <line x1="760" y1="120" x2="760" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="890" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="970" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:UninspectedLogger</text>
  <line x1="970" y1="120" x2="970" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="1100" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="1180" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:SQLiteBuffer</text>
  <line x1="1180" y1="120" x2="1180" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <!-- Messages -->
  <line x1="130" y1="150" x2="340" y2="150" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="165" y="137" width="140" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="149" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">1. check_frame_health(lux, blur)</text>

  <line x1="340" y1="190" x2="340" y2="230" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="340" y1="230" x2="370" y2="230" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="370" y1="230" x2="370" y2="190" stroke="#0f172a" stroke-width="1.3"/>
  <line x1="370" y1="190" x2="345" y2="190" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="350" y="200" width="150" height="16" fill="#fff1f2" stroke="#fca5a5" rx="3"/>
  <text x="425" y="212" font-size="7.5" font-weight="bold" fill="#9f1239" text-anchor="middle">detect: lux &lt; 800 | blur</text>

  <rect x="240" y="255" width="980" height="420" fill="none" stroke="#dc2626" stroke-width="1.4" stroke-dasharray="4 2" rx="4"/>
  <rect x="240" y="255" width="160" height="18" fill="#fee2e2" stroke="#dc2626" rx="2"/>
  <text x="320" y="268" font-size="8" font-weight="bold" fill="#991b1b" text-anchor="middle">alt [Safety Invariant Breached]</text>

  <line x1="340" y1="300" x2="550" y2="300" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-red)"/>
  <rect x="385" y="287" width="120" height="16" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="445" y="299" font-size="8" font-weight="bold" fill="#be123c" text-anchor="middle">2. trip_relay(AMBER, ON)</text>

  <line x1="550" y1="340" x2="760" y2="340" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-red)"/>
  <rect x="605" y="327" width="100" height="16" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="655" y="339" font-size="8" font-weight="bold" fill="#be123c" text-anchor="middle">3. sound_buzzer()</text>

  <line x1="340" y1="390" x2="970" y2="390" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-red)"/>
  <rect x="580" y="377" width="160" height="16" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="660" y="389" font-size="8" font-weight="bold" fill="#be123c" text-anchor="middle">4. start_uninspected_span(Y1)</text>

  <line x1="970" y1="430" x2="1180" y2="430" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-red)"/>
  <rect x="1015" y="417" width="120" height="16" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="1075" y="429" font-size="8" font-weight="bold" fill="#be123c" text-anchor="middle">5. insert_span_start()</text>

  <rect x="330" y="465" width="20" height="30" fill="#fed7aa"/>
  <text x="360" y="483" font-size="7.5" font-style="italic" fill="#c2410c">Waiting for lighting / camera restore...</text>

  <line x1="130" y1="510" x2="340" y2="510" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="165" y="497" width="140" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="235" y="509" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">6. sensors_recovered(lux &gt; 800)</text>

  <line x1="340" y1="550" x2="550" y2="550" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="385" y="537" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="445" y="549" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">7. trip_relay(AMBER, OFF)</text>

  <line x1="340" y1="590" x2="970" y2="590" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="580" y="577" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="660" y="589" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">8. close_uninspected_span(Y2)</text>

  <line x1="970" y1="630" x2="1180" y2="630" stroke="#16a34a" stroke-width="1.4" marker-end="url(#arr-green)"/>
  <rect x="1015" y="617" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="1075" y="629" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">9. update_span_end([Y1, Y2])</text>

  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module 2 Defense Summary (Bilal Butt):</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; Hardware Reliability Sentinel guarantees that zero fabric is ever passed off as inspected during sensor dropouts or dim lighting.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; The exact flagged interval [Y_start, Y_end] is saved into SQLite and visibly highlighted in amber on the quality manager's 2D map.</text>
</svg>
"@

$exp02 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> Module 2 Sequence Walkthrough for Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Safety Invariant Check</strong>
          Explain: "Sir, on every frame, the Reliability Guard checks mean illumination and blur. If lux drops below 800, inspection safety is compromised."
        </div>
        <div class="exp-col">
          <strong>2. Physical Relay Actuation</strong>
          Explain: "A USB relay fires the physical Amber stack light and sounds an audible siren to alert the machine operator immediately."
        </div>
        <div class="exp-col">
          <strong>3. Uninspected Span Logging</strong>
          Explain: "The exact interval [Y_start, Y_end] is committed to SQLite so the buyer knows precisely which fabric section requires re-inspection."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "02_module_2_hardware_monitoring_sequence" -SvgContent $svg02 -Title "Sequence Diagram &bull; Module 2: Hardware & Inspection Monitoring" -Subtitle "Step-by-Step Execution Trace: Lux Gating, Relay Actuation & Uninspected Span Lifecycle" -ExplanationHtml $exp02

# ------------------------------------------------------------------------------
# 03: SEQUENCE DIAGRAM — MODULE 3: MOBILE FLOOR APPLICATION
# ------------------------------------------------------------------------------
$svg03 = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1320 860" width="1320" height="860" style="background:#ffffff; font-family:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;">
  <defs>
    <marker id="arr-black" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#0f172a"/></marker>
    <marker id="arr-blue" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#2563eb"/></marker>
    <marker id="arr-green" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><polygon points="0 1, 8 4, 0 7" fill="#16a34a"/></marker>
  </defs>

  <rect x="25" y="15" width="1270" height="48" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1.2" rx="6"/>
  <text x="660" y="36" font-size="16" font-weight="bold" fill="#0f172a" text-anchor="middle">Sequence Diagram &bull; Module 3: Mobile Floor Application</text>
  <text x="660" y="52" font-size="10.5" fill="#475569" text-anchor="middle">Owner: Muhammad Afnan Khan (FA23-BAI-028) &bull; QR Code Roll Scanning, Live Floor Telemetry, Real-Time Haptic Alert &amp; Manual Tagging</text>

  <!-- Lifeline Headers -->
  <rect x="50" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="130" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:FloorOperator</text>
  <line x1="130" y1="120" x2="130" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="260" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="340" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:MobileUI (Flutter)</text>
  <line x1="340" y1="120" x2="340" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="470" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="550" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:QRScanner</text>
  <line x1="550" y1="120" x2="550" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="680" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="760" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:WebSocketClient</text>
  <line x1="760" y1="120" x2="760" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="890" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="970" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:StandEdgePC</text>
  <line x1="970" y1="120" x2="970" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <rect x="1100" y="80" width="160" height="40" fill="#f8fafc" stroke="#0f172a" stroke-width="1.3" rx="4"/>
  <text x="1180" y="105" font-size="10" font-weight="bold" fill="#0f172a" text-anchor="middle">:LocalMobileCache</text>
  <line x1="1180" y1="120" x2="1180" y2="760" stroke="#94a3b8" stroke-width="1.2" stroke-dasharray="4 4"/>

  <!-- Messages -->
  <line x1="130" y1="150" x2="340" y2="150" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="137" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="149" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">1. tap_scan_qr()</text>

  <line x1="340" y1="190" x2="550" y2="190" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="385" y="177" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="445" y="189" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">2. open_viewfinder()</text>

  <line x1="550" y1="230" x2="340" y2="230" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="385" y="217" width="120" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="445" y="229" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">qr_decoded(roll_id, batch)</text>

  <line x1="340" y1="270" x2="970" y2="270" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="580" y="257" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="660" y="269" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">3. POST /session/start(roll_id)</text>

  <line x1="970" y1="310" x2="340" y2="310" stroke="#16a34a" stroke-width="1.3" stroke-dasharray="3 3" marker-end="url(#arr-green)"/>
  <rect x="580" y="297" width="160" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="660" y="309" font-size="8" fill="#166534" text-anchor="middle">200 OK (session_active, limits)</text>

  <line x1="340" y1="350" x2="760" y2="350" stroke="#2563eb" stroke-width="1.3" marker-end="url(#arr-blue)"/>
  <rect x="470" y="337" width="160" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="550" y="349" font-size="8" font-weight="bold" fill="#1d4ed8" text-anchor="middle">4. connect_websocket(ws_url)</text>

  <!-- Real-Time Push Event -->
  <line x1="970" y1="410" x2="760" y2="410" stroke="#2563eb" stroke-width="1.3" marker-end="url(#arr-blue)"/>
  <rect x="805" y="397" width="120" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="865" y="409" font-size="8" font-weight="bold" fill="#1d4ed8" text-anchor="middle">emit: defect_event(data)</text>

  <line x1="760" y1="450" x2="340" y2="450" stroke="#2563eb" stroke-width="1.3" marker-end="url(#arr-blue)"/>
  <rect x="470" y="437" width="160" height="16" fill="#eff6ff" stroke="#93c5fd" rx="3"/>
  <text x="550" y="449" font-size="8" font-weight="bold" fill="#1d4ed8" text-anchor="middle">5. trigger_haptic_vibration()</text>

  <line x1="340" y1="490" x2="130" y2="490" stroke="#dc2626" stroke-width="1.4" marker-end="url(#arr-black)"/>
  <rect x="175" y="477" width="120" height="16" fill="#fff1f2" stroke="#e11d48" rx="3"/>
  <text x="235" y="489" font-size="8" font-weight="bold" fill="#be123c" text-anchor="middle">6. display_alarm_modal()</text>

  <!-- Operator Acknowledge -->
  <line x1="130" y1="530" x2="340" y2="530" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="517" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="529" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">7. tap_acknowledge()</text>

  <!-- Manual Tagging -->
  <line x1="130" y1="580" x2="340" y2="580" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="175" y="567" width="120" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="235" y="579" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">8. select_manual_flaw('Hole')</text>

  <line x1="340" y1="620" x2="970" y2="620" stroke="#0f172a" stroke-width="1.3" marker-end="url(#arr-black)"/>
  <rect x="580" y="607" width="160" height="16" fill="#ffffff" stroke="#cbd5e1" rx="3"/>
  <text x="660" y="619" font-size="8" font-weight="bold" fill="#0f172a" text-anchor="middle">9. POST /defects/manual(flaw)</text>

  <line x1="340" y1="660" x2="1180" y2="660" stroke="#16a34a" stroke-width="1.3" marker-end="url(#arr-green)"/>
  <rect x="670" y="647" width="180" height="16" fill="#f0fdf4" stroke="#86efac" rx="3"/>
  <text x="760" y="659" font-size="8" font-weight="bold" fill="#15803d" text-anchor="middle">10. cache_local_session(data)</text>

  <!-- Bottom Legend -->
  <rect x="25" y="775" width="1270" height="60" fill="#f8fafc" stroke="#cbd5e1" stroke-width="1" rx="4"/>
  <text x="40" y="795" font-size="10" font-weight="bold" fill="#0f172a">Module 3 Defense Summary (Afnan Khan):</text>
  <text x="40" y="812" font-size="8.5" fill="#334155">&bull; Workers don't stare at a screen all day; WebSocket push triggers instant phone vibration when a critical defect passes.</text>
  <text x="40" y="826" font-size="8.5" fill="#334155">&bull; Manual flaw tag sheet allows workers to log human-spotted flaws (oil spots, selvage curl) stamped with exact meter position.</text>
</svg>
"@

$exp03 = @"
    <div class="explanation-box">
      <h3><span>&#128221;</span> Module 3 Sequence Walkthrough for Dr. Tassawar Iqbal:</h3>
      <div class="explanation-grid">
        <div class="exp-col">
          <strong>1. Fast QR Onboarding</strong>
          Explain: "Sir, when a new fabric roll arrives, the worker points their phone camera at the QR tag. In under 1 second, batch metadata loads and initializes the session."
        </div>
        <div class="exp-col">
          <strong>2. Instant Haptic Feedback</strong>
          Explain: "The app maintains a persistent WebSocket connection. When YOLO identifies a defect, the phone vibrates instantly and displays a red warning modal."
        </div>
        <div class="exp-col">
          <strong>3. Hybrid Human-AI Tagging</strong>
          Explain: "If a worker notices a defect like selvage curl that the camera angle cannot easily capture, they tap the manual tag sheet to record it at the current meter mark."
        </div>
      </div>
    </div>
"@

Compile-Diagram -Name "03_module_3_mobile_app_sequence" -SvgContent $svg03 -Title "Sequence Diagram &bull; Module 3: Mobile Floor Application" -Subtitle "Step-by-Step Execution Trace: QR Scanner Onboarding, WebSocket Defect Vibration & Manual Flaw Tagging" -ExplanationHtml $exp03

Write-Host "Diagram 03 compiled." -ForegroundColor Green
