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
    @{ Name = "01_system_workflow"; Width = 1000; Height = 1250 },
    @{ Name = "02_ai_inspection_workflow"; Width = 1000; Height = 1250 },
    @{ Name = "03_offline_sync_workflow"; Width = 1000; Height = 1250 },
    @{ Name = "04_hardware_architecture"; Width = 1200; Height = 850 },
    @{ Name = "05_software_architecture"; Width = 1200; Height = 950 },
    @{ Name = "06_use_case_overall"; Width = 1400; Height = 1150 },
    @{ Name = "07_context_diagram"; Width = 1100; Height = 850 },
    @{ Name = "08_dfd_level_0"; Width = 1200; Height = 850 },
    @{ Name = "09_dfd_level_1"; Width = 1200; Height = 850 },
    @{ Name = "10_component_diagram"; Width = 1350; Height = 900 },
    @{ Name = "11_deployment_diagram"; Width = 1350; Height = 900 },
    @{ Name = "12_sequence_inspection"; Width = 1100; Height = 850 },
    @{ Name = "13_sequence_sync"; Width = 1100; Height = 850 },
    @{ Name = "14_entity_relationship_diagram"; Width = 1350; Height = 950 }
)

Write-Host "Starting TexEye AI Academic B&W Diagram PNG Rendering..." -ForegroundColor Cyan

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
            "--default-background-color=00ffffff",
            "`"$url`""
        )
        
        $proc = Start-Process -FilePath $edgePath -ArgumentList $argList -Wait -PassThru -NoNewWindow
        
        if (Test-Path $pngFile) {
            $size = (Get-Item $pngFile).Length / 1KB
            Write-Host " OK ($([math]::Round($size, 1)) KB)" -ForegroundColor Green
        } else {
            Write-Host " FAILED" -ForegroundColor Red
        }
    } else {
        Write-Host "Skipping $name (SVG not found)" -ForegroundColor Yellow
    }
}

Write-Host "`nAll diagrams re-rendered in clean academic style to $pngDir" -ForegroundColor Cyan
