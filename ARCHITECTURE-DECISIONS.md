# Architecture Decisions - OpenClaw Modular Stack

## Classification: Core vs Modulaire

### Rationale

Services are classified based on 4 criteria:

1. **Critical to OpenClaw operation** (Y = Core, N = Modular)
2. **Shared by multiple modules** (Y = Core, N = Modular)
3. **Requires isolated infrastructure** (Y = Modular, N = Core)
4. **Used in 80%+ of deployments** (Y = Core, N = Modular)

---

## Services Classification

### CORE (docker-compose.core.yml)

Must be deployed for any OpenClaw stack.

| Service | Criteria Met | Notes |
|---------|-------------|-------|
| **Traefik** | ✅ Obligatory, Used by all | Reverse proxy + SSL/TLS for all services |
| **OpenClaw** | ✅ Obligatory | Core application |
| **Portainer** | ✅ Essential mgmt | Docker container management |
| **MinIO** | ✅ Shared, Critical | S3-compatible storage for rcpro-app, n8n, etc. |
| **Redis** | ✅ Shared, Critical | Cache + message broker for multiple modules |
| **PostgreSQL** | ✅ Shared, Critical | Shared database (OpenClaw, modules) |
| **Qdrant** | ✅ Shared, 90% deployments | Vector DB for embeddings/RAG |
| **RedisInsight** | ✅ Redis companion | Redis monitoring UI |

**Total:** 8 containers, ~6-8 GB RAM

**Key insight:** All CORE services are either:
- Shared infrastructure used by multiple modules, OR
- Essential for OpenClaw operation itself

---

### MODULAIRE (Optional)

Each module is self-contained or uses core services only.

#### Monitoring (`docker-compose.monitoring.yml`)

| Service | Why Modular |
|---------|------------|
| **Prometheus** | Observability is optional; most small deployments don't need it |
| **Grafana** | Nice-to-have dashboards, not critical |
| **Loki** | Log aggregation is optional |
| **Uptime Kuma** | Uptime monitoring is optional |
| **Langfuse** | LLM observability only needed by AI teams |

**Decision:** Observability is luxury, not necessity. Adds 2-3 GB.

---

#### Search (`docker-compose.search.yml`)

| Service | Why Modular |
|---------|------------|
| **SearXNG** | Meta-search is optional; many setups use public search engines |
| **Elasticsearch** | Full-text search is optional; ~30% of deployments need it |
| **Kibana** | Elasticsearch UI, optional |

**Decision:** Advanced search is optional. Elasticsearch alone = 1-2 GB.

---

#### Security (`docker-compose.security.yml`)

| Service | Why Modular | Infrastructure |
|---------|------------|-----------------|
| **Vaultwarden** | Password manager is optional; most use external solution | Volume mount |
| **Authentik** | SSO is optional; only ~30-40% need enterprise auth | **Private DB** + **Private Redis** |
| **Duplicati** | Backups are optional; can use external backup system | Volume mount |

**Decision:** Security enhancements are optional. **Authentik requires isolated DB** (can't share with core Postgres).

---

#### Integrations (`docker-compose.integrations.yml`)

| Service | Why Modular |
|---------|------------|
| **n8n** | Workflow automation is optional |
| **Ollama** | Local LLM is optional; most use API-based LLMs. Requires GPU. |

**Decision:** Both are value-adds, not essential. Ollama = CPU-only is impractical.

---

#### Supabase (`docker-compose.supabase.yml`)

| Service | Why Modular | Infrastructure |
|---------|------------|-----------------|
| **Supabase (9 containers)** | Full backend platform is optional; use if you need Supabase-specific features | **Includes own Postgres** (can't share with core) |

**Decision:** Supabase is a **backend platform alternative**, not an add-on. Requires separate DB and 6-8 GB. ~10% of deployments need it.

---

#### Git (`docker-compose.git.yml`)

| Service | Why Modular | Infrastructure |
|---------|------------|-----------------|
| **Gitea** | Self-hosted Git is optional; most use GitHub/GitLab | **Private DB** |

**Decision:** Git hosting is optional. Most teams use public platforms. Adds 1-2 GB.

---

#### RC Pro (`docker-compose.rcpro.yml`)

| Service | Why Modular | Infrastructure |
|---------|------------|-----------------|
| **RC Pro App** | Application-specific; only Luc's use case | Uses core postgres, redis, minio |

**Decision:** Business app, not infrastructure. Reuses core services (efficient).

---

## Key Principles

### 1. **Shared vs Isolated**

- **CORE = Shared infrastructure**
  - All modules can safely share MinIO, Redis, Postgres
  - No conflicts (stateless or compatible)
  
- **MODULAIRE = Isolated infrastructure** (if needed)
  - Authentik = needs own DB (different schema)
  - Supabase = needs own Postgres (incompatible)
  - Git = needs own DB (optional)

### 2. **Cost of Inclusion**

- **CORE:** Minimal RAM overhead (~6-8 GB baseline)
- **Each module:** Add 1-4 GB based on complexity

**Goal:** Users only pay (in RAM) for what they use.

### 3. **Flexibility**

- Deploy `minimal` (core only) = 6-8 GB
- Deploy `lightweight` (core + monitoring + search) = 8-10 GB
- Deploy `full` (everything) = 32-40 GB

**No waste.** Exactly the infrastructure you need.

---

## Services NOT in Modular Stack

**Services removed from original docker-compose.full.yml:**

- None removed. All services present in one of the 8 compose files.

**Services could be added as modules:**

- **cAdvisor** (container metrics) — Could be added to monitoring.yml
- **Jaeger** (distributed tracing) — Could be a new tracing.yml module
- **Vault** (secrets management) — Could be a new secrets.yml module

---

## Future Extensibility

### Adding a New Module

Example: Add `docker-compose.cache.yml` (Redis Cluster + Memcached alternative)

```yaml
# docker-compose.cache.yml
services:
  redis-cluster:
    # ...
  memcached:
    # ...

networks:
  backend:
    external: true

volumes:
  redis_cluster_data:
  memcached_data:
```

Then deploy:
```bash
./deploy.sh --preset custom -f docker-compose.core.yml -f docker-compose.cache.yml up -d
```

---

## Decisions Made

| Decision | Rationale | Date |
|----------|-----------|------|
| MinIO in core | Shared S3 for all modules | 2026-02-18 |
| Redis in core | Shared cache for all modules | 2026-02-18 |
| Qdrant in core | VectorDB used by 90% deployments | 2026-02-18 |
| Authentik modular | Optional SSO + needs private DB | 2026-02-18 |
| Supabase modular | Alternative backend + needs private DB | 2026-02-18 |
| RC Pro modular | Business app, reuses core infra | 2026-02-18 |

---

## Revisions

None yet.
