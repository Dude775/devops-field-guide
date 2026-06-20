# Architecture — Helm Small Project Lab

ארכיטקטורה של ה-Movie API בכל שלב. כל שלב הוסיף שכבה אחת.

---

## Step 01 — Local Run

```
Client (curl / browser)
    ↓ HTTP :3000
FastAPI / Uvicorn  (Python 3.12 virtualenv, movie-api/)
    ↓ motor (async MongoDB driver)
MongoDB  (Docker container, mongo:6, port 27017 mapped to host)
```

**Configuration**: environment variables in shell — `MONGO_URI=mongodb://localhost:27017/movies`

**State**: MongoDB data lives in the container's default volume. Lost on container removal.

---

## Step 02 — Docker

```
Client (curl / browser)
    ↓ HTTP :3000
movie-api container  (idf775/movie-api:1.0, Docker network: movie-net)
    ↓ motor  (resolves hostname "mongo" inside Docker network)
mongo container  (mongo:6, same Docker network movie-net)
```

**Network**: both containers on `movie-net` bridge network. Container name = DNS hostname.

**Image**: multi-stage is not used — simple one-stage Dockerfile from `python:3.12-slim`.

**Configuration**: `-e MONGO_URI=mongodb://mongo:27017/movies` passed at `docker run`.

---

## Step 03 — Manual Kubernetes (app only, no Mongo)

```
Client (curl)
    ↓ kubectl port-forward → Service movie-api (ClusterIP :3000)
    ↓
Deployment movie-api  (1 replica, image: idf775/movie-api:1.0)
    ↓  env from ConfigMap + Secret
ConfigMap movie-api-config  → MONGO_URI, LOG_LEVEL
Secret movie-api-secret     → placeholder credentials
    ↓ MongoDB not yet in-cluster
(MongoDB still running as Docker container on host)
```

**Manifests**: `k8s/configmap.yaml`, `k8s/secret.yaml`, `k8s/deployment.yaml`, `k8s/service.yaml`

---

## Step 04 — MongoDB Inside Kubernetes

```
Client (curl)
    ↓ kubectl port-forward → Service movie-api (ClusterIP :3000)
    ↓
Deployment movie-api  (image: idf775/movie-api:1.0)
    ↓ MONGO_URI=mongodb://mongo:27017/movies  (in-cluster DNS)
Service mongo  (ClusterIP, headless, port 27017)
    ↓
StatefulSet mongo  (1 replica, mongo:6)
    ↓
PersistentVolumeClaim  (8Gi, standard StorageClass, Minikube hostPath)
```

**Persistence**: data survives Pod restarts because PVC outlives the Pod.

**DNS**: Service name `mongo` resolves to `mongo.default.svc.cluster.local` inside cluster.

---

## Step 05 — Helm Chart (movie-chart)

```
helm upgrade --install demo movie-chart
    ↓ renders templates
    ↓
ConfigMap demo-movie-api-config
Secret demo-movie-api-secret
Deployment demo-movie-api  ← image: idf775/movie-api:1.1
Service demo-movie-api
Service demo-mongo           (Mongo still local templates)
StatefulSet demo-mongo
PVC (via volumeClaimTemplates)
```

**Values override chain**: `values.yaml` → `--set flag` → `-f values-prod.yaml`

**Release management**:
```
helm history demo
REVISION  STATUS     CHART            DESCRIPTION
1         superseded movie-chart-0.1.0  Install complete
2         superseded movie-chart-0.1.0  Upgrade complete (replicaCount=3)
3         deployed   movie-chart-0.1.0  Upgrade complete (values-prod.yaml)
```

`helm rollback demo 1` → creates revision 4, restores revision 1 config.

---

## Step 06 — Helm MongoDB Dependency (Bitnami)

```
helm upgrade --install demo movie-chart
    ↓ includes charts/mongodb-15.6.26.tgz (Bitnami)
    ↓ renders combined templates
    ↓
ConfigMap demo-movie-api-config
Secret demo-movie-api-secret  → mongodb://root:secretpass@demo-mongodb:27017/movies?authSource=admin
Deployment demo-movie-api  ← image: idf775/movie-api:1.1
Service demo-movie-api
────────────────────────────── subchart boundary ──────────────────────────────
Service demo-mongodb          (Bitnami managed)
StatefulSet demo-mongodb      (Bitnami managed)
PVC data-demo-mongodb-0       (Bitnami managed, 8Gi)
ConfigMap demo-mongodb        (Bitnami init scripts)
Secret demo-mongodb           (Bitnami auth secrets)
```

**Dependency declaration** in `Chart.yaml`:
```yaml
dependencies:
  - name: mongodb
    version: "15.6.26"
    repository: "https://charts.bitnami.com/bitnami"
```

**Subchart service name**: `{{ .Release.Name }}-mongodb` — release-prefixed, not static.

**Auth URI**: `mongodb://root:secretpass@demo-mongodb:27017/movies?authSource=admin`  
`authSource=admin` is required because Bitnami creates the root user in the `admin` database.

---

## Data Persistence Story

| Step | Where data lives | Survives Pod restart? | Survives `helm uninstall`? |
|------|------------------|-----------------------|---------------------------|
| 01 | Container default volume | No | No |
| 02 | Container default volume | No | No |
| 03 | No in-cluster MongoDB yet | — | — |
| 04 | PVC (Minikube hostPath) | Yes | Yes — PVC not auto-deleted |
| 05 | PVC (StatefulSet VCT) | Yes | Yes — must delete manually |
| 06 | PVC (Bitnami, `data-demo-mongodb-0`) | Yes | Yes — must delete manually |

---

## Configuration Story

| Step | How config is delivered | Sensitive values |
|------|------------------------|-----------------|
| 01 | Shell env vars | In shell only |
| 02 | `docker run -e` flags | In shell only |
| 03 | ConfigMap + Secret manifests | base64 in Secret |
| 04 | Same, MONGO_URI updated to in-cluster DNS | base64 in Secret |
| 05 | Helm values.yaml + templates | value in values.yaml (lab only) |
| 06 | Helm values.yaml + subchart values | `auth.rootPassword` in values.yaml (lab only) |

In production, sensitive values should come from external secret managers (Vault, AWS Secrets Manager, Sealed Secrets) — not from `values.yaml` committed to git.
