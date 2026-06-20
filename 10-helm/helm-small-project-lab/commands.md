# Command Reference — Helm Small Project Lab

כל הפקודות לפי שלב. כולל הערות על מה שלא עבד בפעם הראשונה.

---

## Environment / Verification

| Command | Purpose | Notes |
|---------|---------|-------|
| `minikube status` | Check cluster state | If stopped → start it first |
| `minikube start --driver=docker` | Start cluster | Required after machine restart |
| `kubectl get nodes` | Verify cluster is reachable | `connection refused` = Minikube not running |
| `kubectl config current-context` | Confirm active context | Should be `minikube` |
| `helm version` | Verify Helm installed | Requires v3+ |
| `docker ps` | List running containers | Minikube runs as a container |
| `docker images` | List local images | Check before build |

---

## Python Local Run (Step 01)

| Command | Purpose | Notes |
|---------|---------|-------|
| `docker run -d --name mongo -p 27017:27017 mongo:6` | Start MongoDB with host port | Original container had no `-p`, had to re-create |
| `python3.12 -m venv .venv` | Create virtualenv | Python 3.7 causes FastAPI install failure |
| `source .venv/bin/activate` | Activate venv | Git Bash / WSL |
| `pip install -r requirements.txt` | Install dependencies | Requires pip 21+ |
| `uvicorn app.main:app --host 0.0.0.0 --port 3000 --reload` | Start API | Run from `movie-api/` |
| `curl http://localhost:3000/health` | Health check | Expected: `{"status":"ok"}` |
| `curl -X POST http://localhost:3000/movies -H "Content-Type: application/json" -d '{"title":"Test","year":2024}'` | Create movie | CRUD test |
| `curl -X DELETE http://localhost:3000/movies/<id>` | Delete test movie | Clean up after test |

---

## Docker (Step 02)

| Command | Purpose | Notes |
|---------|---------|-------|
| `docker network create movie-net` | Create app network | Containers talk by name on this network |
| `docker build -t idf775/movie-api:1.0 movie-api` | Build image | Run from project root |
| `docker run -d --name movie-api --network movie-net -p 3000:3000 -e MONGO_URI=mongodb://mongo:27017/movies idf775/movie-api:1.0` | Run container | Mongo container must be on same network |
| `docker logs movie-api` | Check app logs | Verify MongoDB connection |
| `curl http://localhost:3000/health` | Test containerized app | |
| `docker tag dude775/movie-api:1.0 idf775/movie-api:1.0` | Fix namespace | Was built with wrong tag initially |
| `docker login` | Authenticate to Docker Hub | Required before push |
| `docker push idf775/movie-api:1.0` | Push to Docker Hub | |

**Step 04.5 rebuild (image v1.1):**

| Command | Purpose |
|---------|---------|
| `docker build -t idf775/movie-api:1.1 movie-api` | Build with logging changes |
| `docker push idf775/movie-api:1.1` | Push v1.1 |

---

## Kubernetes Manual Manifests (Step 03)

| Command | Purpose | Notes |
|---------|---------|-------|
| `kubectl apply -f k8s/configmap.yaml` | Create ConfigMap | `MONGO_URI`, `LOG_LEVEL` |
| `kubectl apply -f k8s/secret.yaml` | Create Secret | base64-encoded credentials |
| `kubectl apply -f k8s/deployment.yaml` | Create Deployment | References ConfigMap + Secret |
| `kubectl apply -f k8s/service.yaml` | Create Service | ClusterIP on port 3000 |
| `kubectl apply -f k8s/` | Apply all manifests | Applies directory |
| `kubectl rollout status deploy/movie-api` | Wait for rollout | Blocks until ready |
| `kubectl get pods` | List pods | Check status |
| `kubectl logs deploy/movie-api --tail=80` | Tail app logs | |
| `kubectl port-forward svc/movie-api 3000:3000` | Expose locally | Ctrl+C to stop |
| `curl http://localhost:3000/health` | Test through K8s | |
| `kubectl exec -it <pod> -- /bin/sh` | Shell into pod | For debugging |

---

## MongoDB StatefulSet / PVC (Step 04)

| Command | Purpose | Notes |
|---------|---------|-------|
| `kubectl apply -f k8s/mongo-service.yaml` | Headless service for Mongo | DNS: `mongo` |
| `kubectl apply -f k8s/mongo-statefulset.yaml` | MongoDB StatefulSet + PVC | |
| `kubectl rollout status statefulset/mongo` | Wait for Mongo pod | |
| `kubectl get pvc` | Verify PVC bound | Should show `Bound` |
| `kubectl get pods -l app=mongo` | List Mongo pods | Should show `mongo-0` |
| `kubectl exec mongo-0 -- mongosh movies --quiet --eval "db.movies.countDocuments()"` | Count documents | Verifies persistence |
| `kubectl rollout restart deploy/movie-api` | Restart app after env change | Picks up new MONGO_URI |
| `kubectl logs deploy/movie-api --tail=80` | Verify connection logs | Check for MongoDB connected |

---

## Helm Basic Workflow (Step 05)

| Command | Purpose | Notes |
|---------|---------|-------|
| `helm lint movie-chart` | Validate chart | Fix before install |
| `helm template demo movie-chart` | Render templates locally | No cluster needed |
| `helm upgrade --install demo movie-chart` | Install/upgrade release | Idempotent |
| `helm list` | List installed releases | |
| `kubectl get all -l "app.kubernetes.io/instance=demo"` | K8s objects for release | |
| `helm upgrade demo movie-chart --set replicaCount=3` | Scale via values override | |
| `kubectl get pods` | Verify 3 replicas | |
| `helm upgrade demo movie-chart -f movie-chart/values-prod.yaml` | Apply prod values | |
| `helm history demo` | Show release history | Revision list |
| `helm rollback demo 1` | Roll back to revision 1 | |
| `helm uninstall demo` | Remove release + K8s objects | |

---

## Helm MongoDB Dependency (Step 06)

| Command | Purpose | Notes |
|---------|---------|-------|
| `helm repo add bitnami https://charts.bitnami.com/bitnami` | Add Bitnami repo | One-time setup |
| `helm repo update` | Update repo index | |
| `helm dependency update movie-chart` | Pull subchart tarballs | Creates `charts/` + `Chart.lock` |
| `helm lint movie-chart` | Validate after dep update | |
| `helm template demo movie-chart` | Render full manifest including subchart | Large output |
| `helm upgrade --install demo movie-chart` | Install with Bitnami MongoDB | |
| `kubectl rollout status statefulset/demo-mongodb` | Wait for MongoDB pod | Named by release |
| `kubectl rollout status deploy/demo-movie-api` | Wait for app pod | |
| `kubectl logs deploy/demo-movie-api --tail=80` | Check app connected to Mongo | |
| `helm history demo` | Verify revision | |
| `helm rollback demo 1` | Roll back | |
| `helm uninstall demo` | Remove everything | PVCs may remain |

---

## Cleanup Commands

| Command | Purpose | Notes |
|---------|---------|-------|
| `kubectl delete deploy movie-api --ignore-not-found=true` | Remove app Deployment | |
| `kubectl delete statefulset mongo --ignore-not-found=true` | Remove Mongo StatefulSet | Do this before deleting Pod |
| `kubectl delete pod mongo-0 --grace-period=0 --force --ignore-not-found=true` | Force-delete stuck Pod | Required if StatefulSet deleted first |
| `kubectl delete svc movie-api mongo --ignore-not-found=true` | Remove Services | |
| `kubectl delete cm movie-api-config --ignore-not-found=true` | Remove ConfigMap | |
| `kubectl delete secret movie-api-secret --ignore-not-found=true` | Remove Secret | |
| `kubectl delete pvc -l app=mongo --ignore-not-found=true` | Remove PVCs | PVCs do not auto-delete with StatefulSet |
| `kubectl get all` | Verify clean state | Only unrelated resources should remain |
| `helm uninstall demo` | Clean up Helm release | Removes all managed K8s objects |
| `kubectl delete pvc -l app.kubernetes.io/instance=demo` | Remove Helm-managed PVCs | Not removed by `helm uninstall` |
