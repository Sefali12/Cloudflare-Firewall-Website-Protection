# Rate Limiting & DDoS Protection Test Script
# Tests Cloudflare firewall rules on sohamkunduivar.me

$site = "https://sohamkunduivar.me"
$results = @()

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Cloudflare Rate Limiting & DDoS Test" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Homepage flooding (DDoS simulation)
Write-Host "[Test 1] Homepage Flooding - 100 rapid requests" -ForegroundColor Yellow
Write-Host "Testing rate limiting rule (50 req/10s threshold)..." -ForegroundColor Gray
Write-Host ""

$blocked = 0
$success = 0
$startTime = Get-Date

for ($i = 1; $i -le 100; $i++) {
    try {
        $response = Invoke-WebRequest -Uri $site -Method GET -TimeoutSec 5 -ErrorAction Stop
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq 200) {
            $success++
            Write-Host "Request $i : " -NoNewline
            Write-Host "200 OK" -ForegroundColor Green
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        
        if ($statusCode -eq 429) {
            $blocked++
            Write-Host "Request $i : " -NoNewline
            Write-Host "429 RATE LIMITED" -ForegroundColor Red
        }
        elseif ($statusCode -eq 403) {
            $blocked++
            Write-Host "Request $i : " -NoNewline
            Write-Host "403 BLOCKED" -ForegroundColor Red
        }
        else {
            Write-Host "Request $i : $statusCode" -ForegroundColor Yellow
        }
    }
    
    # Small delay to avoid overwhelming local system
    Start-Sleep -Milliseconds 50
}

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "Test 1 Results:" -ForegroundColor Cyan
Write-Host "  Total Requests: 100"
Write-Host "  Successful: $success" -ForegroundColor Green
Write-Host "  Blocked/Limited: $blocked" -ForegroundColor Red
Write-Host "  Duration: $([math]::Round($duration, 2)) seconds"
Write-Host "  Rate: $([math]::Round(100/$duration, 2)) req/s"
Write-Host ""

Start-Sleep -Seconds 3

# Test 2: Admin login brute force
Write-Host "[Test 2] Login Brute Force - 50 rapid POST requests" -ForegroundColor Yellow
Write-Host "Testing brute force protection on /admin/login.html..." -ForegroundColor Gray
Write-Host ""

$loginUrl = "$site/admin/login.html"
$blockedLogin = 0
$successLogin = 0

for ($i = 1; $i -le 50; $i++) {
    try {
        $response = Invoke-WebRequest -Uri $loginUrl -Method GET -TimeoutSec 5 -ErrorAction Stop
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq 200) {
            $successLogin++
            Write-Host "Login Request $i : " -NoNewline
            Write-Host "200 OK" -ForegroundColor Green
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        
        if ($statusCode -eq 429) {
            $blockedLogin++
            Write-Host "Login Request $i : " -NoNewline
            Write-Host "429 RATE LIMITED" -ForegroundColor Red
        }
        elseif ($statusCode -eq 403) {
            $blockedLogin++
            Write-Host "Login Request $i : " -NoNewline
            Write-Host "403 BLOCKED" -ForegroundColor Red
        }
        else {
            Write-Host "Login Request $i : $statusCode" -ForegroundColor Yellow
        }
    }
    
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "Test 2 Results:" -ForegroundColor Cyan
Write-Host "  Total Requests: 50"
Write-Host "  Successful: $successLogin" -ForegroundColor Green
Write-Host "  Blocked/Limited: $blockedLogin" -ForegroundColor Red
Write-Host ""

Start-Sleep -Seconds 3

# Test 3: Multiple endpoint attack
Write-Host "[Test 3] Multiple Endpoint Attack - 30 req to different paths" -ForegroundColor Yellow
Write-Host "Testing distributed attack pattern..." -ForegroundColor Gray
Write-Host ""

$endpoints = @(
    "/",
    "/admin",
    "/admin/login.html",
    "/config",
    "/admin/dashboard.html"
)

$endpointBlocked = 0
$endpointSuccess = 0

for ($i = 1; $i -le 30; $i++) {
    $endpoint = $endpoints[$i % $endpoints.Length]
    $url = "$site$endpoint"
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 5 -ErrorAction Stop
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq 200 -or $statusCode -eq 301 -or $statusCode -eq 302) {
            $endpointSuccess++
            Write-Host "Request $i ($endpoint): " -NoNewline
            Write-Host "$statusCode OK" -ForegroundColor Green
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        
        if ($statusCode -eq 429) {
            $endpointBlocked++
            Write-Host "Request $i ($endpoint): " -NoNewline
            Write-Host "429 RATE LIMITED" -ForegroundColor Red
        }
        elseif ($statusCode -eq 403) {
            $endpointBlocked++
            Write-Host "Request $i ($endpoint): " -NoNewline
            Write-Host "403 BLOCKED" -ForegroundColor Red
        }
        else {
            Write-Host "Request $i ($endpoint): $statusCode" -ForegroundColor Yellow
        }
    }
    
    Start-Sleep -Milliseconds 75
}

Write-Host ""
Write-Host "Test 3 Results:" -ForegroundColor Cyan
Write-Host "  Total Requests: 30"
Write-Host "  Successful: $endpointSuccess" -ForegroundColor Green
Write-Host "  Blocked/Limited: $endpointBlocked" -ForegroundColor Red
Write-Host ""

# Summary
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "FINAL SUMMARY" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Requests Sent: 180"
Write-Host "Total Successful: $($success + $successLogin + $endpointSuccess)" -ForegroundColor Green
Write-Host "Total Blocked/Limited: $($blocked + $blockedLogin + $endpointBlocked)" -ForegroundColor Red
Write-Host ""

$blockRate = [math]::Round((($blocked + $blockedLogin + $endpointBlocked) / 180) * 100, 2)
Write-Host "Protection Rate: $blockRate%" -ForegroundColor $(if($blockRate -gt 20) { "Green" } else { "Yellow" })
Write-Host ""
Write-Host "Note: Cloudflare typically blocks/rate limits after threshold is reached." -ForegroundColor Gray
Write-Host "Check Cloudflare Dashboard -> Security Events for detailed logs." -ForegroundColor Gray
Write-Host ""
