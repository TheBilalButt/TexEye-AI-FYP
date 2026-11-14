$files = Get-ChildItem -Recurse -Include *.svg,*.html,*.drawio,*.md,*.png
foreach ($f in $files) {
    try {
        $content = [System.IO.File]::ReadAllText($f.FullName)
        if ($content -match '&mdash;|&ndash;|&#151;') {
            Write-Host "$($f.FullName) contains mdash/ndash entity" -ForegroundColor Yellow
        }
        if ($f.Extension -eq '.png') {
            # Check if this PNG is actually an SVG or text file
            if ($content.StartsWith('<?xml') -or $content.StartsWith('<svg')) {
                Write-Host "WARNING: $($f.FullName) is named .png but contains SVG/XML!" -ForegroundColor Red
            }
        }
    } catch {}
}

