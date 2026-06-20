# Troubleshooting Log — Helm Small Project Lab

אירועים אמיתיים שקרו במהלך הלאב. לא מסמך תיאורטי — אלה הדברים שעצרו את ההתקדמות בפועל.

---

## 1. PowerShell Commands Failed in Git Bash

**Symptom**

Preflight inventory script ran PowerShell cmdlets inside Git Bash. Commands like `Get-ChildItem`, `docker ps --format`, and `helm list` either errored or produced no output.

**Root cause**

Git Bash is a POSIX shell. PowerShell cmdlets only work in `pwsh` / `powershell.exe`. Mixing them in the same script causes silent failures.

**Fix**

Rewrote the inventory script as a pure Bash script:

```bash
#!/bin/bash
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
kubectl get nodes 2>/dev/null || echo "cluster not reachable"
helm list 2>/dev/null || echo "no helm releases"
```

**Lesson learned**

Before writing any script, decide which shell it runs in. Bash for Git Bash / WSL / Linux. PowerShell for Windows-native. Never mix in the same file.

---

## 2. Minikube Stopped — Cluster Unreachable

**Symptom**

```
E0620 ... dial tcp 127.0.0.1:8443: connect: connection refused
```

Both `kubectl` and `helm` returned this error. Docker Desktop was running but Minikube container was not.

**Root cause**

Minikube was stopped (machine restart or explicit `minikube stop`). The local `~/.kube/config` still pointed to the Minikube API server, but it was not listening.

**Fix**

```bash
docker ps | grep minikube      # confirmed container was missing
minikube start --driver=docker
kubectl get nodes              # now returns Ready
```

**Lesson learned**

`connection refused` on the API server almost always means the cluster is not running. Check `docker ps` before debugging kubectl. Add `minikube status` to every preflight script.

---

## 3. MongoDB Container Had No Host Port

**Symptom**

The local Python app could not connect to MongoDB on `localhost:27017`. Container existed and was running but `curl localhost:27017` refused.

**Root cause**

The existing `mongo` container was started without the `-p 27017:27017` flag. The container was accessible only from inside Docker network, not from the host.

**Fix**

```bash
docker rename mongo mongo-old       # keep old container for safety
docker run -d --name mongo \
  --network movie-net \
  -p 27017:27017 \
  mongo:6
docker rm mongo-old                 # clean up after confirming new one works
```

**Lesson learned**

Always add `-p <host>:<container>` when a host-side client (the Python app running in a venv) needs to reach the container. Port mapping is not inherited from images.

---

## 4. Python 3.7 venv Caused FastAPI Install Failure

**Symptom**

```
ERROR: Could not find a version that satisfies the requirement fastapi>=0.115.0
```

`pip` was version 19, and Python 3.7 could not resolve modern FastAPI dependencies.

**Root cause**

The `python` binary on the system path was Python 3.7 (old OS default). Running `python -m venv .venv` created a venv with that old interpreter. FastAPI 0.115+ requires Python 3.8+.

**Fix**

```bash
rm -rf .venv
python3.12 -m venv .venv         # explicitly target Python 3.12
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt  # now works
```

**Lesson learned**

Always check `python --version` before creating a venv. Use `python3.12` (or whichever version is required) explicitly. Never assume `python` == `python3` == the version you want.

---

## 5. Docker Push Denied — Wrong Namespace

**Symptom**

```
denied: requested access to the resource is denied
```

Push failed when targeting `dude775/movie-api:1.0`.

**Root cause**

Two issues combined:
1. The image was built with the wrong Docker Hub username (`dude775` instead of `idf775`).
2. Not logged in to Docker Hub in the current terminal session.

**Fix**

```bash
docker login                                    # enter idf775 credentials
docker tag dude775/movie-api:1.0 idf775/movie-api:1.0
docker push idf775/movie-api:1.0
```

**Lesson learned**

Set the correct namespace from the first `docker build` command. Docker Hub username is case-sensitive and must match the account. Run `docker login` before the first push in every new session.

---

## 6. Helm Dependency with Bitnami MongoDB — Auth and Image Issues

**Symptom**

After `helm upgrade --install demo movie-chart`, the MongoDB pod was in `CrashLoopBackOff`. Logs showed authentication failures and image pull issues with the default Bitnami MongoDB chart settings.

**Root cause**

The Bitnami MongoDB chart defaults changed between versions. The chart required explicit `auth.rootPassword`, the image reference needed legacy compatibility settings, and Kubernetes rejected the image pull due to security policy on Minikube.

**Fix**

Added to `values.yaml`:

```yaml
mongodb:
  enabled: true
  auth:
    rootPassword: "secretpass"
  persistence:
    size: 8Gi
  image:
    tag: "6.0.14-debian-11-r0"
  securityContext:
    enabled: false
  containerSecurityContext:
    enabled: false
```

Updated `secret.yaml` template to use:

```
mongodb://root:secretpass@{{ .Release.Name }}-mongodb:27017/movies?authSource=admin
```

**Lesson learned**

When using a subchart, read its `values.yaml` before writing your own overrides. The service name is `{{ .Release.Name }}-<chart-name>`, not a fixed name. Auth changes between subchart versions — pin the chart version in `Chart.yaml`.

---

## 7. Mongo PVC Stuck Terminating After StatefulSet Deletion

**Symptom**

```
kubectl delete namespace default   # or kubectl delete pvc
# PVC stayed in Terminating state indefinitely
```

After `helm uninstall demo` or manual `kubectl delete statefulset mongo`, the PVC would not delete.

**Root cause**

PVCs attached to a StatefulSet are not automatically deleted when the StatefulSet or Helm release is removed. A Pod still holding the volume prevents the PVC from terminating. Deleting the StatefulSet leaves `mongo-0` Pod alive until it is explicitly deleted.

**Fix — correct order of operations:**

```bash
# 1. Delete the StatefulSet first
kubectl delete statefulset mongo --ignore-not-found=true

# 2. Force-delete the stuck Pod
kubectl delete pod mongo-0 --grace-period=0 --force --ignore-not-found=true

# 3. Delete services
kubectl delete svc mongo movie-api --ignore-not-found=true

# 4. Now delete the PVC (volume is no longer held)
kubectl delete pvc -l app=mongo --ignore-not-found=true

# 5. Verify
kubectl get all
kubectl get pvc
```

**Lesson learned**

PVCs from StatefulSets survive `helm uninstall` by design — Helm does not own PVCs created by StatefulSet volumeClaimTemplates. Always explicitly delete PVCs after tearing down a StatefulSet. The correct deletion order is: StatefulSet → Pod → Service → PVC.
