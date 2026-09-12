# Step 5: Monitoring & Logging

## Overview
This document covers the security monitoring, analytics, and logging capabilities available for tracking threats and attacks.

---

## 5.1 Security Events Dashboard

**Location:** Security → Events

### What You Can See
- Real-time blocked requests
- Attack source IPs
- Triggered rules
- Geographic distribution of threats
- Request details (headers, user-agent, path)

### Event Details Include
| Field | Description |
|-------|-------------|
| Date/Time | When the event occurred |
| Action | Block, Challenge, Allow, Log |
| Rule | Which rule was triggered |
| IP Address | Source of the request |
| Country | Geographic origin |
| User Agent | Browser/bot identifier |
| URI Path | Requested resource |
| Ray ID | Unique request identifier |

---

## 5.2 Security Analytics

**Location:** Security → Analytics

### Metrics Available
- **Total Threats Blocked** - Count over time period
- **Threats by Country** - Geographic breakdown
- **Threats by Type** - Attack category distribution
- **Top Blocked IPs** - Most frequent attackers
- **Rule Performance** - Which rules trigger most

### Time Ranges
- Last 24 hours
- Last 7 days
- Last 30 days
- Custom range

---

## 5.3 Firewall Test Results Log

### Tests Performed: January 2, 2026

| Time | Test | Source | Result | Rule Triggered |
|------|------|--------|--------|----------------|
| Test 1 | Normal Request | Local | 200 OK | None |
| Test 2 | `.env` Access | Local | 403 Blocked | Path Traversal |
| Test 3 | `.git` Access | Local | 403 Blocked | Path Traversal |
| Test 4 | Path Traversal | Local | 403 Blocked | Path Traversal |
| Test 5 | SQLMap User-Agent | Local | 403 Blocked | Malicious Bots |

### Verification Commands
```powershell
# Check Cloudflare is active
(Invoke-WebRequest -Uri "https://sohamkunduivar.me" -UseBasicParsing).Headers["cf-ray"]
# Result: 9b7b1c5b6b3ac11c-AMS

# Test normal access
curl -s -w "%{http_code}" "https://sohamkunduivar.me/" -o NUL
# Result: 200

# Test .env block
curl -s -w "%{http_code}" "https://sohamkunduivar.me/.env" -o NUL
# Result: 403

# Test .git block
curl -s -w "%{http_code}" "https://sohamkunduivar.me/.git" -o NUL
# Result: 403

# Test path traversal block
curl -s -w "%{http_code}" "https://sohamkunduivar.me/../../../etc/passwd" -o NUL
# Result: 403

# Test malicious bot block
curl -s -w "%{http_code}" -A "sqlmap/1.0" "https://sohamkunduivar.me/" -o NUL
# Result: 403
```

---

## 5.4 Traffic Analytics

**Location:** Analytics → Traffic

### Metrics
- Total requests
- Cached vs uncached
- Bandwidth saved
- Unique visitors
- Requests by country

---

## 5.5 Notifications (Optional)

**Location:** Notifications → Add

### Available Alerts
| Alert Type | Trigger |
|------------|---------|
| Security Events | Threshold of blocked requests |
| DDoS Attacks | Attack detected |
| SSL Certificate | Expiration warning |
| Origin Health | Server unreachable |

---

## 5.6 Log Retention

### Free Plan
- Security Events: 72 hours
- Analytics: 30 days

### Accessing Logs
1. Dashboard → Security → Events
2. Filter by date, action, rule, country
3. Export data (CSV) for reporting

---

## 5.7 Attack Patterns to Monitor

### Common Attack Indicators
| Pattern | Meaning | Response |
|---------|---------|----------|
| Spike in 403s | Active attack attempt | Review source IPs |
| Single IP, many requests | Brute force/scanning | Consider IP block |
| Unusual countries | Potential botnet | Review geo-rules |
| Scanner user-agents | Reconnaissance | Already blocked |
| SQL keywords in URLs | Injection attempt | Already blocked |

### Red Flags
- ⚠️ Sudden traffic spike from single region
- ⚠️ Multiple failed challenges from same IP
- ⚠️ Requests to non-existent admin paths
- ⚠️ Encoded attack payloads in URLs

---

## 5.8 Monitoring Checklist

| Task | Frequency | Purpose |
|------|-----------|---------|
| Review Security Events | Daily | Identify active threats |
| Check Analytics Dashboard | Weekly | Trend analysis |
| Verify rules are triggering | Weekly | Ensure protection active |
| Export logs for reporting | Monthly | Documentation |
| Review blocked IPs | Monthly | Fine-tune rules |
