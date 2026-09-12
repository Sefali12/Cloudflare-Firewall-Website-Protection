# Step 2: Cloudflare Integration

## Overview
This document details the process of integrating the website with Cloudflare's cloud-based firewall and CDN services.

---

## 2.1 Domain Configuration

| Property | Value |
|----------|-------|
| Domain | `sohamkunduivar.me` |
| Cloudflare Plan | Free |
| Activation Date | January 2026 |

## 2.2 Nameserver Configuration

### Original Nameservers (Before)
```
dns1.registrar-servers.com
dns2.registrar-servers.com
```

### Cloudflare Nameservers (After)
```
lee.ns.cloudflare.com
nena.ns.cloudflare.com
```

### Verification Command
```powershell
Resolve-DnsName sohamkunduivar.me -Type NS
```

### Verification Output
```
Name                           Type   TTL   Section    NameHost
----                           ----   ---   -------    --------
sohamkunduivar.me              NS     86400 Answer     lee.ns.cloudflare.com
sohamkunduivar.me              NS     86400 Answer     nena.ns.cloudflare.com
```

## 2.3 SSL/TLS Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| SSL Mode | Full (Strict) | End-to-end encryption with certificate validation |
| Always Use HTTPS | Enabled | Redirect all HTTP to HTTPS |
| Minimum TLS Version | TLS 1.2 | Block outdated protocols |
| Automatic HTTPS Rewrites | Enabled | Fix mixed content |

## 2.4 DNS Records

| Type | Name | Content | Proxy Status |
|------|------|---------|--------------|
| A/CNAME | @ | GitHub Pages | Proxied (Orange Cloud) |
| CNAME | www | sohamkunduivar.me | Proxied (Orange Cloud) |

## 2.5 Cloudflare Proxy Verification

### CF-Ray Header Test
```powershell
(Invoke-WebRequest -Uri "https://sohamkunduivar.me" -UseBasicParsing).Headers["cf-ray"]
```

### Output
```
9b7b1c5b6b3ac11c-AMS
```

This confirms traffic is routed through Cloudflare's Amsterdam (AMS) edge server.

---

## Traffic Flow Diagram

```
┌─────────────────┐
│   User/Browser  │
└────────┬────────┘
         │ HTTPS Request
         ▼
┌─────────────────┐
│   DNS Resolver  │
│  (Cloudflare)   │
└────────┬────────┘
         │ Resolves to Cloudflare IP
         ▼
┌─────────────────────────────────────────┐
│         CLOUDFLARE EDGE                 │
│  ┌───────────────────────────────────┐  │
│  │ 1. DDoS Protection               │  │
│  │ 2. WAF Rules                     │  │
│  │ 3. Custom Firewall Rules         │  │
│  │ 4. Rate Limiting                 │  │
│  │ 5. Bot Protection                │  │
│  │ 6. SSL/TLS Termination           │  │
│  └───────────────────────────────────┘  │
└────────┬────────────────────────────────┘
         │ Proxied Request (if allowed)
         ▼
┌─────────────────┐
│  Origin Server  │
│  (GitHub Pages) │
└─────────────────┘
```
