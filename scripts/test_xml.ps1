$files = Get-ChildItem -Path "diagrams\svg" -Filter "*.svg"
Write-Host "Found $($files.Count) SVG files."

$hasError = $false
foreach ($f in $files) {
    try {
        [xml]$doc = Get-Content -Path $f.FullName -Raw
        Write-Host "[VALID] $($f.Name)" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] $($f.Name) : $($_.Exception.Message)" -ForegroundColor Red
        $hasError = $true
    }
}

if ($hasError) {
    exit 1
} else {
    Write-Host "All SVG files are valid XML!" -ForegroundColor Cyan
}
