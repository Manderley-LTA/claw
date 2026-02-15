# 🦞 OpenClaw — Assistant IA Personnel (Fork Manderley-LTA)

> **Fork enrichi** de [openclaw/openclaw](https://github.com/openclaw/openclaw) avec déploiement Docker production-ready et dépendances skills pré-installées.

<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/openclaw/openclaw/main/docs/assets/openclaw-logo-text-dark.png">
        <img src="https://raw.githubusercontent.com/openclaw/openclaw/main/docs/assets/openclaw-logo-text.png" alt="OpenClaw" width="500">
    </picture>
</p>

<p align="center">
  <strong>EXFOLIATE! EXFOLIATE!</strong>
</p>

<p align="center">
  <a href="https://github.com/openclaw/openclaw/actions/workflows/ci.yml?branch=main"><img src="https://img.shields.io/github/actions/workflow/status/openclaw/openclaw/ci.yml?branch=main&style=for-the-badge" alt="CI status"></a>
  <a href="https://github.com/openclaw/openclaw/releases"><img src="https://img.shields.io/github/v/release/openclaw/openclaw?include_prereleases&style=for-the-badge" alt="GitHub release"></a>
  <a href="https://discord.gg/clawd"><img src="https://img.shields.io/discord/1456350064065904867?label=Discord&logo=discord&logoColor=white&color=5865F2&style=for-the-badge" alt="Discord"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

---

## 📖 Table des matières

- [🌟 Améliorations du Fork](#-améliorations-du-fork)
- [🚀 Déploiement Rapide](#-déploiement-rapide)
- [📦 Stacks Docker Disponibles](#-stacks-docker-disponibles)
- [🎯 Qu'est-ce qu'OpenClaw ?](#-quest-ce-quopenclaw)
- [💡 Installation Standard](#-installation-standard)
- [🔧 Configuration](#-configuration)
- [📚 Documentation](#-documentation)
- [🛠️ Développement](#-développement)

---

## 🌟 Améliorations du Fork

Ce fork ajoute des configurations de déploiement prêtes pour la production :

### 🐳 Dockerfile Enrichi

**Tous les outils nécessaires aux skills built-in, pré-installés :**

**Packages système APT :**
- **Outils de base** : `jq`, `ripgrep`, `tmux`, `git`, `curl`, `wget`, `ca-certificates`, `build-essential`
- **Outils média** : `ffmpeg`, `yt-dlp`
- **Python** : `python3`, `python3-pip`, `python3-venv`, `uv`
- **GitHub CLI** : `gh`

**NPM global :**
- `clawhub` (gestionnaire de skills ClawHub)

**CLIs personnalisés** (installés dans `/home/node/.local/bin/`) :
- **himalaya** — Client email CLI (IMAP/SMTP)
- **obsidian-cli** — Gestionnaire de vault Obsidian
- **spogo** — Spotify CLI
- **gog** — Google Workspace CLI
- **openhue** — Philips Hue CLI
- **sag** — ElevenLabs TTS CLI
- **camsnap** — RTSP/ONVIF camera CLI
- **ordercli** — Vérificateur de commandes de livraison

**Résultat :** Tous les skills built-in fonctionnent **immédiatement** après le démarrage du container, sans installation post-déploiement.

---

### 📦 Stacks Docker Complètes

Deux configurations selon vos ressources :

#### 🪶 **Stack Allégée** (`docker-compose.yml`) — 12 GB RAM

**21 services inclus :**

| Catégorie | Services |
|-----------|----------|
| **Reverse Proxy** | Traefik (HTTPS automatique avec Let's Encrypt) |
| **OpenClaw** | Gateway + CLI |
| **Gestion** | Portainer (interface Docker) |
| **Stockage** | MinIO (S3-compatible), PostgreSQL |
| **Cache** | Redis + RedisInsight (UI) |
| **Bases de données** | Qdrant (vecteurs) |
| **Automation** | n8n (workflows) |
| **Monitoring** | Prometheus, Grafana, Loki, Uptime Kuma |
| **Observabilité LLM** | Langfuse |
| **Backup** | Duplicati |
| **Sécurité** | Vaultwarden (gestionnaire mots de passe), Authentik (SSO) |

**Tous accessibles via HTTPS avec PathPrefix** :
- `https://votre-domaine.com/claw` — OpenClaw
- `https://votre-domaine.com/portainer` — Portainer
- `https://votre-domaine.com/minio` — MinIO Console
- `https://votre-domaine.com/redis` — RedisInsight
- `https://votre-domaine.com/qdrant` — Qdrant UI
- `https://votre-domaine.com/n8n` — n8n Workflows
- `https://votre-domaine.com/grafana` — Grafana Dashboards
- `https://votre-domaine.com/uptime` — Uptime Kuma
- `https://votre-domaine.com/langfuse` — LLM Observability
- `https://votre-domaine.com/duplicati` — Backups
- `https://votre-domaine.com/vault` — Vaultwarden
- `https://votre-domaine.com/auth` — Authentik SSO
- `https://votre-domaine.com/traefik` — Traefik Dashboard

---

#### 🚀 **Stack Complète** (`docker-compose.full.yml`) — 32+ GB RAM

**38 services (tout ce qui précède +) :**

**Supabase** (Backend-as-a-Service complet, 9 containers) :
- `postgres` avec pgvector (recherche vectorielle)
- `studio` (UI d'administration)
- `kong` (API Gateway)
- `auth` (GoTrue - authentification JWT/OAuth)
- `rest` (PostgREST - API REST automatique)
- `realtime` (WebSocket pour changements DB)
- `storage` (API de stockage fichiers)
- `meta` (service métadonnées)
- `imgproxy` (transformation images)
- `vector` (collecte logs)

**Recherche avancée** :
- `elasticsearch` + `kibana` (recherche full-text, analyse logs)

**Git self-hosted** :
- `gitea` + base de données dédiée (repos privés, CI/CD)

**IA locale** :
- `ollama` (LLM locaux : Llama, Mistral, Qwen... **nécessite GPU**)

**Accès supplémentaires** :
- `https://votre-domaine.com/supabase` — Supabase Studio
- `https://votre-domaine.com/kibana` — Kibana
- `https://votre-domaine.com/git` — Gitea

---

### 📋 Documentation Complète

- **[DOCKER-STACK.md](DOCKER-STACK.md)** — Guide de déploiement complet
- **[.env.example](.env.example)** — Template de configuration avec toutes les variables
- **[prometheus.yml](prometheus.yml)** — Configuration Prometheus

---

## 🚀 Déploiement Rapide

### Prérequis

- Docker + Docker Compose v2
- **12 GB RAM minimum** (stack allégée) ou **32 GB** (stack complète)
- Domaine pointant vers votre serveur
- Ports 80 et 443 ouverts

### Installation en 3 étapes

**1. Cloner le repository :**
```bash
git clone https://github.com/Manderley-LTA/claw.git
cd claw
```

**2. Configuration :**
```bash
cp .env.example .env
nano .env
```

**Variables obligatoires à modifier :**
```bash
# Domaine et certificats SSL
DOMAIN=votre-domaine.com
ACME_EMAIL=votre@email.com

# Token OpenClaw
OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)

# Mots de passe des services
POSTGRES_PASSWORD=$(openssl rand -hex 32)
MINIO_ROOT_PASSWORD=$(openssl rand -hex 32)
REDIS_PASSWORD=$(openssl rand -hex 32)
# ... etc (voir .env.example)
```

**3. Lancer le stack :**

**Stack allégée (12 GB RAM) :**
```bash
docker-compose up -d
```

**Stack complète (32+ GB RAM) :**
```bash
docker-compose -f docker-compose.full.yml up -d
```

### Vérifier le déploiement

```bash
# Voir les logs
docker-compose logs -f

# Vérifier l'état des containers
docker-compose ps

# Voir les ressources utilisées
docker stats
```

---

## 📦 Stacks Docker Disponibles

| Fichier | Services | RAM Requise | Description |
|---------|----------|-------------|-------------|
| `docker-compose.yml` | 21 | 12 GB | Production léger : essentiels + monitoring |
| `docker-compose.full.yml` | 38 | 32+ GB | Production complet : + Supabase + Elasticsearch + Gitea + Ollama |

**Fonctionnalités communes :**
- ✅ HTTPS automatique (Let's Encrypt via Traefik)
- ✅ Tous les services accessibles via sous-répertoires (PathPrefix)
- ✅ Réseaux isolés (frontend/backend)
- ✅ Volumes persistants
- ✅ Restart automatique

**Voir [DOCKER-STACK.md](DOCKER-STACK.md) pour détails complets.**

---

## 🎯 Qu'est-ce qu'OpenClaw ?

**OpenClaw** est un assistant IA personnel que vous hébergez sur vos propres machines.

### Caractéristiques principales

- **Multi-canaux** : Répond sur WhatsApp, Telegram, Slack, Discord, Google Chat, Signal, iMessage, Microsoft Teams, Matrix, Zalo, WebChat
- **Local-first** : Vos données restent sur vos serveurs
- **Extensible** : Système de skills (compétences) modulaire
- **Multi-plateformes** : macOS, Linux, Windows (WSL2), iOS, Android
- **Voice Wake** : Activation vocale always-on (macOS/iOS/Android)
- **Canvas Live** : Workspace visuel contrôlé par l'agent

### Canaux supportés

| Canal | Status | Notes |
|-------|--------|-------|
| **WhatsApp** | ✅ | Via Baileys |
| **Telegram** | ✅ | Via grammY |
| **Slack** | ✅ | Via Bolt |
| **Discord** | ✅ | Via discord.js |
| **Google Chat** | ✅ | Via Chat API |
| **Signal** | ✅ | Via signal-cli |
| **iMessage** | ✅ | Via BlueBubbles (recommandé) ou imsg (legacy) |
| **Microsoft Teams** | ✅ | Extension |
| **Matrix** | ✅ | Extension |
| **Zalo** | ✅ | Extension |
| **WebChat** | ✅ | Intégré |

### Modèles supportés

**Fournisseurs officiels :**
- **Anthropic** (Claude Pro/Max, Opus 4.6 recommandé)
- **OpenAI** (ChatGPT, GPT-4, Codex)
- **Google** (Gemini)
- **OpenRouter** (accès multi-providers)

**Via ce fork :**
- **Ollama** (LLM locaux : Llama, Mistral, Qwen... **stack complet uniquement, GPU requis**)

---

## 💡 Installation Standard

### Installation via npm (pour usage classique)

**Prérequis :** Node.js ≥22

```bash
# Installation globale
npm install -g openclaw@latest
# ou : pnpm add -g openclaw@latest

# Wizard d'onboarding (configuration guidée)
openclaw onboard --install-daemon
```

Le wizard installe le daemon Gateway (service launchd/systemd) pour maintenir OpenClaw actif en permanence.

### Démarrage rapide (CLI)

```bash
# Lancer le gateway
openclaw gateway --port 18789 --verbose

# Envoyer un message
openclaw message send --to +1234567890 --message "Hello from OpenClaw"

# Parler à l'assistant
openclaw agent --message "Créer une checklist pour le déploiement" --thinking high
```

### Build depuis les sources

**Prérequis :** pnpm (ou npm/bun)

```bash
git clone https://github.com/Manderley-LTA/claw.git
cd claw

pnpm install
pnpm ui:build  # Build l'interface Control UI
pnpm build     # Build OpenClaw

pnpm openclaw onboard --install-daemon

# Mode développement (auto-reload sur changements TypeScript)
pnpm gateway:watch
```

---

## 🔧 Configuration

### Fichiers de configuration

| Fichier | Description | Emplacement |
|---------|-------------|-------------|
| `openclaw.json` | Config principale | `~/.openclaw/openclaw.json` |
| `.env` | Variables d'environnement | `./.env` ou `~/.openclaw/.env` |
| `AGENTS.md` | Instructions agent | `~/.openclaw/workspace/AGENTS.md` |
| `SOUL.md` | Persona agent | `~/.openclaw/workspace/SOUL.md` |
| `TOOLS.md` | Notes outils/skills | `~/.openclaw/workspace/TOOLS.md` |

### Hiérarchie des variables

**Ordre de prioritence (haute → basse) :**
1. Variables d'environnement du processus
2. `./.env` (repo local)
3. `~/.openclaw/.env`
4. Bloc `env` dans `openclaw.json`

### Sécurité par défaut

**DM Policy** (Messages Directs) :
- Mode **pairing** par défaut : expéditeurs inconnus reçoivent un code de pairing
- Approuver avec : `openclaw pairing approve <channel> <code>`
- Mode **open** (DM publics) nécessite opt-in explicite

**Recommandations :**
- Ne jamais exposer le gateway publiquement sans authentification
- Utiliser des tokens forts (générés avec `openssl rand -hex 32`)
- Activer le firewall (seulement ports 80/443 si Docker)
- Sauvegarder régulièrement avec Duplicati

Voir guide complet : [Security](https://docs.openclaw.ai/gateway/security)

---

## 📚 Documentation

### Documentation Officielle OpenClaw

- **[Site Web](https://openclaw.ai)** — Page principale
- **[Documentation](https://docs.openclaw.ai)** — Guide complet
- **[Getting Started](https://docs.openclaw.ai/start/getting-started)** — Guide débutant
- **[Docker](https://docs.openclaw.ai/install/docker)** — Installation Docker
- **[Channels](https://docs.openclaw.ai/channels)** — Configuration canaux
- **[Skills](https://docs.openclaw.ai/tools/skills)** — Système de compétences
- **[FAQ](https://docs.openclaw.ai/start/faq)** — Questions fréquentes

### Documentation du Fork

- **[DOCKER-STACK.md](DOCKER-STACK.md)** — Guide déploiement Docker complet
- **[.env.example](.env.example)** — Template configuration
- **[Dockerfile](Dockerfile)** — Dockerfile enrichi avec skills
- **[scripts/install-skills-clis.sh](scripts/install-skills-clis.sh)** — Script installation CLIs

### Ressources Communautaires

- **[Discord](https://discord.gg/clawd)** — Support communautaire
- **[DeepWiki](https://deepwiki.com/openclaw/openclaw)** — Wiki collaboratif
- **[GitHub Issues](https://github.com/openclaw/openclaw/issues)** — Bug reports

---

## 🛠️ Développement

### Structure du projet

```
claw/
├── Dockerfile                    # Image Docker enrichie (skills pré-installés)
├── Dockerfile.original           # Backup Dockerfile original
├── docker-compose.yml            # Stack allégée (21 services, 12 GB)
├── docker-compose.full.yml       # Stack complète (38 services, 32+ GB)
├── docker-compose.yml.original   # Backup docker-compose original
├── .env.example                  # Template variables
├── prometheus.yml                # Config Prometheus
├── scripts/
│   └── install-skills-clis.sh   # Installation CLIs skills
├── DOCKER-STACK.md               # Doc déploiement Docker
├── README.md                     # README original (anglais)
├── README.fr.md                  # README français (ce fichier)
└── [autres fichiers OpenClaw]
```

### Commandes utiles

**Docker :**
```bash
# Build l'image Docker
docker-compose build

# Démarrer le stack
docker-compose up -d

# Voir les logs
docker-compose logs -f [service]

# Redémarrer un service
docker-compose restart [service]

# Arrêter le stack
docker-compose down

# Supprimer volumes (⚠️ perte de données)
docker-compose down -v
```

**CLI OpenClaw :**
```bash
# Status gateway
openclaw status

# Configuration
openclaw config get
openclaw config set gateway.auth.token "nouveau-token"

# Doctor (diagnostics)
openclaw doctor

# Mise à jour
openclaw update --channel stable|beta|dev
```

**Maintenance :**
```bash
# Nettoyer images Docker inutilisées
docker system prune -a

# Voir utilisation ressources
docker stats

# Sauvegarder un volume
docker run --rm -v nom_volume:/source -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /source .
```

### Contribuer

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'feat: Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

---

## 🔐 Variables d'Environnement

### Générateur de secrets

```bash
# Générer tous les secrets en une commande
cat .env.example | grep "change-me" | while read line; do
  key=$(echo "$line" | cut -d'=' -f1)
  secret=$(openssl rand -hex 32)
  echo "$key=$secret"
done
```

### Variables essentielles

**Traefik & SSL :**
```bash
DOMAIN=votre-domaine.com
ACME_EMAIL=votre@email.com
```

**OpenClaw :**
```bash
OPENCLAW_GATEWAY_TOKEN=<généré avec openssl rand -hex 32>
OPENCLAW_IMAGE=openclaw:local
CLAUDE_AI_SESSION_KEY=<votre clé API Claude>
```

**Bases de données :**
```bash
POSTGRES_PASSWORD=<fort>
REDIS_PASSWORD=<fort>
QDRANT_API_KEY=<fort>
```

**Services :**
```bash
MINIO_ROOT_PASSWORD=<fort>
N8N_ENCRYPTION_KEY=<32 caractères>
GF_SECURITY_ADMIN_PASSWORD=<fort>
VAULTWARDEN_ADMIN_TOKEN=<fort>
AUTHENTIK_SECRET_KEY=<50 caractères>
```

**Stack complet uniquement :**
```bash
SUPABASE_JWT_SECRET=<32 caractères minimum>
SUPABASE_ANON_KEY=<généré via Supabase CLI>
SUPABASE_SERVICE_ROLE_KEY=<généré via Supabase CLI>
GITEA_DB_PASSWORD=<fort>
ELASTIC_PASSWORD=<fort>
```

---

## 📊 Monitoring & Observabilité

### Services inclus

**Stack allégée :**
- **Prometheus** — Collecte métriques temps réel
- **Grafana** — Dashboards visuels (`/grafana`)
- **Loki** — Centralisation logs
- **Uptime Kuma** — Monitoring uptime (`/uptime`)

**Stack complète :**
- Tout ci-dessus +
- **Elasticsearch + Kibana** — Recherche logs avancée (`/kibana`)
- **Langfuse** — Observabilité LLM (traces, tokens, coûts) (`/langfuse`)

### Configuration Prometheus

Éditer `prometheus.yml` pour ajouter des targets :

```yaml
scrape_configs:
  - job_name: 'mon-service'
    static_configs:
      - targets: ['mon-service:9090']
```

### Ajouter cAdvisor (métriques containers)

Ajouter au `docker-compose.yml` :

```yaml
cadvisor:
  image: gcr.io/cadvisor/cadvisor:latest
  container_name: cadvisor
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
  networks:
    - backend
```

---

## 🎓 Cas d'Usage

### Assistant Personnel

**Configuration :** Stack allégée + Telegram/WhatsApp

**Use cases :**
- Résumés quotidiens (emails, calendrier, news)
- Recherche documentaire (Qdrant vectoriel)
- Automatisation tâches (n8n + OpenClaw)
- Rappels intelligents (cron jobs)

### Équipe Collaborative

**Configuration :** Stack complète + Slack/Discord + Authentik SSO

**Use cases :**
- Base de connaissances (Supabase + Elasticsearch)
- Workflows partagés (n8n)
- Documentation technique (Gitea + Obsidian)
- Monitoring infra (Grafana + Uptime Kuma)

### Développement IA

**Configuration :** Stack complète + Ollama (GPU)

**Use cases :**
- RAG avec Qdrant + Supabase
- Observabilité LLM (Langfuse)
- Tests locaux (Ollama)
- Prototypage (n8n + OpenClaw skills)

---

## ⚠️ Notes Importantes

### Stack Complet - Supabase

**Configuration supplémentaire requise :**

Supabase nécessite des fichiers de configuration additionnels :
```bash
supabase/volumes/db/realtime.sql
supabase/volumes/api/kong.yml
supabase/volumes/logs/vector.yml
```

**Télécharger les configs officielles :**
```bash
git clone https://github.com/supabase/supabase
cp -r supabase/docker/* ./supabase/volumes/
```

Ou depuis : https://github.com/supabase/supabase/tree/master/docker

### Ollama (GPU Requis)

⚠️ **Ollama est inutile sans GPU**

**Sur CPU uniquement :**
- Génération : 0.5-2 tokens/sec (vs 50-100 tokens/sec sur GPU)
- Modèles >7B quasi inutilisables

**Si vous avez un GPU NVIDIA :**

Décommentez la section `deploy` dans `docker-compose.full.yml` :

```yaml
ollama:
  # ...
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
```

### Ressources Recommandées

| Stack | RAM | CPU | Disk | Notes |
|-------|-----|-----|------|-------|
| **Allégée** | 16 GB | 8 cores | 200 GB SSD | Minimum fonctionnel |
| **Allégée (optimal)** | 32 GB | 12 cores | 500 GB SSD | Usage fluide |
| **Complète** | 32 GB | 16 cores | 500 GB SSD | Minimum recommandé |
| **Complète (optimal)** | 64 GB | 24 cores | 1 TB NVMe | Performances maximales |

---

## 🐛 Dépannage

### Service ne démarre pas

```bash
# Voir les logs détaillés
docker-compose logs service-name

# Vérifier la configuration
docker-compose config

# Redémarrer un service
docker-compose restart service-name
```

### Certificat Let's Encrypt échoue

**Vérifier :**
- Le domaine pointe bien vers le serveur (`dig votre-domaine.com`)
- Ports 80/443 sont ouverts (`netstat -tlnp | grep :80`)
- Logs Traefik : `docker-compose logs traefik`

**Solution courante :**
```bash
# Vérifier la connectivité
curl -I http://votre-domaine.com/.well-known/acme-challenge/test

# Forcer renouvellement
docker-compose restart traefik
```

### RAM insuffisante

**Réduire la consommation :**
```bash
# Limiter Elasticsearch JVM
# Dans docker-compose.full.yml :
ES_JAVA_OPTS=-Xms512m -Xmx1g  # au lieu de -Xms1g -Xmx2g
```

**Ou passer au stack allégé :**
```bash
docker-compose -f docker-compose.yml up -d
```

### Container crashe régulièrement

```bash
# Voir les logs avant crash
docker-compose logs --tail=100 service-name

# Augmenter les limites ressources
docker update --memory=4g container-name

# Vérifier l'utilisation
docker stats
```

---

## 📄 Licence

Ce fork conserve la licence MIT du projet original OpenClaw.

**Projet original :** [openclaw/openclaw](https://github.com/openclaw/openclaw)  
**Fork maintenu par :** [Manderley-LTA](https://github.com/Manderley-LTA)

---

## 🤝 Support

**Issues GitHub (fork) :** https://github.com/Manderley-LTA/claw/issues  
**Issues GitHub (original) :** https://github.com/openclaw/openclaw/issues  
**Discord OpenClaw :** https://discord.gg/clawd

---

## 📈 Historique des Stars

[![Star History Chart](https://api.star-history.com/svg?repos=openclaw/openclaw&type=date&legend=top-left)](https://www.star-history.com/#openclaw/openclaw&type=date&legend=top-left)

---

**Fait avec ❤️ pour l'auto-hébergement et la souveraineté des données.**
