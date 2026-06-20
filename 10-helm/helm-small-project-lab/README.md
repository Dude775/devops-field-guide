# Helm Small Project Lab

> **Status**: Completed  
> **Source repo**: https://github.com/Dude775/helm-small-project/tree/lab-homework  
> **Upstream**: https://github.com/LironeFitoussi/helm-small-project  
> **Docker images**: `idf775/movie-api:1.0`, `idf775/movie-api:1.1`  
> **Latest commit**: `badf2f3`

---

## Overview

לאב מלא שלוקח FastAPI Movie API מריצה מקומית עד Helm עם MongoDB subchart.

כל שלב בנוי על הקודם — מ-Docker ידני, דרך Kubernetes manifests, ועד Helm chart עם dependency management.

---

## Repositories

| Role | URL |
|------|-----|
| Work repo (lab branch) | https://github.com/Dude775/helm-small-project/tree/lab-homework |
| Upstream (original) | https://github.com/LironeFitoussi/helm-small-project |
| Field guide section | `10-helm/helm-small-project-lab/` |
| Step docs | `01-source/helm-small-project/docs/` |
| Evidence logs | `01-source/helm-small-project/notes/` |

---

## Final Architecture

```
curl / port-forward
    ↓
Service (movie-api) — ClusterIP :3000
    ↓
Deployment (movie-api) — image: idf775/movie-api:1.1
    ↓
Service (demo-mongodb) — ClusterIP :27017
    ↓
StatefulSet (demo-mongodb) ← Bitnami MongoDB subchart
    ↓
PersistentVolumeClaim — 8Gi
```

ה-Helm release `demo` מנהל את כל האובייקטים האלה יחד.

---

## Completed Steps

| Step | Topic | Status | Docs |
|------|-------|--------|------|
| 01 | Local app run — virtualenv, uvicorn, CRUD test | Done | [step-01-run-app.md](01-source/helm-small-project/docs/step-01-run-app.md) |
| 02 | Dockerize — build, run, push idf775/movie-api:1.0 | Done | [step-02-docker.md](01-source/helm-small-project/docs/step-02-docker.md) |
| 03 | Manual Kubernetes — ConfigMap, Secret, Deployment, Service | Done | [step-03-k8s-manual.md](01-source/helm-small-project/docs/step-03-k8s-manual.md) |
| 04 | MongoDB in Kubernetes — StatefulSet, PVC, in-cluster URI | Done | [step-04-k8s-mongodb.md](01-source/helm-small-project/docs/step-04-k8s-mongodb.md) |
| 04.5 | Rebuild with logging — idf775/movie-api:1.1, LOG_LEVEL | Done | [step-04.5-rebuild-logging.md](01-source/helm-small-project/docs/step-04.5-rebuild-logging.md) |
| 05 | Basic Helm chart — movie-chart, upgrade/rollback/uninstall | Done | [step-05-helm-basic.md](01-source/helm-small-project/docs/step-05-helm-basic.md) |
| 06 | Helm MongoDB dependency — Bitnami subchart, Chart.lock | Done | [step-06-helm-mongodb-dependency.md](01-source/helm-small-project/docs/step-06-helm-mongodb-dependency.md) |

---

## Key Commands Learned

### Docker
```bash
docker build -t idf775/movie-api:1.0 movie-api
docker run -d --name movie-api --network movie-net -p 3000:3000 idf775/movie-api:1.0
docker tag dude775/movie-api:1.0 idf775/movie-api:1.0
docker push idf775/movie-api:1.0
```

### Kubernetes
```bash
kubectl apply -f k8s/
kubectl rollout status deploy/movie-api
kubectl logs deploy/movie-api --tail=80
kubectl exec -it mongo-0 -- mongosh
kubectl port-forward svc/movie-api 3000:3000
kubectl delete deploy movie-api --ignore-not-found=true
```

### Helm
```bash
helm lint movie-chart
helm template demo movie-chart
helm upgrade --install demo movie-chart
helm upgrade demo movie-chart --set replicaCount=3
helm upgrade demo movie-chart -f movie-chart/values-prod.yaml
helm history demo
helm rollback demo 1
helm uninstall demo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update movie-chart
```

---

## Troubleshooting Highlights

| Problem | Cause | Fix |
|---------|-------|-----|
| PowerShell commands failed in Git Bash | Shell mismatch | Moved inventory to Bash script |
| kubectl/helm unreachable | Minikube was stopped | `minikube start --driver=docker` |
| MongoDB container had no host port | Was created without `-p` flag | Renamed container, re-created with `-p 27017:27017` |
| FastAPI install failed | venv used Python 3.7 + pip 19 | Re-created venv with Python 3.12 |
| Docker push denied | Wrong namespace `dude775` | Re-tagged to `idf775`, `docker login` |
| Mongo PVC stuck terminating | StatefulSet / Pod still held the volume | Deleted StatefulSet → force-deleted `mongo-0` → deleted services / PVCs |

Full details: [troubleshooting.md](troubleshooting.md)

---

## Final Cleanup Status

- [x] Git clean — branch `lab-homework` pushed, latest commit `badf2f3`
- [x] No `movie-api` or `mongo` Kubernetes resources remaining
- [x] PVCs deleted
- [x] Helm releases uninstalled
- [x] Only unrelated (WordPress/nginx) resources left in cluster
- [x] Minikube Docker container running (cluster kept alive)

---

## Internal Documentation

| File | Purpose |
|------|---------|
| [commands.md](commands.md) | Full command reference by phase |
| [troubleshooting.md](troubleshooting.md) | Incident log with root cause and fix |
| [architecture.md](architecture.md) | Architecture diagrams per step |
| [01-source/helm-small-project/docs/](01-source/helm-small-project/docs/) | Step-by-step walkthrough docs |
| [01-source/helm-small-project/notes/](01-source/helm-small-project/notes/) | Raw evidence: logs, JSON outputs |
