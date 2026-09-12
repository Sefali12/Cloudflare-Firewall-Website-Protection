# Step 1: Prerequisites Setup

## Overview
This document details the prerequisites and initial setup completed for the cloud-based firewall project.

---

## 1.1 Website Setup

### Hosting Platform: GitHub Pages

**Repository:** [github.com/Sefali12/Cloudflare-Firewall-Website-Protection](https://github.com/Sefali12/Cloudflare-Firewall-Website-Protection)

#### Steps Completed:

1. **Created GitHub Repository**
   - Repository name: `cloudflare-firewall-demo`
   - Visibility: Public
   - Owner: `Sefali12`

2. **Created Website Files**
   - `index.html` - Main demo website with firewall status display
   - Simple, clean design showing protection status

3. **Enabled GitHub Pages**
   - Settings → Pages → Source: `main` branch
   - Initial URL: `https://0xivar.github.io/cloudflare-firewall-demo`

4. **Connected Custom Domain**
   - Added `sohamkunduivar.me` in GitHub Pages settings
   - Created CNAME record pointing to GitHub Pages

---

## 1.2 Domain Configuration

### Domain Details

| Property | Value |
|----------|-------|
| Domain Name | `sohamkunduivar.me` |
| TLD | `.me` |
| Registrar | [Your Registrar] |
| Purpose | Firewall demo website |

### Why .me Domain?
- Professional appearance
- Available with GitHub Student Pack
- Works well for personal/portfolio projects

---

## 1.3 Cloudflare Account Setup

### Registration Completed

1. **Created Account**
   - URL: [cloudflare.com](https://www.cloudflare.com)
   - Plan: Free

2. **Added Domain**
   - Added `sohamkunduivar.me` to Cloudflare
   - Cloudflare scanned existing DNS records automatically

3. **Received Nameservers**
   ```
   lee.ns.cloudflare.com
   nena.ns.cloudflare.com
   ```

### Free Plan Features Used

| Feature | Status | Usage |
|---------|--------|-------|
| DDoS Protection | ✅ Active | Unlimited mitigation |
| SSL Certificate | ✅ Active | Universal SSL |
| CDN | ✅ Active | Global edge network |
| Custom Firewall Rules | ✅ Active | 5/5 rules used |
| Rate Limiting | ✅ Active | 1/1 rule used |
| Bot Fight Mode | ✅ Active | Enabled |
| WAF Managed Rules | ✅ Active | Basic rules |
| Security Analytics | ✅ Active | Basic dashboard |

---

## 1.4 DNS Concepts Applied

### What is DNS?
DNS (Domain Name System) translates human-readable domain names (e.g., `sohamkunduivar.me`) to IP addresses that computers use to communicate.

### DNS Records Configured

| Record Type | Name | Value | Proxy |
|-------------|------|-------|-------|
| CNAME | @ | 0xivar.github.io | ✅ Proxied |
| CNAME | www | sohamkunduivar.me | ✅ Proxied |

### How Cloudflare Proxies Our Traffic

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│              │     │                 │     │                  │
│    User      │────▶│   Cloudflare    │────▶│   GitHub Pages   │
│   Browser    │     │   (Firewall)    │     │ (Origin Server)  │
│              │◀────│                 │◀────│                  │
└──────────────┘     └─────────────────┘     └──────────────────┘
                            │
                            ▼
                     ┌─────────────────┐
                     │ Security Checks │
                     │ • 5 Custom Rules│
                     │ • Rate Limiting │
                     │ • Bot Detection │
                     │ • DDoS Shield   │
                     │ • WAF Rules     │
                     └─────────────────┘
```

### Nameserver Change Process (Completed)

1. ✅ Added domain to Cloudflare
2. ✅ Cloudflare scanned existing DNS records
3. ✅ Updated nameservers at domain registrar
4. ✅ Waited for DNS propagation (~5 minutes)
5. ✅ Verified with `Resolve-DnsName` command

---

## 1.5 Verification

### DNS Verification Command
```powershell
Resolve-DnsName sohamkunduivar.me -Type NS
```

### Output
```
Name                           Type   TTL   Section    NameHost
----                           ----   ---   -------    --------
sohamkunduivar.me              NS     86400 Answer     lee.ns.cloudflare.com
sohamkunduivar.me              NS     86400 Answer     nena.ns.cloudflare.com
```

### Cloudflare Proxy Verification
```powershell
(Invoke-WebRequest -Uri "https://sohamkunduivar.me" -UseBasicParsing).Headers["cf-ray"]
```

### Output
```
9b7b1c5b6b3ac11c-AMS
```
✅ Traffic confirmed routing through Cloudflare Amsterdam (AMS) edge server

---

## 1.6 Prerequisites Checklist (Completed)

- [x] Live website accessible via URL
- [x] Custom domain name (`sohamkunduivar.me`)
- [x] Cloudflare account (free tier)
- [x] Access to domain registrar
- [x] Nameservers updated to Cloudflare
- [x] DNS propagation verified

### Final Setup Summary

| Item | Value |
|------|-------|
| Domain Name | `sohamkunduivar.me` |
| Hosting | GitHub Pages |
| Repository | `Sefali12/Cloudflare-Firewall-Website-Protection` |
| Cloudflare Plan | Free |
| Nameservers | `lee.ns.cloudflare.com`, `nena.ns.cloudflare.com` |
| Edge Server | Amsterdam (AMS) |
| CF-Ray | `9b7b1c5b6b3ac11c-AMS` |

---

## Next Steps

Proceed to: **[Step 2: Cloudflare Integration](02-cloudflare-integration.md)**
