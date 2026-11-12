# TexEye AI - Batch Diagram Render Script
# Automatically exports all SVG diagrams to high-resolution PNGs via headless Microsoft Edge

$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
    $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}

$svgDir = "C:\Users\User\Desktop\FYP\diagrams\svg"
$pngDir = "C:\Users\User\Desktop\FYP\diagrams\png"

if (-not (Test-Path $pngDir)) {
    New-Item -ItemType Directory -Force -Path $pngDir | Out-Null
}

$diagramConfigs = @(
    @{ Name = "01_system_workflow"; Width = 1400; Height = 1290 },
    @{ Name = "02_ai_inspection_workflow"; Width = 1400; Height = 1320 },
    @{ Name = "03_offline_sync_workflow"; Width = 1400; Height = 1130 },
    @{ Name = "04_hardware_architecture"; Width = 1450; Height = 1060 },
    @{ Name = "05_software_architecture"; Width = 1450; Height = 1270 },
    @{ Name = "06_use_case_overall"; Width = 1620; Height = 1050 },
    @{ Name = "07_context_diagram"; Width = 1450; Height = 960 },
    @{ Name = "08_dfd_level_0"; Width = 1450; Height = 900 },
    @{ Name = "09_dfd_level_1"; Width = 1450; Height = 970 },
    @{ Name = "10_component_diagram"; Width = 1450; Height = 990 },
    @{ Name = "11_deployment_diagram"; Width = 1450; Height = 900 },
    @{ Name = "12_sequence_inspection"; Width = 1450; Height = 1010 },
    @{ Name = "13_sequence_sync"; Width = 1450; Height = 910 },
    @{ Name = "14_entity_relationship_diagram"; Width = 1550; Height = 990 }
)

Write-Host "Starting TexEye AI Diagram PNG Rendering with Optimized Alignment..." -ForegroundColor Cyan

foreach ($cfg in $diagramConfigs) {
    $name = $cfg.Name
    $w = $cfg.Width
    $h = $cfg.Height
    $svgFile = Join-Path $svgDir "$name.svg"
    $pngFile = Join-Path $pngDir "$name.png"

    if (Test-Path $svgFile) {
        Write-Host "Rendering $name ($w x $h)..." -NoNewline
        $url = "file:///$($svgFile.Replace('\', '/'))"
        
        $argList = @(
            "--headless",
            "--disable-gpu",
            "--screenshot=`"$pngFile`"",
            "--window-size=$w,$h",
            "--hide-scrollbars",
            "$url"
        )

        Start-Process -FilePath $edgePath -ArgumentList $argList -Wait
        
        if (Test-Path $pngFile) {
            $size = (Get-Item $pngFile).Length
            Write-Host " OK ($([math]::Round($size / 1KB, 1)) KB)" -ForegroundColor Green
        } else {
            Write-Host " FAILED (Output file not created)" -ForegroundColor Red
        }
    } else {
        Write-Host "Skipping $($name): SVG not found." -ForegroundColor Yellow
    }
}

Write-Host "`nAll diagrams re-rendered with tight, professional bounds to $pngDir" -ForegroundColor Cyan
