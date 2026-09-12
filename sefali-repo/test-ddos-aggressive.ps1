# Aggressive DDoS & Rate Limiting Test
# High-speed requests to trigger Cloudflare protection

$site = "https://sohamkunduivar.me"

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "AGGRESSIVE Rate Limiting Test" -ForegroundColor Cyan
Write-Host "Target: 50+ requests in 10 seconds" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Test: Send 70 requests as fast as possible
$blocked = 0
$success = 0
$total = 70

Write-Host "Sending $total rapid requests (no delays)..." -ForegroundColor Yellow
$startTime = Get-Date

# Use background jobs for true parallelism
$jobs = 1..$total | ForEach-Object {
    Start-Job -ScriptBlock {
        param($url, $reqNum)
        try {
            $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 10 -ErrorAction Stop
            return @{
                Request = $reqNum
                Status = $response.StatusCode
                Result = "Success"
            }
        }
        catch {
            $statusCode = $_.Exception.Response.StatusCode.Value__
            return @{
                Request = $reqNum
                Status = $statusCode
                Result = if($statusCode -eq 429) { "RateLimited" } elseif($statusCode -eq 403) { "Blocked" } else { "Error" }
            }
        }
    } -ArgumentList $site, $_
}

# Wait for all jobs to complete
Write-Host "Waiting for responses..." -ForegroundColor Gray
$results = $jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

# Analyze results
Write-Host ""
Write-Host "Results:" -ForegroundColor Cyan
Write-Host "========" -ForegroundColor Cyan

foreach ($result in $results | Sort-Object Request) {
    $num = $result.Request
    $status = $result.Status
    $res = $result.Result
    
    if ($res -eq "Success") {
        $success++
        Write-Host "Request $num : " -NoNewline
        Write-Host "$status OK" -ForegroundColor Green
    }
    elseif ($res -eq "RateLimited") {
        $blocked++
        Write-Host "Request $num : " -NoNewline
        Write-Host "429 RATE LIMITED" -ForegroundColor Red
    }
    elseif ($res -eq "Blocked") {
        $blocked++
        Write-Host "Request $num : " -NoNewline
        Write-Host "403 BLOCKED" -ForegroundColor Red
    }
    else {
        Write-Host "Request $num : $status ERROR" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Total Requests: $total"
Write-Host "Duration: $([math]::Round($duration, 2)) seconds"
Write-Host "Request Rate: $([math]::Round($total/$duration, 2)) req/s" -ForegroundColor Yellow
Write-Host ""
Write-Host "Successful: $success" -ForegroundColor Green
Write-Host "Blocked/Limited: $blocked" -ForegroundColor Red
Write-Host ""

if ($blocked -gt 0) {
    $blockRate = [math]::Round(($blocked / $total) * 100, 2)
    Write-Host "Protection Rate: $blockRate%" -ForegroundColor Green
    Write-Host "✅ Rate limiting is ACTIVE" -ForegroundColor Green
}
else {
    Write-Host "⚠️ No rate limiting triggered" -ForegroundColor Yellow
    Write-Host "Note: Rate limit threshold (50 req/10s) may not have been reached" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Check Cloudflare Dashboard:" -ForegroundColor Cyan
Write-Host "Security -> Events -> Activity Log" -ForegroundColor Gray
Write-Host ""
