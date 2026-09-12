# Step 4: WAF (Web Application Firewall) Configuration

## Overview
This document details the WAF settings and security configurations enabled on the Cloudflare Free plan.

---

## 4.1 Managed Rulesets

### Cloudflare Managed Ruleset
| Setting | Value |
|---------|-------|
| Status | Enabled |
| Default Action | Managed Challenge |

Provides automatic protection against:
- Common vulnerabilities
- Known attack patterns
- CVE-based exploits

### Cloudflare OWASP Core Ruleset
| Setting | Value |
|---------|-------|
| Status | Enabled |
| Paranoia Level | PL2 (Medium) |
| Anomaly Score Threshold | Medium (25+) |

Based on OWASP ModSecurity Core Rule Set (CRS).

---

## 4.2 Security Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| Security Level | Medium | Balanced challenge threshold |
| Challenge Passage | 30 minutes | Time before re-challenge |
| Browser Integrity Check | Enabled | Validates browser headers |

---

## 4.3 Bot Protection

| Setting | Value |
|---------|-------|
| Bot Fight Mode | Enabled |
| Block AI Scrapers | Enabled |

### Bot Fight Mode
Automatically challenges or blocks bots that:
- Exhibit non-human behavior
- Have suspicious request patterns
- Match known malicious bot signatures

**Does NOT block:**
- Googlebot
- Bingbot
- Other verified search engines

---

## 4.4 DDoS Protection

### HTTP DDoS Attack Protection
| Setting | Value |
|---------|-------|
| Status | Enabled (Always On) |
| Sensitivity | Medium |
| Action | Managed Challenge |

### Network-layer DDoS Protection
| Setting | Value |
|---------|-------|
| Status | Enabled (Automatic) |
| Capacity | Unlimited |

Cloudflare's Anycast network absorbs DDoS attacks at the edge, never reaching the origin server.

---

## 4.5 SSL/TLS Security

| Setting | Value |
|---------|-------|
| SSL Mode | Full (Strict) |
| Minimum TLS Version | TLS 1.2 |
| Always Use HTTPS | Enabled |
| Automatic HTTPS Rewrites | Enabled |

### SSL Modes Explained
| Mode | Description |
|------|-------------|
| Off | No encryption |
| Flexible | HTTPS to Cloudflare, HTTP to origin |
| Full | HTTPS throughout, self-signed cert OK |
| **Full (Strict)** | HTTPS throughout, valid CA cert required ✓ |

---

## 4.6 Free Plan Limitations

| Feature | Free Plan | Pro Plan |
|---------|-----------|----------|
| Custom Rules | 5 | 20 |
| Rate Limiting Rules | 1 | 2 |
| WAF Managed Rules | Limited | Full |
| Advanced Bot Management | ❌ | ❌ (Enterprise) |
| Page Rules | 3 | 20 |
| Firewall Analytics | Basic | Advanced |

### Workarounds for Free Plan
1. **Combine rules** - Use OR operators to check multiple conditions in one rule
2. **Prioritize** - Focus on most critical attack vectors (SQLi, XSS, Path Traversal)
3. **Use Bot Fight Mode** - Free automated bot protection
4. **Leverage managed rules** - Basic WAF is included free

---

## 4.7 Security Features Summary

```
┌─────────────────────────────────────────────────────────────┐
│                 SECURITY LAYERS ENABLED                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Layer 1: DDoS Protection                                   │
│  ├── Network-layer (L3/L4): Unlimited, automatic            │
│  └── Application-layer (L7): HTTP flood protection          │
│                                                             │
│  Layer 2: Bot Protection                                    │
│  ├── Bot Fight Mode: Enabled                                │
│  └── AI Scraper Blocking: Enabled                           │
│                                                             │
│  Layer 3: WAF (Web Application Firewall)                    │
│  ├── Cloudflare Managed Ruleset: Enabled                    │
│  └── OWASP Core Ruleset: Enabled (PL2)                      │
│                                                             │
│  Layer 4: Custom Firewall Rules (5 rules)                   │
│  ├── SQL Injection Protection                               │
│  ├── XSS Protection                                         │
│  ├── Malicious Bot Blocking                                 │
│  ├── Path Traversal Protection                              │
│  └── Geo-blocking (High-risk countries)                     │
│                                                             │
│  Layer 5: Rate Limiting (1 rule)                            │
│  └── DDoS & Brute Force Protection                          │
│                                                             │
│  Layer 6: SSL/TLS Encryption                                │
│  └── Full (Strict) mode with TLS 1.2+                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
