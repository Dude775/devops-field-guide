# Docker Local State
Generated: 2026-06-20

---

## Docker Context

```
NAME              DESCRIPTION                               DOCKER ENDPOINT
default           Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine
desktop-linux *   Docker Desktop                            npipe:////./pipe/dockerDesktopLinuxEngine
```
Active context: `desktop-linux` (Docker Desktop)

---

## Containers (`docker ps -a`)

| Container ID | Image | Status | Ports | Name | Classification |
|-------------|-------|--------|-------|------|----------------|
| fa52015c2e46 | lironefitoussi/aws-sol-2 | Exited 2 days ago | — | gallant_feynman | Course lab container (AWS solution) |
| 351d6c86f9c4 | 450963613786.dkr.ecr.us-east-1.amazonaws.com/ecr-demo:latest | Exited 3 days ago | — | app | ECR demo from AWS lab |
| dafafc6a873d | lironefitoussi/aws-sol-1:latest | Exited 3 days ago | — | hungry_chatterjee | Course lab container (AWS solution) |
| a202ce691269 | 0ee2d7eee745 (movie-api image) | Exited 3 days ago (was on :3000) | — | movie-api | Helm small project lab container |
| 0ef49875e237 | mongo:7 | Exited ~1 hour ago | — | mongo-old-before-step01 | **Name suggests pre-migration state** |
| 1685e044e9b0 | gcr.io/k8s-minikube/kicbase:v0.0.50 | **UP 45 min** | 22/2376/5000/8443/32443 | minikube | **ACTIVE - Minikube K8s node** |
| 1fb4114cf4e9 | iran-3-backend | Exited 6 days ago | — | shopflow-backend | IRAN-3 project backend |
| 213b5760fc04 | postgres:17 | Exited 6 days ago | — | shopflow-postgres | IRAN-3 project database |

### Classification Summary
- **Active (Running):** 1 — `minikube` (K8s node)
- **Stale (Exited):** 7
  - Safe to remove later: `gallant_feynman`, `app` (ECR demo), `hungry_chatterjee`, `movie-api`
  - Needs care: `mongo-old-before-step01` (name implies it was before a migration step)
  - IRAN-3 project: `shopflow-backend`, `shopflow-postgres` (active project, paused)

---

## Images (`docker images`)

| Image | ID | Size | Classification | Safe to Remove Later? |
|-------|-----|------|---------------|----------------------|
| `450963613786.dkr.ecr.us-east-1.amazonaws.com/ecr-demo:latest` | 15cc573a44f1 | 181MB | AWS ECR demo image (pulled from AWS) | Yes, after lab done |
| `dude775/movie-api:1.0` | d883ae7523bb | 260MB | Same as idf775 (alias) | Keep (same image) |
| `ecr-demo:latest` | 15cc573a44f1 | 181MB | Same ID as ecr-demo above | Same as above |
| `gcr.io/k8s-minikube/kicbase:v0.0.50` | b97074569ae9 | 1.94GB | Minikube base | **Keep - active K8s** |
| `gcr.io/k8s-minikube/kicbase@sha256:eb4f...` | eb4fec00e8ad | 1.94GB | Minikube older digest | Possibly remove old digest |
| `idf775/movie-api:1.0` | d883ae7523bb | 260MB | Helm lab movie API v1.0 | Keep (Docker Hub image) |
| `idf775/movie-api:1.1` | c5d9280c5ff7 | 260MB | Helm lab movie API v1.1 | Keep (Docker Hub image) |
| `inventory-service:latest` | e035bddc3e1e | 204MB | Microservices lab | Review |
| `iran-3-backend:latest` | 3abd593a13d1 | 463MB | IRAN-3 NestJS backend | Keep - active project |
| `lironefitoussi/aws-sol-1:latest` | 84d6e950bf2d | 74.2MB | Course solution image | Safe to remove after lab |
| `lironefitoussi/aws-sol-2:latest` | 8139c7fd1996 | 74.2MB | Course solution image | Safe to remove after lab |
| `mcp/obsidian@sha256:0eba...` | 0eba4c05742a | 215MB | MCP Obsidian tool | Check if in use |
| `mcp/playwright@sha256:43e3...` | 43e3be2da74d | 1.43GB | MCP Playwright tool | Check if in use |
| `mongo:7` | 8ecb514b00bd | 1.19GB | MongoDB | Used by multiple projects |
| `orders-service:latest` | b72d0aac4479 | 208MB | Microservices lab | Review |
| `postgres:17` | 0027bef26712 | 645MB | PostgreSQL | Used by multiple projects |

### Images Probably Safe to Remove Later (after David confirms labs done)
- `lironefitoussi/aws-sol-1:latest` (74MB)
- `lironefitoussi/aws-sol-2:latest` (74MB)
- `450963613786.dkr.ecr.us-east-1.amazonaws.com/ecr-demo:latest` + `ecr-demo:latest` (181MB each, same ID)
- `gcr.io/k8s-minikube/kicbase@sha256:eb4f...` older digest if active is `v0.0.50` (1.94GB)

### Images to Keep
- `gcr.io/k8s-minikube/kicbase:v0.0.50` — Active minikube
- `idf775/movie-api:1.0` + `1.1` — Docker Hub published images for helm lab
- `iran-3-backend:latest` — Active project
- `mongo:7` — Used by projects
- `postgres:17` — Used by projects

---

## Volumes (`docker volume ls`)

| Volume Name | Classification | Do NOT Delete Without Confirmation |
|------------|---------------|-----------------------------------|
| `1a23099bf5...` | Unknown (anonymous) | Investigate before deleting |
| `2bddd7d631...` | Unknown (anonymous) | Investigate before deleting |
| `6ffa7bbac6...` | Unknown (anonymous) | Investigate before deleting |
| `a5e7cf3a58...` | Unknown (anonymous) | Investigate before deleting |
| `ca759815c0...` | Unknown (anonymous) | Investigate before deleting |
| `f9b49efbcc...` | Unknown (anonymous) | Investigate before deleting |
| `iran-3_postgres-data` | **NAMED — IRAN-3 project data** | **DO NOT DELETE** |
| `minikube` | Minikube K8s data | **DO NOT DELETE** — active cluster |

> **Rule:** All named volumes must be confirmed with David before deletion. Anonymous volumes need inspection first.

---

## Networks (`docker network ls`)

| Network | Driver | Notes |
|---------|--------|-------|
| `bridge`, `host`, `none` | system | System defaults - do not touch |
| `iran-3_backend-net` | bridge | IRAN-3 project |
| `live-lesson-compose_default` | bridge | Course live lesson compose network |
| `microservices-docker_*` (5 networks) | bridge | Microservices lab networks |
| `minikube` | bridge | Minikube K8s |
| `movie-net` | bridge | Movie API (helm lab) |
| `my-network` | bridge | Generic - unknown project |
| `personalknowledgeblog_internal` | bridge | Personal Knowledge Blog project |
| `postgres-network` | bridge | Postgres shared network |
| `smartbasket_default` | bridge | SmartBasket project |

---

## Summary
- Total containers: 8 (1 running, 7 exited)
- Total images: 16 (approx 7.5GB disk)
- Total volumes: 8 (2 named critical, 6 anonymous)
- Total networks: 16

**Potential disk savings (after approval):** ~350MB containers + ~400MB course images
