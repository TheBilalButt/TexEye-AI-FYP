$pngFiles = Get-ChildItem -Path diagrams\png -Filter *.png
foreach ($file in $pngFiles) {
    $stream = [System.IO.File]::OpenRead($file.FullName)
    $buffer = New-Object byte[] 8
    $read = $stream.Read($buffer, 0, 8)
    $stream.Close()
    $isPng = ($buffer[0] -eq 137 -and $buffer[1] -eq 80 -and $buffer[2] -eq 78 -and $buffer[3] -eq 71)
    Write-Host "$($file.Name): Size=$($file.Length) bytes, ValidPNG=$isPng"
}

Write-Host "`n--- Checking SVGs for illegal entities (like &mdash;) ---"
$svgFiles = Get-ChildItem -Path diagrams\svg -Filter *.svg
foreach ($sfile in $svgFiles) {
    $content = [System.IO.File]::ReadAllText($sfile.FullName)
    if ($content -match '&[a-zA-Z]+;') {
        # find all entity matches
        $matches = [regex]::Matches($content, '&[a-zA-Z0-9#]+;')
        $bad = @()
        foreach ($m in $matches) {
            $val = $m.Value
            if ($val -notin @('&quot;', '&amp;', '&apos;', '&lt;', '&gt;')) {
                $bad += $val
            }
        }
        if ($bad.Count -gt 0) {
            Write-Host "$($sfile.Name): FOUND ILLEGAL XML ENTITIES: $($bad -join ', ')"
        } else {
            Write-Host "$($sfile.Name): Valid XML entities only"
        }
    } else {
        Write-Host "$($sfile.Name): No entities or clean"
    }
}

