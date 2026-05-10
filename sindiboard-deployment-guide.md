# Sindiboard Beta — Deployment & Operations Guide

> **Project**: Sindiboard (beta branch)
> **Stack**: Spring Boot 3.2.5 (Java 21) + React + Supabase PostgreSQL + Nginx
> **Deploy Path**: `/opt/sindiboard/beta/`
> **Last Verified**: 2026-05-09
> **Status**: ✅ FULLY OPERATIONAL — OTP email verified

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Nginx (SSL/TLS)                       │
│         sindiboardbeta.sindibadgroup.net                 │
│                                                         │
│  ┌──────────┐    ┌──────────────┐                       │
│  │  React    │    │ /graphql     │                       │
│  │  Frontend │    │ proxy →      │                       │
│  │  build/   │    │ localhost:80 │                       │
│  └──────────┘    │ 080/graphql  │                       │
│                  └──────┬───────┘                       │
└─────────────────────────┼───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│              Spring Boot Backend (port 8080)             │
│                                                         │
│  • 6 Schedulers (Performance, Backup, Invoice, Infra,   │
│    Alert, MonthlyCost) — all loaded from DB             │
│  • VmDiskSpaceService: DB-driven workspace resolution   │
│    via WorkspaceRepository (no hardcoded IDs)           │
│  • GraphQL API endpoint                                 │
│  • OTP authentication with email delivery (SMTP)        │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────┐
│              Supabase PostgreSQL                         │
│         aws-1-eu-central-1.pooler.supabase.com:5432      │
│                                                         │
│  • Main app database (postgres)                         │
│  • workspaces table — single source of truth            │
└─────────────────────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
/opt/sindiboard/beta/
├── deploy.sh                          # Full-stack deploy script
├── DEPLOY_NOTES.md                    # Quick reference cards
├── sindiboard-deployment-guide.md     # This document
├── sindiboard_backend/
│   ├── src/main/java/org/example/
│   │   ├── service/
│   │   │   ├── AuthService.java       # Login, OTP, password reset
│   │   │   ├── EmailService.java       # SMTP email sender
│   │   │   └── VmDiskSpaceService.java # DB-driven workspace resolution
│   │   ├── repository/
│   │   │   ├── WorkspaceRepository.java # JPA repo for workspaces table
│   │   │   └── UserRepository.java
│   │   ├── entity/
│   │   │   ├── Workspace.java
│   │   │   └── User.java
│   │   ├── security/
│   │   │   └── JwtUtil.java
│   │   └── resolver/
│   │       └── AuthResolver.java
│   ├── src/main/resources/
│   │   └── application.properties     # All config (DB, SMTP, JWT, Azure)
│   ├── target/
│   │   └── cloudSaaS-0.0.1-SNAPSHOT.jar
│   └── docker/
│       └── docker-compose.yml         # Local Postgres + pgAdmin
└── sindiboard_frontend/
    ├── src/infrastructure/graphql/
    │   └── client.js                  # Apollo Client — uses relative /graphql
    ├── deploy-frontend.sh            # Frontend-only deploy script
    └── build/                         # Built React app (served by Nginx)
```

---

## ⚠️ Root Causes Fixed (OTP Email Failure)

Three bugs were causing OTP emails to fail. All three are now fixed:

### Bug 1: Missing `spring.mail.host`
Spring Boot's `JavaMailSender` had no SMTP host configured. The property was entirely absent from `application.properties`.

**Fix:** Added `spring.mail.host=premium706.web-hosting.com`

### Bug 2: Timeout values in MILLISECONDS instead of SECONDS
The JavaMail API expects timeout values in **milliseconds**, but the config had `10` (10ms — instant failure). OS tools like `nc` use their own reasonable timeouts, which is why they worked.

**Fix:** Changed all timeouts from `10` to `10000` (10 seconds)

### Bug 3: JVM IPv6-first DNS resolution
Java 21 defaults to IPv6 when connecting to SMTP. The mail server `premium706.web-hosting.com` has **no AAAA (IPv6) record**, causing `SocketTimeoutException`.

**Fix:** Added `-Djava.net.preferIPv4Stack=true` to JVM startup (embedded in systemd service + deploy script)

### Additional Missing Config (caused startup crash)
- `spring.datasource.username` / `spring.datasource.password`
- `spring.jpa.hibernate.ddl-auto`
- `spring.jpa.properties.hibernate.dialect`
- `jwt.secret` / `jwt.expiration`
- `spring.mail.port=587`

All restored.

---

## 🚀 Deployment

### Full Stack Deploy (One Command)

```bash
bash /opt/sindiboard/beta/deploy.sh
```

### Frontend Only

```bash
bash /opt/sindiboard/beta/sindiboard_frontend/deploy-frontend.sh
```

### Backend Only

```bash
systemctl restart sindiboard-backend
```

### Manual Backend Start (if systemd unavailable)

```bash
nohup java -Djava.net.preferIPv4Stack=true \
  -jar /opt/sindiboard/beta/sindiboard_backend/target/cloudSaaS-0.0.1-SNAPSHOT.jar \
  > /tmp/sindiboard_backend.log 2>&1 &
```

---

## 📧 SMTP Configuration

| Setting | Value |
|---------|-------|
| **Host** | `premium706.web-hosting.com` |
| **Port** | `587` (STARTTLS) |
| **Username** | `sindiboard@walidsolutions.com` |
| **From** | `sindiboard@walidsolutions.com` |
| **Auth** | Enabled |
| **Protocol** | SMTP |
| **Connection timeout** | 10000ms (10s) |
| **Timeout** | 10000ms (10s) |
| **Write timeout** | 10000ms (10s) |

---

## 🗄️ Database (Supabase PostgreSQL)

| Setting | Value |
|---------|-------|
| **Host** | `aws-1-eu-central-1.pooler.supabase.com` |
| **Port** | `5432` |
| **Database** | `postgres` |
| **Username** | `postgres.kdpaebdlspqevipivkql` |
| **SSL** | `require` |
| **Dialect** | `PostgreSQLDialect` |

### Workspace Resolution (Refactored)

`VmDiskSpaceService` now reads Azure workspace IDs dynamically from the `workspaces` table via `WorkspaceRepository.findAll()` instead of hardcoded `application.properties` values.

---

## 🔐 JWT Configuration

| Property | Value |
|----------|-------|
| Secret | `44aa045b56ded151e1373f58dc8f42ce70b2da6fca7775080934b018859aee56` |
| Expiration | `86400000` (24 hours in ms) |

---

## 🔧 Nginx Configuration

**Config file**: `/usr/local/emps/etc/nginx/nginx.conf`

Key location blocks for sindiboardbeta:

```nginx
server {
    listen 443 ssl;
    server_name sindiboardbeta.sindibadgroup.net;
    root /opt/sindiboard/beta/sindiboard_frontend/build;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /graphql {
        proxy_pass http://localhost:8080/graphql;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_read_timeout 3600;
        proxy_connect_timeout 3600;
    }
}
```

### Nginx Commands

```bash
nginx -t              # Validate config
nginx -s reload       # Reload (zero-downtime)
```

---

## 📊 Monitoring & Logs

```bash
# Backend logs (live)
tail -f /tmp/sindiboard_backend.log

# Backend errors only
grep -i "error\|failed\|exception" /tmp/sindiboard_backend.log

# Backend process
ps aux | grep "java.*preferIPv4Stack" | grep -v grep

# HTTP health check
curl -s -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __typename }"}'

# Systemd status
systemctl status sindiboard-backend

# OTP delivery test (triggers actual email)
curl -s -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"mutation { login(email: \"walidcloud25@gmail.com\", password: \"S!Nd!b0@rD\") { message } }"}'
```

---

## 🚨 Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| OTP emails not sending | Missing `spring.mail.host` | Add `spring.mail.host=premium706.web-hosting.com` |
| OTP emails timeout | Timeouts in ms not seconds | Change `10` → `10000` for all SMTP timeouts |
| OTP emails timeout on IPv6 | Java 21 IPv6-first, no AAAA record | Add `-Djava.net.preferIPv4Stack=true` |
| Backend won't start | Missing datasource/JWT properties | Check all properties exist in application.properties |
| GraphQL returns 404 | Nginx proxy misconfigured | Check `/graphql` location block in nginx.conf |

---

## ✅ Verification Checklist

- [x] Backend running on port 8080 with IPv4 flag
- [x] PostgreSQL connected (Supabase pooler)
- [x] All 6 schedulers initialized
- [x] GraphQL responding `{"data":{"__typename":"Query"}}`
- [x] Nginx serving frontend at `sindiboardbeta.sindibadgroup.net`
- [x] `/graphql` proxy working
- [x] OTP email delivery verified (logs: "OTP email sent to...")
- [x] No errors in backend log