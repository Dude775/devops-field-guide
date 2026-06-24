# Discovered Project Markers
Generated: 2026-06-20

Markers searched: Dockerfile, docker-compose.yml, Chart.yaml, values.yaml, requirements.txt, package.json, Chart.yaml, deployment.yaml, etc.

---

## Dockerfile Locations

| Path | Parent Folder | In Git Repo? | Nearest Repo | Lab/Project Name |
|------|-------------|-------------|-------------|-----------------|
| `Desktop\CI-CD\lab 8.9\express-api\Dockerfile` | express-api | No .git found | — | CI-CD lab 8.9 |
| `Desktop\CI-CD\student-api\Dockerfile` | student-api | YES | Dude775/student-api | CI-CD student API |
| `Desktop\IRAN-3\backend\Dockerfile` | backend | YES (empty repo) | IRAN-3/backend | IRAN-3 NestJS project |
| `Desktop\Kubeinertis\color-api-code\...` | color-api-code | No | — | K8s color API lab |
| `Desktop\Kubeinertis\color_api_1_1_0\Dockerfile` | color_api_1_1_0 | No | — | K8s color API v1.1.0 |
| `Genspark\active\code-review-agent-test\Dockerfile` | code-review-agent-test | YES | Dude775/code-review-agent | Code review agent |
| `Genspark\active\job-hunter\Dockerfile` | job-hunter | YES (no remote) | job-hunter | Job hunter (active) |
| `Genspark\archive\stylegan3\Dockerfile` | stylegan3 | YES | NVlabs/stylegan3 | StyleGAN3 reference |
| `Genspark\devops-field-guide\07-docker\labs\lab5.1-nginx-*` | lab5.1 | YES | devops-field-guide | Docker lab 5.1 |
| `Genspark\devops-field-guide\07-docker\labs\lab5.2-copy-*` | lab5.2 | YES | devops-field-guide | Docker lab 5.2 |

---

## docker-compose.yml Locations

| Path | Parent Folder | In Git Repo? | Nearest Repo | Lab/Project Name |
|------|-------------|-------------|-------------|-----------------|
| `Genspark\active\code-review-agent-test\docker-compose.yml` | code-review-agent-test | YES | Dude775/code-review-agent | Code review agent |
| `Genspark\active\job-hunter\docker-compose.yml` | job-hunter | YES (no remote) | job-hunter | Job hunter (active) |
| `Genspark\devops-field-guide\07-docker\early-labs\live-lesson-compose\*` | live-lesson-compose | YES | devops-field-guide | Docker live lesson |
| `Genspark\devops-field-guide\11-aws-advanced\microservices-ecs-deploy\*` | microservices-ecs-deploy | YES | devops-field-guide | ECS microservices deploy |

---

## Chart.yaml Locations (Helm Charts)

| Path | Parent Folder | In Git Repo? | Nearest Repo | Chart Name |
|------|-------------|-------------|-------------|-----------|
| `Desktop\creating-charts\nginx\Chart.yaml` | nginx | No | — | nginx helm chart (lab) |
| `Desktop\Kubeinertis\day03\Helm\intro-go-templating\*` | intro-go-templating | No | — | Go templating helm lab |
| `Genspark\devops-field-guide\10-helm\helm-small-project-lab\*` | helm-small-project-lab | YES | devops-field-guide | helm-small-project |
| `Genspark\DevOps-Materials\Helm\4\4.0\creating-charts\nginx\*` | creating-charts | YES | DevOps-Materials/IITC | IITC Helm course 4.0 |
| `Genspark\DevOps-Materials\Helm\4\4.1\intro-go-templating\*` | intro-go-templating | YES | DevOps-Materials/IITC | IITC Helm course 4.1 |
| `Genspark\DevOps-Materials\Helm\4\4.10\creating-charts\*` | creating-charts | YES | DevOps-Materials/IITC | IITC Helm course 4.10 |

---

## Notable Observations

### helm-small-project Chart.yaml Found In Lab
- `devops-field-guide\10-helm\helm-small-project-lab\01-source\helm-small-project\Chart.yaml` — Lab homework
- Multiple `Chart.yaml` files in `DevOps-Materials\Helm\4\*` — Course reference materials (IITC)

### Desktop Helm Charts (not in git)
- `Desktop\creating-charts\nginx\Chart.yaml` — Likely created during `creating-charts` lab session
- `Desktop\Kubeinertis\day03\Helm\intro-go-templating\*` — K8s/Helm day 3 lab

### Docker in Non-Obvious Places
- `devops-field-guide\07-docker\` — Docker module exists inside devops-field-guide (module 07)
- `devops-field-guide\11-aws-advanced\microservices-ecs-deploy\` — ECS deployment (active untracked content)

---

## Summary by Category

| Category | Count | Examples |
|----------|-------|---------|
| Dockerfile | 10+ | job-hunter, iran-3, student-api, labs |
| docker-compose.yml | 4+ | job-hunter, code-review, live-lesson, ecs-deploy |
| Chart.yaml | 6+ | helm-small-project, creating-charts, DevOps-Materials |
| values.yaml | 6+ | Same as Chart.yaml locations |
