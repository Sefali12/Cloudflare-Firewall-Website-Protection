# Step 3: Firewall Rules Configuration

## Overview
This document details the 5 custom firewall rules and 1 rate limiting rule configured to protect the website.

---

## Custom Rules Summary

| # | Rule Name | Action | OWASP Coverage |
|---|-----------|--------|----------------|
| 1 | Block SQL Injection Attacks | Block | A03:2021 - Injection |
| 2 | Block XSS & Script Injection | Block | A03:2021 - Injection |
| 3 | Block Malicious Bots & Scanners | Block | A07:2021 - Auth Failures |
| 4 | Block Path Traversal & LFI/RFI | Block | A01:2021 - Broken Access |
| 5 | Block High-Risk Countries | Managed Challenge | Geo-blocking |
| 6 | Rate Limit - DDoS Protection | Block | A07:2021 - Auth Failures |

---

## Rule 1: Block SQL Injection Attacks

### Purpose
Prevents SQL injection attacks that attempt to manipulate database queries through user input.

### Expression
```
(lower(http.request.uri.query) contains "select ") or 
(lower(http.request.uri.query) contains "union ") or 
(lower(http.request.uri.query) contains "insert ") or 
(lower(http.request.uri.query) contains "delete ") or 
(lower(http.request.uri.query) contains "drop ") or 
(lower(http.request.uri.query) contains "update ") or 
(lower(http.request.uri.query) contains "--") or 
(lower(http.request.uri.query) contains "/*")
```

### Action: Block

### Threats Mitigated
- SQL Injection (SQLi)
- Database manipulation
- Data exfiltration
- Authentication bypass

---

## Rule 2: Block XSS & Script Injection

### Purpose
Prevents Cross-Site Scripting attacks that inject malicious JavaScript into web pages.

### Expression
```
(lower(http.request.uri) contains "<script") or 
(lower(http.request.uri) contains "javascript:") or 
(lower(http.request.uri) contains "onerror=") or 
(lower(http.request.uri) contains "onclick=") or 
(lower(http.request.uri) contains "onload=") or 
(lower(http.request.uri) contains "onmouseover=") or 
(lower(http.request.uri) contains "eval(") or 
(lower(http.request.uri) contains "document.cookie")
```

### Action: Block

### Threats Mitigated
- Reflected XSS
- Stored XSS
- DOM-based XSS
- Cookie theft
- Session hijacking

---

## Rule 3: Block Malicious Bots & Scanners

### Purpose
Blocks known security scanning tools and malicious bots that probe for vulnerabilities.

### Expression
```
(lower(http.user_agent) contains "sqlmap") or 
(lower(http.user_agent) contains "nikto") or 
(lower(http.user_agent) contains "nmap") or 
(lower(http.user_agent) contains "masscan") or 
(lower(http.user_agent) contains "nessus") or 
(lower(http.user_agent) contains "openvas") or 
(lower(http.user_agent) contains "burpsuite") or 
(lower(http.user_agent) contains "acunetix") or 
(lower(http.user_agent) contains "dirbuster") or 
(http.user_agent eq "")
```

### Action: Block

### Threats Mitigated
- Automated vulnerability scanning
- Reconnaissance attacks
- Brute force enumeration
- Zero user-agent attacks

---

## Rule 4: Block Path Traversal & LFI/RFI

### Purpose
Prevents directory traversal attacks and unauthorized access to sensitive files.

### Expression
```
(http.request.uri contains "../") or 
(http.request.uri contains "..%2f") or 
(http.request.uri contains "%2e%2e") or 
(http.request.uri contains "/etc/passwd") or 
(http.request.uri contains "/etc/shadow") or 
(http.request.uri contains "wp-config") or 
(http.request.uri contains ".env") or 
(http.request.uri contains ".git") or 
(http.request.uri contains ".htaccess")
```

### Action: Block

### Threats Mitigated
- Local File Inclusion (LFI)
- Remote File Inclusion (RFI)
- Directory traversal
- Sensitive file exposure
- Configuration file access

---

## Rule 5: Block High-Risk Countries

### Purpose
Adds an additional challenge for traffic from countries with high rates of malicious activity.

### Expression
```
(ip.geoip.country in {"RU" "CN" "KP"})
```

### Action: Managed Challenge (CAPTCHA)

### Note
Using "Managed Challenge" instead of "Block" allows legitimate users from these countries to access the site after completing a CAPTCHA verification.

---

## Rule 6: Rate Limiting - DDoS & Brute Force Protection

### Purpose
Prevents denial-of-service attacks and brute force attempts by limiting request rates.

### Expression
```
(http.request.uri.path eq "/") or 
(http.request.uri.path contains "/api") or 
(http.request.uri.path contains "/login") or 
(http.request.uri.path contains "/admin")
```

### Configuration
| Setting | Value |
|---------|-------|
| Characteristic | IP |
| Requests | 50 |
| Period | 10 seconds |
| Action | Block |
| Duration | 1 minute |

### Threats Mitigated
- DDoS attacks
- Brute force attacks
- Credential stuffing
- Resource exhaustion

---

## Firewall Test Results

| Attack Type | Test Payload | Response Code | Result |
|-------------|--------------|---------------|--------|
| Normal Request | `/` | 200 | ✅ Allowed |
| Path Traversal | `/.env` | 403 | 🛡️ Blocked |
| Path Traversal | `/.git` | 403 | 🛡️ Blocked |
| Path Traversal | `/../../../etc/passwd` | 403 | 🛡️ Blocked |
| Malicious Bot | User-Agent: `sqlmap` | 403 | 🛡️ Blocked |

### Test Commands Used
```powershell
# Normal request
curl -s -w "%{http_code}" "https://sohamkunduivar.me/" -o NUL
# Output: 200

# Path traversal - .env
curl -s -w "%{http_code}" "https://sohamkunduivar.me/.env" -o NUL
# Output: 403

# Path traversal - .git
curl -s -w "%{http_code}" "https://sohamkunduivar.me/.git" -o NUL
# Output: 403

# Malicious bot
curl -s -w "%{http_code}" -A "sqlmap/1.0" "https://sohamkunduivar.me/" -o NUL
# Output: 403
```
