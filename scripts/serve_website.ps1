# TexEye AI - Local Website Server
param(
    [int]$Port = 8080
)

$websitePath = "C:\Users\User\Desktop\FYP\website"
$url = "http://localhost:$Port/index.html"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "       TexEye AI Interactive Documentation Portal " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Serving from: $websitePath"
Write-Host "Access URL:   $url" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the local web server.`n"

# Launch Microsoft Edge to open the portal
Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList $url

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
try {
    $listener.Start()
} catch {
    Write-Warning "Port $Port is in use or requires elevation. Opening direct local file instead."
    Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "file:///$($websitePath.Replace('\', '/'))/index.html"
    exit
}

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $localPath = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($localPath)) {
        $localPath = "index.html"
    }

    $filePath = Join-Path "C:\Users\User\Desktop\FYP" $localPath
    if (-not (Test-Path $filePath)) {
        $filePath = Join-Path $websitePath $localPath
    }

    if (Test-Path $filePath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $contentType = switch ($ext) {
            ".html" { "text/html; charset=utf-8" }
            ".css"  { "text/css; charset=utf-8" }
            ".js"   { "application/javascript; charset=utf-8" }
            ".svg"  { "image/svg+xml" }
            ".png"  { "image/png" }
            ".json" { "application/json" }
            ".md"   { "text/plain; charset=utf-8" }
            Default { "application/octet-stream" }
        }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = $contentType
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
        $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $localPath")
        $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
    }
    $response.Close()
}

