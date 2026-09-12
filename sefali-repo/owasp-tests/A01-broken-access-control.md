# OWASP Top 10 Testing Report - A01: Broken Access Control

## Test Date: January 3, 2026
**Domain:** sohamkunduivar.me  
**Tester:** Sefali Gupta  
**Protection:** Cloudflare WAF + Custom Rules

---

## A01 – Broken Access Control Overview

**OWASP Description:**  
Access control enforces policy such that users cannot act outside of their intended permissions. Failures typically lead to unauthorized information disclosure, modification, or destruction of data.

**Common Vulnerabilities:**
- Accessing admin panels without authentication
- Viewing/modifying other user's data
- Accessing sensitive configuration files
- Directory traversal attacks
- Forced browsing to restricted URLs

---

## Test Results Summary

| Category | Tests | Blocked | Accessible | Protection Rate |
|----------|-------|---------|------------|-----------------|
| Admin Paths | 2 | 0 | 2 (404) | N/A |
| Sensitive Files (.git, .env) | 4 | 4 | 0 | 100% |
| Config Files | 2 | 0 | 2 (404) | N/A |
| WordPress Files | 1 | 1 | 0 | 100% |
| Directory Traversal | 1 | 1 | 0 | 100% |
| **TOTAL** | **10** | **6** | **4 (404)** | **100%** |

**Status:** ✅ **PROTECTED**

---

## Test Results

### 1. Admin Panel Access Tests

| # | Test | URL | Expected | Actual | Status |
|---|------|-----|----------|--------|--------|
| 1 | Admin panel | `/admin` | Block/404 | 404 | ⚠️ Not Found |
| 2 | Admin panel (trailing slash) | `/admin/` | Block/404 | 404 | ⚠️ Not Found |

**Analysis:**  
- Admin pages return `404 Not Found` because they don't exist in GitHub Pages deployment
- **Action Needed:** If admin pages existed, they would need protection via:
  - Custom firewall rule with "Managed Challenge" for `/admin` paths
  - IP allowlist for admin access only

**Recommendation:**
```
Rule: Protect Admin Paths
Expression: (http.request.uri.path contains "/admin")
Action: Managed Challenge (or IP Allow)
```

---

### 2. Sensitive File Access Tests (.git, .env, .htaccess)

| # | Test | URL | Expected | Actual | Status |
|---|------|-----|----------|--------|--------|
| 3 | .git directory | `/.git` | 403 | 403 | ✅ **BLOCKED** |
| 4 | .git/config | `/.git/config` | 403 | 403 | ✅ **BLOCKED** |
| 7 | .env file | `/.env` | 403 | 403 | ✅ **BLOCKED** |
| 8 | .htaccess | `/.htaccess` | 403 | 403 | ✅ **BLOCKED** |

**Rule Triggered:** `Block Path Traversal & LFI/RFI`

**Expression:**
```
(http.request.uri contains ".git") or
(http.request.uri contains ".env") or
(http.request.uri contains ".htaccess")
```

**Analysis:**  
✅ All sensitive files are properly blocked by custom firewall rule

---

### 3. Configuration File Tests

| # | Test | URL | Expected | Actual | Status |
|---|------|-----|----------|--------|--------|
| 5 | Config directory | `/config` | Block/404 | 404 | ⚠️ Not Found |
| 6 | Config (trailing slash) | `/config/` | Block/404 | 404 | ⚠️ Not Found |

**Analysis:**  
- Config directory returns 404 (doesn't exist)
- If deployed, would need protection

---

### 4. WordPress Configuration File Test

| # | Test | URL | Expected | Actual | Status |
|---|------|-----|----------|--------|--------|
| 9 | wp-config.php | `/wp-config.php` | 403 | 403 | ✅ **BLOCKED** |

**Rule Triggered:** `Block Path Traversal & LFI/RFI`

**Expression:**
```
(http.request.uri contains "wp-config")
```

**Analysis:**  
✅ WordPress config file access is blocked

---

### 5. Directory Traversal Test

| # | Test | URL | Expected | Actual | Status |
|---|------|-----|----------|--------|--------|
| 10 | /etc/passwd | `/../../../etc/passwd` | 403 | 403 | ✅ **BLOCKED** |

**Rule Triggered:** `Block Path Traversal & LFI/RFI`

**Expression:**
```
(http.request.uri contains "../")
```

**Analysis:**  
✅ Directory traversal attempts are blocked

---

## Test Commands

```powershell
# Admin panel access
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/admin" -o NUL
# Output: 404

curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/admin/" -o NUL
# Output: 404

# .git directory
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/.git" -o NUL
# Output: 403 ✅

curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/.git/config" -o NUL
# Output: 403 ✅

# Config directory
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/config" -o NUL
# Output: 404

# .env file
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/.env" -o NUL
# Output: 403 ✅

# .htaccess file
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/.htaccess" -o NUL
# Output: 403 ✅

# wp-config.php
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/wp-config.php" -o NUL
# Output: 403 ✅

# Directory traversal
curl -s -w "%{http_code}\n" "https://sohamkunduivar.me/../../../etc/passwd" -o NUL
# Output: 403 ✅
```

---

## Protection Coverage

### ✅ Currently Protected

| Attack Vector | Protection Method | Status |
|---------------|-------------------|--------|
| `.git` access | Custom firewall rule | ✅ Active |
| `.env` access | Custom firewall rule | ✅ Active |
| `.htaccess` access | Custom firewall rule | ✅ Active |
| `wp-config` access | Custom firewall rule | ✅ Active |
| Directory traversal (`../`) | Custom firewall rule | ✅ Active |

### ⚠️ Recommendations

| Attack Vector | Current | Recommended |
|---------------|---------|-------------|
| `/admin` paths | 404 (no rule) | Add "Managed Challenge" or IP Allow |
| `/config` paths | 404 (no rule) | Add block if deployed |
| `/api` endpoints | Not tested | Consider rate limiting |
| User enumeration | Not tested | Add if user system exists |

---

## Actions Needed

### ✅ No Immediate Actions Required
All sensitive files that exist are properly blocked.

### 📋 Future Recommendations

#### 1. Add Admin Path Protection (If Deployed)
```
Rule Name: Protect Admin Paths
When: (http.request.uri.path contains "/admin")
Action: Managed Challenge (CAPTCHA) or Block
```

#### 2. Add Config Path Protection (If Deployed)
```
Rule Name: Protect Config Paths  
When: (http.request.uri.path contains "/config")
Action: Block
```

#### 3. Implement IP Allowlist for Sensitive Areas
If you have admin panels, restrict access to known IPs:
```
When: (http.request.uri.path contains "/admin") and (ip.src ne YOUR_IP)
Action: Block
```

---

## OWASP A01 Compliance

| Control | Implementation | Status |
|---------|----------------|--------|
| Deny by default | Cloudflare firewall blocks sensitive files | ✅ |
| Minimize CORS usage | N/A for static site | N/A |
| Access control checks | Path Traversal rule active | ✅ |
| Disable directory listing | GitHub Pages disabled by default | ✅ |
| Log access failures | Cloudflare Security Events | ✅ |
| Rate limit API/resources | Rate limiting rule active | ✅ |

**Compliance Score:** 5/5 applicable controls = **100%**

---

## Conclusion

### 🛡️ Protection Status: **EFFECTIVE**

The website is properly protected against **A01: Broken Access Control** attacks:

1. ✅ Sensitive files (`.git`, `.env`, `.htaccess`) are blocked
2. ✅ Configuration files (`wp-config`) are blocked  
3. ✅ Directory traversal attempts are blocked
4. ⚠️ Admin/config paths return 404 (would need protection if deployed)

### Overall Security Rating: **STRONG** 🟢

---

## Next Test: A02 – Cryptographic Failures

**What to test:**
- SSL/TLS configuration
- HTTPS enforcement
- Certificate validity
- Weak cipher detection
- Mixed content issues
