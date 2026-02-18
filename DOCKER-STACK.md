# OpenClaw Docker Stack

Docker stack complet pour déployer OpenClaw et ses services associés.

**Configurations disponibles :**
- Stack allégé (12 GB RAM) — Recommandé
- Stack complet (32+ GB RAM) — Avec Supabase, Elasticsearch, Gitea, Ollama
- **Optionnel :** Intégration RC Pro App (expertise responsabilité civile)

Deux configurations de base selon vos ressources :

## 🪶 Stack Allégé (docker-compose.yml) - 12 GB RAM

**Fichier :** `docker-compose.yml`

**Services inclus (22 containers) :**
- ✅ Traefik (reverse proxy HTTPS)
- ✅ OpenClaw (gateway + CLI)
- ✅ Portainer (gestion Docker)
- ✅ MinIO (S3 object storage)
- ✅ Redis + RedisInsight
- ✅ PostgreSQL (standalone)
- ✅ Qdrant (vector database)
- ✅ n8n (workflow automation)
- ✅ Prometheus + Grafana + Loki (monitoring)
- ✅ Uptime Kuma (uptime monitoring)
- ✅ Langfuse (LLM observability)
- ✅ Duplicati (backups)
- ✅ Vaultwarden (password manager)
- ✅ Authentik (SSO/Identity provider)
- ✅ SearXNG (meta-search engine)

**Exclus du stack allégé :**
- ❌ Supabase complet (remplacé par Postgres standalone)
- ❌ Elasticsearch + Kibana
- ❌ Ollama (inutile sans GPU)
- ❌ Gitea (utiliser GitHub)

---

## 🚀 Stack Complet (docker-compose.full.yml) - 32+ GB RAM

**Fichier :** `docker-compose.full.yml`

**Services additionnels (~39 containers) :**
- ✅ **Supabase complet** (9 containers) :
  - postgres (avec pgvector)
  - studio (UI admin)
  - kong (API gateway)
  - rest (PostgREST)
  - auth (GoTrue)
  - realtime (WebSocket)
  - storage (file storage API)
  - meta (métadonnées)
  - imgproxy (transformation images)
  - vector (logs)
- ✅ **Elasticsearch + Kibana** (recherche full-text avancée)
- ✅ **Gitea** (Git self-hosted avec DB dédiée)
- ✅ **Ollama** (LLM local, nécessite GPU)
- ✅ **SearXNG** (meta-search engine, inclus aussi dans stack allégé)

---

## 🚦 Démarrage rapide

### 1. Prérequis

- Docker + Docker Compose v2
- 12 GB RAM minimum (stack allégé) ou 32 GB (stack complet)
- Domaine pointant vers votre serveur

### 2. Configuration

**Copier et éditer le fichier .env :**
```bash
cp .env.example .env
nano .env
```

**Variables obligatoires à modifier :**
```bash
DOMAIN=votre-domaine.com
ACME_EMAIL=votre@email.com
OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
MINIO_ROOT_PASSWORD=$(openssl rand -hex 32)
REDIS_PASSWORD=$(openssl rand -hex 32)
# ... etc (voir .env.example)
```

### 3. Lancer le stack

**Stack allégé (recommandé pour 12 GB) :**
```bash
docker-compose up -d
```

**Stack complet (nécessite 32+ GB) :**
```bash
docker-compose -f docker-compose.full.yml up -d
```

### 4. Vérifier les logs

```bash
docker-compose logs -f
```

---

## 🌐 Accès aux services

Tous les services sont accessibles via HTTPS sur votre domaine :

| Service | URL | Credentials |
|---------|-----|-------------|
| **Traefik Dashboard** | `https://votre-domaine.com/traefik` | admin / (htpasswd) |
| **OpenClaw** | `https://votre-domaine.com/claw` | Token dans .env |
| **Portainer** | `https://votre-domaine.com/portainer` | Créer lors 1ère visite |
| **MinIO Console** | `https://votre-domaine.com/minio` | MINIO_ROOT_USER/PASSWORD |
| **RedisInsight** | `https://votre-domaine.com/redis` | - |
| **Qdrant** | `https://votre-domaine.com/qdrant` | QDRANT_API_KEY |
| **n8n** | `https://votre-domaine.com/n8n` | Créer lors 1ère visite |
| **Grafana** | `https://votre-domaine.com/grafana` | admin / GF_SECURITY_ADMIN_PASSWORD |
| **Uptime Kuma** | `https://votre-domaine.com/uptime` | Créer lors 1ère visite |
| **Langfuse** | `https://votre-domaine.com/langfuse` | Créer lors 1ère visite |
| **Duplicati** | `https://votre-domaine.com/duplicati` | - |
| **Vaultwarden** | `https://votre-domaine.com/vault` | Créer lors 1ère visite |
| **Authentik** | `https://votre-domaine.com/auth` | Créer lors 1ère visite |
| **SearXNG** | `https://votre-domaine.com/search` | Public (accès libre) |

**Stack complet uniquement :**

| Service | URL | Credentials |
|---------|-----|-------------|
| **Supabase Studio** | `https://votre-domaine.com/supabase` | - |
| **Kibana** | `https://votre-domaine.com/kibana` | elastic / ELASTIC_PASSWORD |
| **Gitea** | `https://votre-domaine.com/git` | Créer lors 1ère visite |
| **SearXNG** | `https://votre-domaine.com/search` | Public (inclus aussi dans stack allégé) |

---

## 📊 Configuration Prometheus

Le fichier `prometheus.yml` est fourni avec des scrape configs de base.

**Pour ajouter des métriques de containers (optionnel) :**

Ajoutez cAdvisor au docker-compose :
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

Puis décommentez la section `cadvisor` dans `prometheus.yml`.

---

## 🔐 Sécurité

**Générer tous les mots de passe/secrets :**
```bash
# Génération automatique de secrets forts
sed -i "s/change-me-strong-password/$(openssl rand -hex 32)/g" .env
sed -i "s/change-me-32-char-encryption-key/$(openssl rand -hex 16)/g" .env
sed -i "s/change-me-50-char-secret-key/$(openssl rand -hex 25)/g" .env
sed -i "s/change-me-searxng-secret-key/$(openssl rand -hex 32)/g" .env
# etc.
```

**SearXNG (optionnel) :**
```bash
# Le secret SEARXNG_SECRET est utilisé pour chiffrer les sessions.
# Par défaut, SearXNG active les moteurs de recherche courants (Google, Bing, DuckDuckGo, etc.)
# Pour modifier les moteurs activés, éditer `/etc/searxng/settings.yml` dans le container.
```

**BasicAuth pour Traefik Dashboard :**
```bash
# Générer un hash htpasswd
htpasswd -nb admin VotreMotDePasse
# Copier le résultat dans le label traefik.http.middlewares.auth.basicauth.users
```

**Firewall :**
```bash
# N'exposer QUE les ports 80 et 443
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

---

## 🛠️ Maintenance

**Mettre à jour les images :**
```bash
docker-compose pull
docker-compose up -d
```

**Voir l'utilisation des ressources :**
```bash
docker stats
```

**Sauvegarder les volumes :**
```bash
# Duplicati le fait automatiquement, ou manuellement :
docker run --rm -v nom_du_volume:/source -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /source .
```

**Nettoyer les images inutilisées :**
```bash
docker system prune -a
```

---

## ⚠️ Notes importantes

### Stack Complet - Supabase

**Configuration supplémentaire requise :**

Supabase nécessite des fichiers de configuration additionnels :
- `supabase/volumes/db/realtime.sql` - Init script Realtime
- `supabase/volumes/api/kong.yml` - Config Kong API Gateway
- `supabase/volumes/logs/vector.yml` - Config Vector logs

**Récupérer les configs officielles :**
```bash
git clone https://github.com/supabase/supabase
cp -r supabase/docker/* ./supabase/volumes/
```

Ou télécharger depuis : https://github.com/supabase/supabase/tree/master/docker

### Ollama (GPU requis)

Ollama est **inutile sans GPU**. Sur CPU uniquement :
- Génération : 0.5-2 tokens/sec (vs 50-100 tokens/sec GPU)
- Modèles >7B quasi inutilisables

**Si vous avez un GPU NVIDIA**, décommentez la section `deploy` dans le service `ollama` du docker-compose.full.yml.

### PostgreSQL partagé

Dans le stack complet, plusieurs services partagent le Postgres de Supabase :
- n8n
- Langfuse

Cela économise de la RAM mais crée une dépendance. Pour isoler, créez des instances Postgres séparées.

---

## 🐛 Dépannage

**Service ne démarre pas :**
```bash
docker-compose logs nom_du_service
```

**Port déjà utilisé :**
```bash
netstat -tulpn | grep :80
# ou
ss -tulpn | grep :80
```

**Certificat Let's Encrypt échoue :**
- Vérifiez que le domaine pointe bien vers le serveur
- Vérifiez que les ports 80/443 sont ouverts
- Consultez les logs Traefik : `docker-compose logs traefik`

**RAM insuffisante :**
- Réduisez les limites JVM Elasticsearch : `ES_JAVA_OPTS=-Xms512m -Xmx1g`
- Désactivez des services non essentiels
- Passez au stack allégé

**Container crashe régulièrement :**
```bash
# Augmenter les limites mémoire
docker-compose up -d --force-recreate --scale nom_du_service=1
```

---

## 🚀 Intégration RC Pro App (Optionnel)

**RC Pro** est une application d'expertise responsabilité civile qui peut être intégrée au stack OpenClaw.

### Prérequis

- Stack OpenClaw déjà déployé (voir ci-dessus)
- Repo `rcpro-app` disponible (chemin : `../rcpro-app/` par défaut)
- Variables `RCPRO_*` configurées dans `.env`

### Configuration

**1. Récupérer le repo rcpro-app :**
```bash
cd /dossier/parent/du/claw-repo
git clone <url-rcpro-app>
# Structure:
# .
# ├── claw-repo/
# │   ├── docker-compose.yml
# │   ├── docker-compose.rcpro.yml
# │   ├── .env
# │   └── ...
# └── rcpro-app/
#     ├── backend/
#     ├── frontend/
#     └── docx-service/
```

**2. Ajouter variables RCPRO_* dans `.env` :**
```bash
# Copier depuis .env.example (section RC Pro App)
RCPRO_JWT_ACCESS_SECRET=$(openssl rand -hex 32)
RCPRO_JWT_REFRESH_SECRET=$(openssl rand -hex 32)
RCPRO_ADMIN_PASSWORD=change-me-strong-password
# ... autres variables
```

**3. Initialiser la base de données RC Pro :**
```bash
# Exécuter les migrations dans Postgres (via stack OpenClaw)
cd ../rcpro-app
cat migrations/*.sql | docker compose -f /path/to/docker-compose.yml exec -T postgres psql -U ${POSTGRES_USER} -d ${RCPRO_DB_NAME}
```

### Démarrage

**Incluire RC Pro au démarrage :**
```bash
# Stack allégé + RC Pro
docker compose -f docker-compose.yml -f docker-compose.rcpro.yml up -d

# Stack complet + RC Pro
docker compose -f docker-compose.full.yml -f docker-compose.rcpro.yml up -d
```

### URLs RC Pro

| Service | URL |
|---------|-----|
| **Frontend** | `https://votre-domaine.com/rcpro` |
| **API** | `https://votre-domaine.com/rcpro/api/v1` |
| **Health** | `https://votre-domaine.com/rcpro/api/v1/health` |

### Arrêt

```bash
docker compose -f docker-compose.yml -f docker-compose.rcpro.yml down
```

### Logs

```bash
# Tous les services RC Pro
docker compose logs rcpro-backend rcpro-frontend rcpro-docx-service

# Service spécifique
docker compose logs rcpro-backend -f
```

### Notes

- **Réutilise Postgres, Redis, MinIO** du stack OpenClaw (zéro redondance)
- **Mode dev** : code volume-mounted (`npm install && npm run dev`)
  - Pour production, remplacer par images pré-buildées
- **OpenClaw agents** : RC Pro peut orchestrer les 7 agents RC Pro via `OPENCLAW_GATEWAY_TOKEN`
- **Facture/DOCX** : service Python génère rapports et factures

---

## 📚 Documentation

- **OpenClaw** : https://docs.openclaw.ai
- **Traefik** : https://doc.traefik.io/traefik/
- **Supabase** : https://supabase.com/docs
- **n8n** : https://docs.n8n.io
- **Grafana** : https://grafana.com/docs
- **Qdrant** : https://qdrant.tech/documentation
- **RC Pro** : `/path/to/rcpro-app/README.md`

---

## 🤝 Support

Issues GitHub :
- OpenClaw : https://github.com/Manderley-LTA/claw/issues
- RC Pro : https://github.com/Manderley-LTA/rcpro-app/issues
