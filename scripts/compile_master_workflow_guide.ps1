# compile_master_workflow_guide.ps1
# Compiles the comprehensive TexEye AI Master Workflow Guide PDF containing all 7 diagrams,
# architecture breakdowns, supervisor presentation walkthrough, and supervisor Q&A.

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$workflowDir = Join-Path $projectRoot "diagrams\workflow"
$docsDir = Join-Path $projectRoot "docs"

$edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgeExe)) { $edgeExe = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }

# Read the 7 SVGs
$svg1 = [IO.File]::ReadAllText((Join-Path $workflowDir "01_overall_system_workflow.svg"), [Text.Encoding]::UTF8)
$svg2 = [IO.File]::ReadAllText((Join-Path $workflowDir "02_frontend_architecture.svg"), [Text.Encoding]::UTF8)
$svg3 = [IO.File]::ReadAllText((Join-Path $workflowDir "03_backend_architecture.svg"), [Text.Encoding]::UTF8)
$svg4 = [IO.File]::ReadAllText((Join-Path $workflowDir "04_database_workflow.svg"), [Text.Encoding]::UTF8)
$svg5 = [IO.File]::ReadAllText((Join-Path $workflowDir "05_complete_system_flow.svg"), [Text.Encoding]::UTF8)
$svg6 = [IO.File]::ReadAllText((Join-Path $workflowDir "06_user_roles_use_cases.svg"), [Text.Encoding]::UTF8)
$svg7 = [IO.File]::ReadAllText((Join-Path $workflowDir "07_infrastructure_deployment.svg"), [Text.Encoding]::UTF8)

# Strip XML declaration if present
function Clean-Svg($s) {
    return ($s -replace '<\?xml.*?\?>', '').Trim()
}

$cleanSvg1 = Clean-Svg $svg1
$cleanSvg2 = Clean-Svg $svg2
$cleanSvg3 = Clean-Svg $svg3
$cleanSvg4 = Clean-Svg $svg4
$cleanSvg5 = Clean-Svg $svg5
$cleanSvg6 = Clean-Svg $svg6
$cleanSvg7 = Clean-Svg $svg7

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>TexEye AI — Complete System Workflow & Architecture Guide</title>
  <style>
    @page {
      size: A4 portrait;
      margin: 12mm 14mm 14mm 14mm;
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
      padding: 25mm 10mm 15mm 10mm;
      text-align: center;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      min-height: 245mm;
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
      margin-bottom: 12mm;
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
      margin-bottom: 8mm;
      text-transform: uppercase;
    }
    .project-title {
      font-size: 20pt;
      font-weight: 900;
      color: #0f172a;
      line-height: 1.25;
      margin: 0 0 4mm 0;
    }
    .project-subtitle {
      font-size: 11.5pt;
      color: #0284c7;
      font-weight: 600;
      margin: 0 0 10mm 0;
    }
    .doc-type-box {
      background: #f1f5f9;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      padding: 10px 18px;
      display: inline-block;
      margin: 0 auto 12mm auto;
      max-width: 85%;
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
      margin-top: 10mm;
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
    
    /* Content sections */
    .page-break { page-break-after: always; }
    h2.section-header {
      font-size: 13pt;
      font-weight: 800;
      color: #0f172a;
      border-bottom: 2px solid #0284c7;
      padding-bottom: 3px;
      margin: 0 0 8px 0;
      display: flex;
      justify-content: space-between;
      align-items: baseline;
    }
    h2.section-header .subtag {
      font-size: 8pt;
      font-weight: 600;
      color: #64748b;
    }
    h3.diagram-title {
      font-size: 10.5pt;
      font-weight: 700;
      color: #0369a1;
      margin: 8px 0 4px 0;
    }
    p.diagram-desc {
      font-size: 8.5pt;
      color: #475569;
      margin: 0 0 6px 0;
    }
    .diagram-frame {
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      padding: 4px;
      background: #ffffff;
      margin-bottom: 8px;
    }
    .diagram-frame svg {
      width: 100%;
      height: auto;
      display: block;
    }
    .callout-box {
      background: #f8fafc;
      border-left: 3px solid #0284c7;
      padding: 6px 12px;
      margin: 6px 0 10px 0;
      font-size: 8pt;
      border-radius: 0 4px 4px 0;
    }
    .callout-box strong { color: #0f172a; }
    
    /* Tables */
    table.data-table {
      width: 100%;
      border-collapse: collapse;
      margin: 6px 0 10px 0;
      font-size: 8pt;
    }
    table.data-table th, table.data-table td {
      border: 1px solid #cbd5e1;
      padding: 5px 8px;
      text-align: left;
    }
    table.data-table th {
      background: #f1f5f9;
      color: #0f172a;
      font-weight: 700;
    }
    table.data-table tr:nth-child(even) td {
      background: #f8fafc;
    }
    
    /* QA block */
    .qa-item {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 6px;
      padding: 8px 12px;
      margin-bottom: 8px;
    }
    .qa-q {
      font-size: 8.5pt;
      font-weight: 700;
      color: #0369a1;
      margin-bottom: 3px;
    }
    .qa-a {
      font-size: 8pt;
      color: #334155;
      line-height: 1.45;
    }
  </style>
</head>
<body>

  <!-- ==================== COVER PAGE ==================== -->
  <div class="cover-page">
    <div>
      <div class="inst-header">COMSATS University Islamabad &bull; Wah Cantt Campus</div>
      <div class="dept-header">Department of Computer Science &bull; Final Year Project Blueprint Dossier</div>
      
      <div class="badge-fyp">FYP System Workflow &amp; Architecture Package</div>
      <h1 class="project-title">TexEye AI</h1>
      <div class="project-subtitle">AI-Based Fabric Defect Detection and Quality Management System</div>
      
      <div class="doc-type-box">
        <h2>Supervisor Meeting Architecture Dossier &amp; Handwritten Drawing Blueprint</h2>
        <p>Complete 7-Diagram Presentation Portfolio, Component Decompositions, Real-World Data Flows, and Defense Q&amp;A</p>
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
          <div class="detail">&bull; AI Defect Detection &amp; Hardware Integration Modules</div>
          <div class="name" style="margin-top:4px;">Muhammad Afnan Khan <span style="font-weight:normal; font-size:8pt; color:#64748b;">(FA23-BAI-028)</span></div>
          <div class="detail">&bull; Mobile Floor App &amp; Web Quality Management Modules</div>
        </div>
      </div>

      <div style="margin-top: 6mm; font-size: 8pt; color: #64748b;">
        Academic Year 2026 &bull; Bachelor of Science in Artificial Intelligence (BS-AI)
      </div>
    </div>
  </div>

  <!-- ==================== EXECUTIVE SUMMARY ==================== -->
  <div class="page-break">
    <h2 class="section-header">1. Executive Overview &amp; Proposal Baseline <span class="subtag">Core FYP Identity</span></h2>
    
    <div class="callout-box">
      <strong>Real-World Problem Solved:</strong> Manual textile inspection at commercial speeds (20-60 m/min) misses up to 40% of critical fabric flaws, causing immense fabric wastage, customer returns, and revenue loss. Furthermore, existing automated solutions fail silently during camera disconnections, poor factory illumination, or dropped frames, letting flawed fabric pass as first-grade. <strong>TexEye AI</strong> guarantees 100% inspection reliability by combining YOLO computer vision, rotary encoder metric tracking, real-time sensor guards that flag uninspected spans, offline SQLite buffering, and automated ASTM D5430 4-point grading.
    </div>

    <h3 style="font-size: 9.5pt; font-weight: bold; color: #0f172a; margin: 8px 0 4px 0;">The Five Proposal Modules &amp; Student Allocations</h3>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width: 28%;">Module Name</th>
          <th style="width: 18%;">Assigned Lead</th>
          <th style="width: 54%;">Key Responsibilities &amp; Deliverables</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>1. AI Defect Detection &amp; Location Module</strong></td>
          <td>Muhammad Bilal Butt<br><span style="color:#64748b;">FA23-BAI-042</span></td>
          <td>Fabric defect dataset curation, YOLO model training, real-time defect bounding box inference, rotary encoder pulse-to-metric localization (X cm across width, Y m along length), and multi-frame Kalman tracker deduplication.</td>
        </tr>
        <tr>
          <td><strong>2. Hardware &amp; Inspection Monitoring Module</strong></td>
          <td>Muhammad Bilal Butt<br><span style="color:#64748b;">FA23-BAI-042</span></td>
          <td>Industrial camera integration (1080p), optical rotary encoder integration (1000 PPR), lighting monitor (lux &lt; 800 detection), Laplacian blur sentinel, dropped frame detector, physical relay box (amber/red stack light &amp; buzzer), and uninspected span tracking.</td>
        </tr>
        <tr>
          <td><strong>3. Mobile Floor Application</strong></td>
          <td>Muhammad Afnan Khan<br><span style="color:#64748b;">FA23-BAI-028</span></td>
          <td>Flutter Android application for floor workers, camera QR roll barcode scanner, live speed and length gauge, instant haptic vibration alert on defect, quick flaw review &amp; correction sheet, and offline roll cache.</td>
        </tr>
        <tr>
          <td><strong>4. Web Quality Management &amp; Digital Fabric Map</strong></td>
          <td>Muhammad Afnan Khan<br><span style="color:#64748b;">FA23-BAI-028</span></td>
          <td>React web dashboard, HTML5 canvas interactive 2D defect map, zoomable flaw crop gallery with electronic calipers, reclassification selector, rolls master overview table, and local data synchronization.</td>
        </tr>
        <tr>
          <td><strong>5. Smart Operations Module</strong></td>
          <td>Joint Collaboration<br><span style="color:#64748b;">Bilal &amp; Afnan</span></td>
          <td>Automated ASTM D5430 4-Point Grading Engine, points calculation per 100m², roll grade assignment (Grade A, Grade B, Scrap), and tamper-proof PDF Quality Certificate generation with SHA-256 seal.</td>
        </tr>
      </tbody>
    </table>

    <h3 style="font-size: 9.5pt; font-weight: bold; color: #0f172a; margin: 10px 0 4px 0;">30-Second Elevator Pitch for Supervisor Dr. Tassawar Iqbal</h3>
    <div style="background:#f1f5f9; border:1px solid #cbd5e1; border-radius:6px; padding:8px 12px; font-size:8.5pt; line-height:1.45; font-style:italic;">
      "Respected Sir, TexEye AI is an offline-first fabric inspection and quality management system. When an operator scans a fabric roll QR tag, our stand camera and rotary encoder measure the fabric as it unwinds. Our YOLO AI model detects flaws and maps their exact metric coordinates without duplicates. Crucially, if factory lighting dips or frames drop, the system actuates a physical amber light and clearly marks that exact meter span as uninspected. If factory Wi-Fi cuts out, everything continues writing safely to local SQLite. When connection returns, it syncs to our cloud FastAPI server, executes standard ASTM 4-point grading, and displays a 2D fabric map on the manager's web dashboard for official PDF quality certificate export."
    </div>
  </div>

  <!-- ==================== DIAGRAM 1 ==================== -->
  <div class="page-break">
    <h2 class="section-header">2. Diagram 1: Overall End-to-End System Workflow <span class="subtag">Core System Blueprint</span></h2>
    <p class="diagram-desc">4-Tier physical architecture showing zero-overlap routing: Mobile/Web Users &rarr; Sensing &amp; Reliability Gate &rarr; Edge AI &amp; Local SQLite Buffer &rarr; Central FastAPI Backend &amp; ASTM Grading.</p>
    
    <div class="diagram-frame">
      $cleanSvg1
    </div>

    <div class="callout-box">
      <strong>Key Supervisor Alignment Highlights:</strong><br>
      &bull; <strong>Reliability Gate:</strong> If camera disconnects, frames drop, or lux &lt; 800, we NEVER guess. We immediately actuate the physical amber relay and mark interval [Y1, Y2] as UNINSPECTED.<br>
      &bull; <strong>Dedicated Vertical Highway:</strong> Notice the clean vertical data bus at x=980 where the Central FastAPI Backend loads the 2D Map &amp; Audit Data into the Web Dashboard without passing through SQLite!
    </div>
  </div>

  <!-- ==================== DIAGRAM 2 ==================== -->
  <div class="page-break">
    <h2 class="section-header">3. Diagram 2: Frontend Architecture &amp; Client Flow <span class="subtag">Mobile &amp; Web Presentation</span></h2>
    <p class="diagram-desc">Hierarchical view of the Flutter Mobile App (Screens S-01 to S-04) and React Web Dashboard (Screens S-05 to S-10) interfacing with dual-protocol REST and WebSocket adapters.</p>
    
    <div class="diagram-frame">
      $cleanSvg2
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> Dual frontend separation guarantees that floor workers are never distracted by administrative grading screens, while quality managers in the office receive live push updates via WebSockets without manual page refreshes.
    </div>
  </div>

  <!-- ==================== DIAGRAM 3 ==================== -->
  <div class="page-break">
    <h2 class="section-header">4. Diagram 3: Backend Architecture &amp; Service Decomposition <span class="subtag">Edge Stand vs Cloud Server</span></h2>
    <p class="diagram-desc">Separation between the local Python edge service running on the Stand PC (HAL, YOLO, Kalman tracker, SQLite) and the central FastAPI cloud server (Ingestion, ASTM grading, PostgreSQL, MinIO).</p>
    
    <div class="diagram-frame">
      $cleanSvg3
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> By running YOLO and SQLite on the Stand PC, zero cloud network latency is introduced during fabric motion. The cloud backend is strictly responsible for aggregation, grading, and multi-user dashboard APIs.
    </div>
  </div>

  <!-- ==================== DIAGRAM 4 ==================== -->
  <div class="page-break">
    <h2 class="section-header">5. Diagram 4: Database Workflow &amp; Outbox Pipeline <span class="subtag">Offline-First Persistence</span></h2>
    <p class="diagram-desc">Offline-to-cloud transactional lifecycle: Local SQLite buffer &rarr; Outbox FSM (PENDING &rarr; IN_FLIGHT &rarr; SYNCED with exponential backoff) &rarr; PostgreSQL relational schema and MinIO object storage.</p>
    
    <div class="diagram-frame">
      $cleanSvg4
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> The Transactional Outbox pattern guarantees at-least-once delivery with zero data loss. If power or factory Wi-Fi cuts out mid-roll, no inspection data is ever lost.
    </div>
  </div>

  <!-- ==================== DIAGRAM 5 ==================== -->
  <div class="page-break">
    <h2 class="section-header">6. Diagram 5: Complete Closed-Loop System Flow <span class="subtag">Step-by-Step 10-Stage Trace</span></h2>
    <p class="diagram-desc">Sequential end-to-end execution path: User &rarr; Frontend &rarr; Stand Backend &rarr; Edge DB &rarr; Central DB &rarr; Web Frontend &rarr; User with decision branches.</p>
    
    <div class="diagram-frame">
      $cleanSvg5
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> This diagram provides the exact linear response required when the supervisor asks: <em>"Walk me through what happens from the second the operator powers on the inspection line until the buyer receives the certificate."</em>
    </div>
  </div>

  <!-- ==================== DIAGRAM 6 ==================== -->
  <div class="page-break">
    <h2 class="section-header">7. Diagram 6: User Roles &amp; System Use Cases <span class="subtag">Actor-Function Boundary</span></h2>
    <p class="diagram-desc">UML Use Case representation showing 5 distinct actors (Floor Operator, Stand Hardware, Quality Inspector, Quality Manager, System Admin) across 12 core system use cases.</p>
    
    <div class="diagram-frame">
      $cleanSvg6
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> Strict role separation ensures floor operators cannot alter ASTM quality thresholds or delete audit logs, while the Autonomous Stand acts as an independent system actor.
    </div>
  </div>

  <!-- ==================== DIAGRAM 7 ==================== -->
  <div class="page-break">
    <h2 class="section-header">8. Diagram 7: Infrastructure &amp; Deployment Topology <span class="subtag">Physical Hardware &amp; Cloud</span></h2>
    <p class="diagram-desc">Physical hardware stand setup (camera, encoder, relays, Stand PC), factory network topology (gigabit switch, Wi-Fi 6), presentation devices, and containerized central server node.</p>
    
    <div class="diagram-frame">
      $cleanSvg7
    </div>

    <div class="callout-box">
      <strong>Supervisor Defense Note:</strong> The central server stack (FastAPI, PostgreSQL, MinIO) is fully containerized with Docker, allowing identical zero-change deployment whether on a factory server room PC or a cloud VPS.
    </div>
  </div>

  <!-- ==================== SUPERVISOR Q&A ==================== -->
  <div class="page-break">
    <h2 class="section-header">9. Anticipated Supervisor Questions &amp; Defense Script <span class="subtag">COMSATS FYP Meeting Prep</span></h2>
    
    <div class="qa-item">
      <div class="qa-q">Q1: How does your system calculate the exact location of a defect on moving fabric?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, we combine two physical measurements: Across the fabric width (X coordinate), our camera lens is calibrated so each pixel corresponds to a fixed millimeter width. Along the fabric length (Y coordinate), an optical rotary encoder (1000 pulses per revolution) is mounted directly to the idler roller. As fabric unwinds, each encoder pulse represents exactly 0.2 mm of movement. When YOLO detects a flaw in frame N, we read the current pulse accumulator to compute the exact meter position along the roll."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q2: How do you prevent counting the same defect multiple times across consecutive video frames?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, because the camera captures at 30 to 60 FPS, a single defect remains visible across 10 to 20 consecutive frames. We implement a multi-frame Kalman filter tracker. The tracker projects the expected position of the flaw based on current roller speed. Consecutive detections matching the same trajectory within a spatial gating threshold are merged into a single unique defect entity."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q3: What happens if factory lighting fluctuates or the camera cable is accidentally disconnected?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, this is our core innovation: the Hardware &amp; Inspection Monitoring Module. We continuously compute mean luminance (lux) and Laplacian variance (blur) on incoming frames. If lux drops below 800 or frames drop, the system immediately trips an amber stack light relay, sounds a warning buzzer, and logs an uninspected span [Y_start, Y_end] in SQLite. We never let uninspected fabric pass silently."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q4: What if the factory loses internet connection during a 500-meter roll inspection?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, our architecture is 100% Offline-First. The inspection stand PC runs a local SQLite WAL database. Every defect coordinate, uninspected interval, and high-resolution JPEG crop writes to local NVMe storage with zero delay. A background sync daemon continuously checks connectivity; once the link is restored, it drains the outbox queue to the cloud server with zero production halt."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q5: How does the ASTM D5430 4-Point grading system actually work?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, the standard ASTM D5430 assigns penalty points based on defect length: 1 point for flaws &le; 3 inches (75 mm), 2 points for 3-6 inches (75-150 mm), 3 points for 6-9 inches (150-230 mm), and 4 points for flaws &gt; 9 inches or holes &gt; 1 inch. No single meter can exceed 4 points. The engine computes Total Points per 100 Square Meters: (Total Points &times; 10,000) / (Length &times; Width). If points &le; 20, it is Grade A; if &le; 40, Grade B; otherwise Scrap."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q6: Can a quality inspector override an AI classification if the model makes a mistake?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, yes. On the Web Dashboard (Screen S-08: Defect Review Gallery), the inspector can zoom into high-res crop images, use digital electronic calipers to verify flaw dimensions, and select a corrected defect class from a dropdown. This updates the database and creates an immutable audit trail entry recording who modified the record and at what timestamp."</div>
    </div>

    <div class="qa-item">
      <div class="qa-q">Q7: Why did you split the system into an Edge Stand Backend and a Central Cloud Backend?</div>
      <div class="qa-a"><strong>Answer:</strong> "Sir, physical fabric inspection is an ultra-low-latency real-time task requiring 30 FPS inference and microsecond encoder interrupts. Cloud networks suffer from latency spikes and outages. By delegating real-time sensing, AI detection, and safety relays to a local Stand PC, we achieve 100% reliability, while the central cloud backend provides centralized reporting, multi-user web access, and ERP integration."</div>
    </div>
  </div>

  <!-- ==================== HAND-DRAWING GUIDE ==================== -->
  <div class="page-break">
    <h2 class="section-header">10. Step-by-Step Handwritten A4 Drawing Instructions <span class="subtag">Notebook Blueprint</span></h2>
    
    <div class="callout-box">
      <strong>Supervisor Meeting Strategy:</strong> Dr. Tassawar Iqbal requested a rough handwritten workflow diagram on paper before your next meeting. Follow these exact steps to sketch Diagram 1 onto an A4 page:
    </div>

    <table class="data-table">
      <thead>
        <tr>
          <th style="width: 15%;">Step #</th>
          <th style="width: 25%;">Drawing Action on A4 Paper</th>
          <th style="width: 60%;">What to Draw &amp; Label</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>Step 1</strong></td>
          <td>Divide page into 4 horizontal bands</td>
          <td>Draw 3 horizontal dotted lines to create 4 tiers: Top = Tier 1 (Users &amp; Screens), Upper-Mid = Tier 2 (Sensors &amp; Reliability), Lower-Mid = Tier 3 (Edge AI &amp; Local SQLite), Bottom = Tier 4 (Cloud Server &amp; Grading).</td>
        </tr>
        <tr>
          <td><strong>Step 2</strong></td>
          <td>Draw Tier 1 (Top Band)</td>
          <td>Draw 3 rectangles: Left = [Floor Operator (Mobile App)], Middle = [Mobile Live View (Alerts)], Right = [Quality Manager (Web Dashboard)], Far Right = [Final PDF Certificate].</td>
        </tr>
        <tr>
          <td><strong>Step 3</strong></td>
          <td>Draw Tier 2 (Upper-Mid Band)</td>
          <td>Draw Left box [Camera + Rotary Encoder]. Draw an arrow into a Center Diamond labelled [Reliable? (Lux/Blur/FPS)]. Draw [NO] arrow right into [Hardware Alarm (Amber Light + Buzzer)].</td>
        </tr>
        <tr>
          <td><strong>Step 4</strong></td>
          <td>Draw Tier 3 (Lower-Mid Band)</td>
          <td>Draw [YES] arrow down from Diamond into [AI YOLO Defect Detection]. Draw arrow right into [Location &amp; Kalman Tracker (X, Y)]. Draw arrow right into [Local SQLite Buffer]. Show fault line from Hardware Alarm down into SQLite labeled "Flag Uninspected Span [Y1, Y2]".</td>
        </tr>
        <tr>
          <td><strong>Step 5</strong></td>
          <td>Draw Tier 4 (Bottom Band)</td>
          <td>Draw Diamond [Network Online?]. [NO] goes to [Offline Outbox Queue]. [YES] goes down into [Central FastAPI Backend]. Connect left to [Central PostgreSQL DB] and [ASTM 4-Point Grading Engine].</td>
        </tr>
        <tr>
          <td><strong>Step 6</strong></td>
          <td>Draw the Upward Return Arrow</td>
          <td>From right edge of [Central FastAPI Backend], draw a line right into the open space and straight UP through the corridor directly into the bottom of [Quality Manager (Web Dashboard)]. Label it "Load 2D Map &amp; Audit Data".</td>
        </tr>
        <tr>
          <td><strong>Step 7</strong></td>
          <td>Draw Final Export Arrow</td>
          <td>Draw an arrow from [Quality Manager (Web Dashboard)] right into [Final PDF Certificate]. Label it "Export Signed PDF".</td>
        </tr>
      </tbody>
    </table>

    <div style="margin-top: 10mm; padding: 12px 16px; background: #f0fdf4; border: 1px solid #86efac; border-radius: 6px; text-align: center;">
      <strong style="color: #15803d; font-size: 10pt;">&check; Complete Architecture Presentation Dossier Verified &amp; Ready</strong><br>
      <span style="font-size: 8.5pt; color: #166534;">Every diagram is available as an individual high-resolution PNG image and standalone vector PDF in <code>diagrams/workflow/</code>.</span>
    </div>
  </div>

</body>
</html>
"@

$guideHtmlPath = Join-Path $docsDir "TexEye_AI_System_Workflow_Guide.html"
$guidePdfPath = Join-Path $docsDir "TexEye_AI_System_Workflow_Guide.pdf"
[IO.File]::WriteAllText($guideHtmlPath, $html, [Text.Encoding]::UTF8)
Write-Host "Guide HTML written to $guideHtmlPath" -ForegroundColor Green

Write-Host "Compiling Master Workflow Guide PDF..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $edgeExe -ArgumentList @(
    "--headless", "--disable-gpu", "--run-all-compositor-stages-before-draw",
    "--no-pdf-header-footer", "--print-to-pdf=$guidePdfPath",
    "file:///$($guideHtmlPath.Replace('\', '/'))"
) -Wait -PassThru -NoNewWindow

Write-Host "Master Guide PDF compiled: $((Get-Item $guidePdfPath).Length) bytes" -ForegroundColor Green
