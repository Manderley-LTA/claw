# Deployment Checklist - Files Required per Preset

**Quick reference for copying files to a new machine.**

---

## 📋 Files by Preset

### Preset: `minimal`

**Size:** ~23 KB total | **RAM:** 6-8 GB

**Required files:**
```
docker-compose.core.yml       (8.6 KB)
.env.example → .env           (8.7 KB, modify)
deploy.sh                     (5.6 KB)
```

**Optional but recommended:**
```
prometheus.yml                (536 B)
DOCKER-STACK-MODULAR.md       (for reference)
ARCHITECTURE-DECISIONS.md     (for reference)
```

**Deployment:**
```bash
./deploy.sh --preset minimal
```

---

### Preset: `lightweight` ⭐ (Recommended)

**Size:** ~32 KB total | **RAM:** 8-10 GB

**Required files:**
```
docker-compose.core.yml       (8.6 KB)
docker-compose.monitoring.yml (4.4 KB)
docker-compose.search.yml     (3.0 KB)
.env.example → .env           (8.7 KB, modify)
deploy.sh                     (5.6 KB)
```

**Optional but recommended:**
```
prometheus.yml                (536 B)
DOCKER-STACK-MODULAR.md       (for reference)
```

**Deployment:**
```bash
./deploy.sh --preset lightweight
```

---

### Preset: `luc-rcpro` (Luc's Setup)

**Size:** ~47 KB total | **RAM:** 10-12 GB

**Required files:**
```
docker-compose.core.yml       (8.6 KB)
docker-compose.monitoring.yml (4.4 KB)
docker-compose.search.yml     (3.0 KB)
docker-compose.security.yml   (5.1 KB)
docker-compose.rcpro.yml      (6.5 KB)
.env.example → .env           (8.7 KB, modify)
deploy.sh                     (5.6 KB)
```

**Additional requirement (external repo):**
```
../rcpro-app/                 (sibling directory)
├── backend/
├── frontend/
└── docx-service/
```

**Optional but recommended:**
```
prometheus.yml                (536 B)
DOCKER-STACK-MODULAR.md       (for reference)
```

**Deployment:**
```bash
./deploy.sh --preset luc-rcpro
```

---

### Preset: `full` (Complete Stack)

**Size:** ~65 KB total | **RAM:** 32-40 GB

**Required files:**
```
docker-compose.core.yml       (8.6 KB)
docker-compose.monitoring.yml (4.4 KB)
docker-compose.search.yml     (3.0 KB)
docker-compose.security.yml   (5.1 KB)
docker-compose.integrations.yml (2.6 KB)
docker-compose.supabase.yml   (9.1 KB)
docker-compose.git.yml        (2.3 KB)
.env.example → .env           (8.7 KB, modify)
deploy.sh                     (5.6 KB)
```

**Additional requirement (external repo):**
```
supabase/volumes/
├── db/realtime.sql
├── api/kong.yml
└── logs/vector.yml
```

**To get Supabase files:**
```bash
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/
```

**Optional but recommended:**
```
prometheus.yml                (536 B)
DOCKER-STACK-MODULAR.md       (for reference)
```

**Deployment:**
```bash
./deploy.sh --preset full
```

---

## 🚀 Quick Copy Commands

### For `lightweight` preset

```bash
# On your new machine, in the deployment directory:

# 1. Copy files from GitHub
git clone https://github.com/Manderley-LTA/claw
cd claw

# 2. Configure environment
cp .env.example .env
nano .env  # Edit: DOMAIN, ACME_EMAIL, all passwords, tokens

# 3. Deploy
./deploy.sh --preset lightweight
```

### For `luc-rcpro` preset

```bash
# On your new machine, in the deployment directory:

# 1. Clone both repos
git clone https://github.com/Manderley-LTA/claw claw-repo
git clone <rcpro-app-url> rcpro-app

# 2. Configure environment
cd claw-repo
cp .env.example .env
nano .env  # Edit: DOMAIN, ACME_EMAIL, all passwords, tokens, RCPRO_* vars

# 3. Ensure paths are correct
# Default paths in .env:
#   RCPRO_BACKEND_PATH=../rcpro-app/backend
#   RCPRO_FRONTEND_PATH=../rcpro-app/frontend
#   RCPRO_DOCX_PATH=../rcpro-app/docx-service
# This assumes:
#   parent/
#   ├── claw-repo/
#   └── rcpro-app/

# 4. Deploy
./deploy.sh --preset luc-rcpro
```

### For `full` preset

```bash
# On your new machine:

# 1. Clone repos
git clone https://github.com/Manderley-LTA/claw claw-repo
cd claw-repo

# 2. Get Supabase volumes
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/

# 3. Configure environment
cp .env.example .env
nano .env  # Edit: DOMAIN, ACME_EMAIL, all passwords, tokens, SUPABASE_* vars

# 4. Deploy
./deploy.sh --preset full
```

---

## 📦 Minimal File Listing (Copy-Paste Ready)

### Files to copy from GitHub

```
claw-repo/
├── docker-compose.core.yml
├── docker-compose.monitoring.yml     (if not minimal)
├── docker-compose.search.yml         (if not minimal)
├── docker-compose.security.yml       (if luc-rcpro or full)
├── docker-compose.integrations.yml   (if full)
├── docker-compose.supabase.yml       (if full)
├── docker-compose.git.yml            (if full)
├── docker-compose.rcpro.yml          (if luc-rcpro)
├── deploy.sh
├── prometheus.yml                    (optional)
├── .env.example
├── DOCKER-STACK-MODULAR.md           (documentation)
└── ARCHITECTURE-DECISIONS.md         (documentation)

supabase/volumes/                     (if full preset)
├── db/realtime.sql
├── api/kong.yml
└── logs/vector.yml

rcpro-app/                            (if luc-rcpro preset)
├── backend/
├── frontend/
└── docx-service/
```

---

## ✅ Pre-Deployment Checklist

Before running `./deploy.sh`:

- [ ] All required docker-compose files copied
- [ ] `.env` created from `.env.example`
- [ ] `.env` edited with correct values:
  - [ ] `DOMAIN` = your actual domain
  - [ ] `ACME_EMAIL` = your email
  - [ ] All passwords generated: `openssl rand -hex 32`
  - [ ] All tokens generated
  - [ ] `RCPRO_*` variables if using luc-rcpro preset
  - [ ] `SUPABASE_*` variables if using full preset
- [ ] Supabase volumes downloaded (if full preset)
- [ ] rcpro-app cloned to ../rcpro-app (if luc-rcpro preset)
- [ ] Docker + Docker Compose installed
- [ ] Sufficient RAM available (check with `free -h`)
- [ ] Ports 80 & 443 open (firewall rules)
- [ ] Domain DNS pointing to this server

---

## 🚨 Common Issues

### "File not found: docker-compose.monitoring.yml"

**Cause:** You're using `lightweight` preset but didn't copy all files.

**Solution:**
```bash
# Copy missing files from GitHub
git clone https://github.com/Manderley-LTA/claw
```

### ".env not found"

**Cause:** You forgot to create `.env` from `.env.example`.

**Solution:**
```bash
cp .env.example .env
nano .env  # Edit with your values
```

### "rcpro-app path not found"

**Cause:** RC Pro code not in `../rcpro-app/` or wrong path in `.env`.

**Solution:**
```bash
# Check rcpro-app location
ls -la ../rcpro-app/

# Or update .env paths:
RCPRO_BACKEND_PATH=/full/path/to/rcpro-app/backend
RCPRO_FRONTEND_PATH=/full/path/to/rcpro-app/frontend
RCPRO_DOCX_PATH=/full/path/to/rcpro-app/docx-service
```

### "Supabase volumes not found"

**Cause:** You didn't download Supabase config files.

**Solution:**
```bash
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/
```

### "Not enough RAM"

**Cause:** Your machine doesn't have enough RAM for the preset.

**Solution:**
- Use smaller preset (e.g., `lightweight` instead of `full`)
- Add more RAM
- Disable non-critical modules

---

## 📋 File Size Summary

| Preset | Docker Compose Files | Config | Supabase Volumes | RC Pro Code | Total |
|--------|---------------------|--------|------------------|-------------|-------|
| minimal | 8.6 KB | 8.7 KB | - | - | ~17 KB |
| lightweight | 16.0 KB | 8.7 KB | - | - | ~25 KB |
| luc-rcpro | 27.5 KB | 8.7 KB | - | 50+ MB | ~50 MB |
| full | 42.7 KB | 8.7 KB | 50+ MB | - | ~52 MB |

*(Docker images are pulled at runtime, not included)*

---

## 🎯 TL;DR

**For new machine deployment:**

1. **Copy from GitHub:**
   ```bash
   git clone https://github.com/Manderley-LTA/claw claw-repo
   cd claw-repo
   ```

2. **Configure:**
   ```bash
   cp .env.example .env
   nano .env  # Edit DOMAIN, passwords, etc.
   ```

3. **Deploy:**
   ```bash
   ./deploy.sh --preset <your-preset>
   ```

**Done!** Stack will start automatically.
