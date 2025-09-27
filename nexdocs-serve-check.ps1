# nexdocs-serve-check.ps1
# GitBook serve verification ritual for MJ Ahmad's constitutional archive

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logPath = "nexdocs-changelog.md"
$serveOutput = "serve-output.txt"
$servePort = "http://localhost:4000"

Write-Host "`n🚀 Starting GitBook serve check at $timestamp..."

# Step 1: Clear previous _book folder
if (Test-Path ".\_book") {
    Write-Host "🧼 Clearing stale _book folder..."
    Remove-Item ".\_book" -Recurse -Force
}

# Step 2: Launch gitbook serve and capture output
Write-Host "🧪 Launching gitbook serve..."
Start-Process "gitbook" -ArgumentList "serve" -NoNewWindow -RedirectStandardOutput $serveOutput -PassThru | Out-Null
Start-Sleep -Seconds 5

# Step 3: Check if localhost:4000 is responding
try {
    $response = Invoke-WebRequest -Uri $servePort -UseBasicParsing -TimeoutSec 5
    $status = if ($response.StatusCode -eq 200) { "✅ Book rendered successfully at $servePort" } else { "⚠️ Unexpected response from $servePort" }
} catch {
    $status = "❌ No response from $servePort"
}

# Step 4: Log ritual to changelog
Write-Host "`n📝 Logging to $logPath..."
Add-Content -Path $logPath -Value "`n## GitBook Serve Check – $timestamp"
Add-Content -Path $logPath -Value "- Port: $servePort"
Add-Content -Path $logPath -Value "- Status: $status"

Write-Host "`n🎉 Serve check complete. Changelog updated."
