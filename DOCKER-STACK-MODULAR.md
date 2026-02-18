# OpenClaw Docker Stack - Modular Edition

**Nouvelle architecture modulaire hybride** pour déploiements flexibles et scalables.

---

## 🎯 Approche

Au lieu d'un unique `docker-compose.yml` monolithique, le stack est divisé en **modules composables** :

```
docker-compose.core.yml          # Services essentiels (obligatoire)
docker-compose.monitoring.yml    # Observabilité (optionnel)
docker-compose.search.yml        # Moteurs de recherche (optionnel)
docker-compose.security.yml      # Authentification & backups (optionnel)
docker-compose.integrations.yml  # Automatisation & LLM (optionnel)
docker-compose.supabase.yml      # Backend Supabase (optionnel)
docker-compose.git.yml           # Git server (optionnel)
docker-compose.rcpro.yml         # RC Pro app (optionnel)
```

**Avantages :**
- ✅ Flexibilité : déployer uniquement ce dont tu as besoin
- ✅ Modularité : chaque équipe peut gérer son module
- ✅ Scalabilité : ajouter de nouveaux modules sans modifications
- ✅ Maintenabilité : fichiers plus petits et focalisés
- ✅ Réutilisabilité : partage des services (postgres, redis, minio)

---

## 📦 Modules

### `docker-compose.core.yml` ⭐ (obligatoire)

**Services (8 containers) :** Traefik, OpenClaw (gateway+CLI), Portainer, MinIO, Redis, Redis Insight, PostgreSQL, Qdrant

**RAM:** ~6-8 GB
**Volumes:** traefik_certs, minio_data, redis_data, postgres_data, qdrant_data

```bash
docker compose -f docker-compose.core.yml up -d
```

---

### `docker-compose.monitoring.yml` (optionnel)

**Services (5 containers) :** Prometheus, Grafana, Loki, Uptime Kuma, Langfuse

**RAM:** ~2-3 GB additional
**Dépendances:** core (postgres)

```bash
docker compose -f docker-compose.core.yml -f docker-compose.monitoring.yml up -d
```

**URLs :**
- Grafana: `https://DOMAIN/grafana`
- Uptime Kuma: `https://DOMAIN/uptime`
- Langfuse: `https://DOMAIN/langfuse`

---

### `docker-compose.search.yml` (optionnel)

**Services (3 containers) :** SearXNG, Elasticsearch, Kibana

**RAM:** ~2-4 GB additional

```bash
docker compose -f docker-compose.core.yml -f docker-compose.search.yml up -d
```

**URLs :**
- SearXNG: `https://DOMAIN/search`
- Kibana: `https://DOMAIN/kibana`

---

### `docker-compose.security.yml` (optionnel)

**Services (5 containers) :** Vaultwarden, Authentik (server+worker), Authentik-DB, Authentik-Redis, Duplicati

**RAM:** ~2-3 GB additional
**Dépendances:** Aucune (Authentik utilise sa propre DB)

```bash
docker compose -f docker-compose.core.yml -f docker-compose.security.yml up -d
```

**URLs :**
- Vaultwarden: `https://DOMAIN/vault`
- Authentik: `https://DOMAIN/auth`
- Duplicati: `https://DOMAIN/duplicati`

---

### `docker-compose.integrations.yml` (optionnel)

**Services (2 containers) :** n8n, Ollama (GPU optional)

**RAM:** ~2-3 GB additional
**GPU:** Optional (Ollama)

```bash
docker compose -f docker-compose.core.yml -f docker-compose.integrations.yml up -d
```

**URLs :**
- n8n: `https://DOMAIN/n8n`
- Ollama: http://localhost:11434 (internal only, no web UI)

**⚠️ Ollama :** CPU-only par défaut = très lent (0.5-2 tokens/sec). Utiliser uniquement avec GPU.

---

### `docker-compose.supabase.yml` (optionnel)

**Services (9 containers) :** Supabase (postgres, studio, kong, rest, auth, realtime, storage, meta, imgproxy, vector)

**RAM:** ~6-8 GB additional
**Dépendances:** **Config files required** (voir ci-dessous)

```bash
# IMPORTANT: Télécharger les fichiers de config Supabase avant
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/

# Puis déployer
docker compose -f docker-compose.core.yml -f docker-compose.supabase.yml up -d
```

**URLs :**
- Supabase Studio: `https://DOMAIN/supabase`

---

### `docker-compose.git.yml` (optionnel)

**Services (2 containers) :** Gitea, Gitea-DB

**RAM:** ~1-2 GB additional

```bash
docker compose -f docker-compose.core.yml -f docker-compose.git.yml up -d
```

**URLs :**
- Gitea: `https://DOMAIN/git`

---

### `docker-compose.rcpro.yml` (optionnel)

**Services (3 containers) :** RC Pro Backend (Express), RC Pro Frontend (Next.js), RC Pro Docx Service (Python)

**RAM:** ~1-2 GB additional
**Dépendances:** core (postgres, redis, minio), docker-compose.rcpro.yml

```bash
docker compose -f docker-compose.core.yml -f docker-compose.rcpro.yml up -d
```

**URLs :**
- Frontend: `https://DOMAIN/rcpro`
- API: `https://DOMAIN/rcpro/api/v1`

---

## 🚀 Presets (Commandes simplifiées)

Un **script `deploy.sh`** facilite le déploiement avec des **presets** :

### Preset: `minimal`
```bash
./deploy.sh --preset minimal
```
**Inclut:** Core only (~6-8 GB)

### Preset: `lightweight` ⭐ (Recommandé)
```bash
./deploy.sh --preset lightweight
```
**Inclut:** Core + Monitoring + Search (~8-10 GB)

### Preset: `full`
```bash
./deploy.sh --preset full
```
**Inclut:** Core + Monitoring + Search + Security + Integrations + Supabase + Git (~32-40 GB)

### Preset: `luc-rcpro` (Luc's preset)
```bash
./deploy.sh --preset luc-rcpro
```
**Inclut:** Core + Monitoring + Search + Security + RC Pro (~10-12 GB)

### Preset: `custom`
Pour combinaisons personnalisées, spécifier manuellement les fichiers :
```bash
docker compose -f docker-compose.core.yml \
               -f docker-compose.monitoring.yml \
               -f docker-compose.rcpro.yml \
               up -d
```

---

## 📝 Configuration

### 1. Copier et adapter `.env`

```bash
cp .env.example .env
nano .env
```

**Variables obligatoires :**
```bash
DOMAIN=votre-domaine.com
ACME_EMAIL=votre@email.com
OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
POSTGRES_PASSWORD=$(openssl rand -hex 32)
MINIO_ROOT_PASSWORD=$(openssl rand -hex 32)
REDIS_PASSWORD=$(openssl rand -hex 32)
# ... autres secrets
```

### 2. Pour Supabase (si utilisé)

```bash
# Télécharger les fichiers de config
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/

# Générer les secrets Supabase
SUPABASE_JWT_SECRET=$(openssl rand -hex 32)
SUPABASE_ANON_KEY=$(openssl rand -base64 32)
SUPABASE_SERVICE_ROLE_KEY=$(openssl rand -base64 32)
```

### 3. Pour RC Pro (si utilisé)

Cloner le repo rcpro-app en parallèle :
```bash
# Structure finale:
# parent/
# ├── claw-repo/
# │   ├── docker-compose.core.yml
# │   ├── docker-compose.rcpro.yml
# │   ├── .env
# │   └── deploy.sh
# └── rcpro-app/
#     ├── backend/
#     ├── frontend/
#     └── docx-service/

git clone <url-rcpro-app> ../rcpro-app
```

---

## 🎬 Démarrage

### Option 1 : Script deploy.sh (recommandé)

```bash
./deploy.sh --preset lightweight
./deploy.sh --preset luc-rcpro
./deploy.sh --preset full --action logs -f
```

### Option 2 : Docker-compose manuel

```bash
# Start
docker compose -f docker-compose.core.yml \
               -f docker-compose.monitoring.yml \
               -f docker-compose.search.yml \
               up -d

# Logs
docker compose logs -f

# Stop
docker compose -f docker-compose.core.yml \
               -f docker-compose.monitoring.yml \
               -f docker-compose.search.yml \
               down
```

---

## 📊 Matrice RAM / Modules

| Preset | Modules | RAM | Services |
|--------|---------|-----|----------|
| minimal | core | 6-8 GB | 8 |
| lightweight | core + monitoring + search | 8-10 GB | 16 |
| luc-rcpro | core + monitoring + search + security + rcpro | 10-12 GB | 19 |
| full | core + monitoring + search + security + integrations + supabase + git | 32-40 GB | 39+ |

---

## 🔧 Opérations courantes

### Démarrer un preset

```bash
./deploy.sh --preset lightweight
```

### Arrêter tous les services

```bash
docker compose down
```

### Voir les logs

```bash
docker compose logs -f
docker compose logs -f service_name
```

### Voir les services en cours

```bash
docker compose ps
```

### Ajouter un module (ex: git)

```bash
docker compose -f docker-compose.core.yml \
               -f docker-compose.monitoring.yml \
               -f docker-compose.git.yml \
               up -d
```

### Retirer un module (ex: supabase)

Simplement ne pas l'inclure dans la prochaine commande `up -d`

---

## 🔗 Dépendances entre modules

```
core
├── monitoring (dépend: postgres)
├── search (indépendant)
├── security (indépendant, inclut sa propre DB/Redis)
├── integrations (dépend: postgres)
├── supabase (indépendant, inclut sa propre DB)
├── git (indépendant, inclut sa propre DB)
└── rcpro (dépend: postgres, redis, minio)
```

**Règles :**
- `core` est **obligatoire**
- Tous les autres modules sont **optionnels**
- Les modules partagent `postgres`, `redis`, `minio` du core
- `security`, `supabase`, `git` incluent leurs propres DB (isolées)

---

## 🚨 Dépannage

### Port déjà utilisé

```bash
netstat -tulpn | grep :80
netstat -tulpn | grep :443
```

### Service ne démarre pas

```bash
docker compose logs -f service_name
```

### Erreur certificat Let's Encrypt

```bash
docker compose logs traefik
# Vérifier: DOMAIN pointe bien vers ce serveur, ports 80/443 ouverts
```

### Supabase volumes manquants

```bash
# Télécharger les fichiers de config
git clone https://github.com/supabase/supabase
cp -r supabase/docker/volumes ./supabase/
```

---

## 📚 Documentation

- **OpenClaw Docs:** https://docs.openclaw.ai
- **Traefik:** https://doc.traefik.io/traefik/
- **Supabase:** https://supabase.com/docs
- **n8n:** https://docs.n8n.io
- **Grafana:** https://grafana.com/docs

---

## 🎓 Exemples de déploiement

### Cas 1 : Luc (RC Pro + monitoring + search)
```bash
./deploy.sh --preset luc-rcpro
```
**RAM:** ~10-12 GB

### Cas 2 : Organisation small (core + auth + backups)
```bash
docker compose -f docker-compose.core.yml \
               -f docker-compose.security.yml \
               up -d
```
**RAM:** ~8-10 GB

### Cas 3 : Entreprise (full stack)
```bash
./deploy.sh --preset full
```
**RAM:** ~32-40 GB

### Cas 4 : Développement (minimal)
```bash
./deploy.sh --preset minimal
```
**RAM:** ~6-8 GB
