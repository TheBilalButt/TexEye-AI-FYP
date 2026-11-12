$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
    $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}

$mmdDir = "C:\Users\User\Desktop\FYP\diagrams\mermaid"
$svgDir = "C:\Users\User\Desktop\FYP\diagrams\svg"
$pngDir = "C:\Users\User\Desktop\FYP\diagrams\png"
$tempHtml = "$env:TEMP\mermaid_renderer.html"

# Titles and metadata for each diagram
$diagramMeta = @{
    "01_system_workflow" = @{ Title = "TexEye AI — End-to-End System Workflow"; Sub = "Muhammad Afnan Khan (FA23-BAI-028) • Muhammad Bilal Butt (FA23-BAI-042) | Real-Time Inspection & Reliability Gating" }
    "02_ai_inspection_workflow" = @{ Title = "TexEye AI — AI Vision, Tracking & Metrology Pipeline"; Sub = "Deep Learning Defect Detection, Multi-Frame Tracking & Deduplication Architecture" }
    "03_offline_sync_workflow" = @{ Title = "TexEye AI — Resilient Offline / Online Data Synchronization"; Sub = "Edge Transactional Outbox Pattern & Idempotent Cloud Upsert Engine" }
    "04_hardware_architecture" = @{ Title = "TexEye AI — Hardware Architecture & Physical Interconnections"; Sub = "Physical Inspection Stand, Sensors, Edge Computer & Enterprise Cloud Connections" }
    "05_software_architecture" = @{ Title = "TexEye AI — 5-Tier Layered Software Architecture"; Sub = "Edge Capture, AI Inference, Backend REST/WSS, Persistence & User Client Tiers" }
    "06_use_case_overall" = @{ Title = "TexEye AI — Complete UML Use Case Architecture"; Sub = "Actor Hierarchy, System Boundary & Automated Edge Sensing Subsystem" }
    "07_context_diagram" = @{ Title = "TexEye AI — System Level 0 Context Diagram"; Sub = "Environmental System Boundaries, Hardware Peripherals & Enterprise Cloud Flows" }
    "08_dfd_level_0" = @{ Title = "TexEye AI — Level 0 Data Flow Diagram (DFD L0)"; Sub = "5 Logical System Processes, External Entities & 4 Data Stores (D1 to D4)" }
    "09_dfd_level_1" = @{ Title = "TexEye AI — Level 1 Data Flow Diagram (DFD L1)"; Sub = "Sub-Process Decomposition: Hardware Ingestion, AI Metrology & Central Quality Hubs" }
    "10_component_diagram" = @{ Title = "TexEye AI — UML Component Architecture"; Sub = "Software Components, Provided & Required Interfaces, and Cross-Subsystem Dependencies" }
    "11_deployment_diagram" = @{ Title = "TexEye AI — UML Deployment Architecture (Physical Execution Topology)"; Sub = "Execution Environments, Physical Nodes, Containers & Communication Buses" }
    "12_sequence_inspection" = @{ Title = "TexEye AI — Real-Time Fabric Inspection & Reliability Sequence"; Sub = "Sensory Stream, Reliability Gating & Uninspected Span Isolation" }
    "13_sequence_sync" = @{ Title = "TexEye AI — Resilient Offline Synchronization Sequence"; Sub = "Heartbeat Watchdog, Batch Outbox Transmission & Idempotent Cloud Ingestion" }
    "14_entity_relationship_diagram" = @{ Title = "TexEye AI — Entity Relationship Diagram (ERD)"; Sub = "Relational Data Architecture: Fabric Rolls, Defects, Uninspected Spans & Grading" }
}

Write-Host "Compiling 14 Professional Diagrams from Mermaid Sources..." -ForegroundColor Cyan

foreach ($name in $diagramMeta.Keys | Sort-Object) {
    $mmdFile = Join-Path $mmdDir "$name.mmd"
    $svgFile = Join-Path $svgDir "$name.svg"
    $pngFile = Join-Path $pngDir "$name.png"

    if (-not (Test-Path $mmdFile)) {
        Write-Host "Missing $mmdFile" -ForegroundColor Red
        continue
    }

    $mmdContent = Get-Content $mmdFile -Raw -Encoding UTF8
    $meta = $diagramMeta[$name]
    $title = $meta.Title
    $sub = $meta.Sub

    # Build standalone clean HTML with Mermaid.js
    $html = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.1/dist/mermaid.min.js"></script>
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      padding: 30px;
      background: #ffffff;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      display: inline-block;
      min-width: 100%;
    }
    .header-banner {
      background: #1e293b;
      color: #ffffff;
      padding: 18px 28px;
      border-radius: 8px;
      margin-bottom: 25px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
      border-left: 5px solid #0284c7;
    }
    .header-title {
      font-size: 20px;
      font-weight: 700;
      color: #38bdf8;
      margin: 0 0 6px 0;
    }
    .header-sub {
      font-size: 13px;
      color: #94a3b8;
      margin: 0;
    }
    #diagram-container {
      background: #ffffff;
      padding: 20px;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
      display: inline-block;
    }
    .mermaid {
      display: flex;
      justify-content: center;
    }
    /* Clean UML Styling */
    .node rect, .node circle, .node polygon { stroke-width: 1.5px !important; }
    .label { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important; }
  </style>
</head>
<body>
  <div class="header-banner">
    <div class="header-title">$title</div>
    <div class="header-sub">$sub</div>
  </div>
  <div id="diagram-container">
    <div class="mermaid">
$mmdContent
    </div>
  </div>
  <script>
    mermaid.initialize({
      startOnLoad: true,
      theme: 'default',
      securityLevel: 'loose',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
      flowchart: {
        useMaxWidth: false,
        htmlLabels: true,
        curve: 'basis'
      },
      sequence: {
        useMaxWidth: false,
        showSequenceNumbers: true,
        actorMargin: 50,
        boxMargin: 10,
        boxTextMargin: 5,
        noteMargin: 10
      },
      er: {
        useMaxWidth: false
      }
    });
  </script>
</body>
</html>
"@

    Set-Content -Path $tempHtml -Value $html -Encoding UTF8
    Write-Host "Rendering $name..." -NoNewline

    $fileUrl = "file:///$($tempHtml.Replace('\', '/'))"
    
    # 1. Render PNG via headless Edge
    $argList = @(
        "--headless",
        "--disable-gpu",
        "--virtual-time-budget=8000",
        "--screenshot=`"$pngFile`"",
        "--window-size=1800,1400",
        "--hide-scrollbars",
        "$fileUrl"
    )
    Start-Process -FilePath $edgePath -ArgumentList $argList -Wait

    if (Test-Path $pngFile) {
        $size = (Get-Item $pngFile).Length
        Write-Host " PNG OK ($([math]::Round($size / 1KB, 1)) KB)" -ForegroundColor Green
    } else {
        Write-Host " PNG FAIL" -ForegroundColor Red
    }
}

Write-Host "Batch compilation complete!" -ForegroundColor Cyan

