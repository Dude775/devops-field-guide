# Module 4 - Object Management & YAML Manifests

> **Date**: 2026-06-04
> **Module**: 09 - Kubernetes
> **Status**: Theoretical - Labs TODO

---

## 3 Approaches to Managing K8s Objects

| Approach | How | Idempotent? | Use in Prod? |
|----------|-----|-------------|--------------|
| **Imperative kubectl** | `kubectl run nginx --image=nginx` | No | Never |
| **Imperative with config file** | `kubectl create -f pod.yaml` / `kubectl replace -f pod.yaml` | No | No |
| **Declarative** | `kubectl apply -f pod.yaml` | Yes | Always |

The imperative approach is great for learning and quick debugging. The declarative approach is what you actually use.

---

## Manifest Structure

Every K8s manifest has these 4 top-level fields:

```yaml
apiVersion: v1          # which API group + version handles this object
kind: Pod               # what type of object
metadata:               # name, namespace, labels, annotations
  name: my-pod
spec:                   # the desired state - what you want
  containers:
    - name: nginx
      image: nginx:1.27.0
```

**apiVersion quick reference:**

| Object | apiVersion |
|--------|-----------|
| Pod | `v1` |
| Service | `v1` |
| Namespace | `v1` |
| ConfigMap | `v1` |
| ReplicaSet | `apps/v1` |
| Deployment | `apps/v1` |
| DaemonSet | `apps/v1` |
| Ingress | `networking.k8s.io/v1` |

Common mistake: writing `apiVersion: v1` for a ReplicaSet. You get: `no matches for kind "ReplicaSet" in version "v1"`.

---

## kubectl apply vs create vs replace

### `kubectl create -f file.yaml`
- Creates the object if it doesn't exist
- Fails with error if it already exists
- Does NOT track what you applied

### `kubectl replace -f file.yaml`
- Replaces the object - full spec overwrite
- Fails if object doesn't exist
- Fails on managed fields (Forbidden errors from the API server)
- Not idempotent

### `kubectl apply -f file.yaml`
- Creates if missing, updates if exists
- Stores a snapshot in `kubectl.kubernetes.io/last-applied-configuration` annotation
- Uses 3-way merge: last-applied + live state + new config
- Idempotent - safe to run multiple times

---

## The 3-Way Merge Explained

When you run `kubectl apply`, Kubernetes does:

```
last-applied-configuration (what you told it last time)
    +
live state (what's actually running, including K8s-managed fields)
    +
new config (what you're telling it now)
    =
merged result
```

This is why `kubectl replace` breaks after `kubectl apply` - replace doesn't know about managed fields and tries to overwrite them. You get Forbidden errors.

The annotation lives here:
```
metadata.annotations.kubectl.kubernetes.io/last-applied-configuration
```

Run `kubectl get pod <name> -o yaml` and you'll see it - your original YAML embedded as a JSON string.

---

## --dry-run=client Workflow

Never write manifests from scratch. Generate them:

```bash
# Pod manifest
kubectl run nginx --image=nginx:1.27.0 --dry-run=client -o yaml > pod.yaml

# Service manifest
kubectl expose pod nginx --port=80 --dry-run=client -o yaml > svc.yaml

# Deployment manifest
kubectl create deployment nginx-deploy --image=nginx:1.27.0 --dry-run=client -o yaml > deploy.yaml
```

`--dry-run=client` - simulates the command locally, nothing hits the API server
`-o yaml` - outputs the result as YAML instead of running it

Then edit the generated file and apply. Much faster than hand-writing.

---

## kubectl diff

Before applying changes, preview what will change:

```bash
kubectl diff -f pod.yaml
```

Output looks like git diff - lines with `-` are current state, `+` are incoming changes. Useful before running apply on a changed file.

---

## Multiple Objects in One File

Separate with `---`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx:1.27.0
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
    - port: 80
```

`kubectl apply -f` processes both. Useful for keeping related objects together (Pod + its Service).

Also works on directories:
```bash
kubectl apply -f ./manifests/
```

Applies all `.yaml` files in the folder. Good for environments.

---

## Full State vs Your YAML

Your YAML is a subset of what K8s stores:

```bash
kubectl get pod nginx -o yaml
```

This returns the full object - includes everything you wrote PLUS fields K8s added:
- `resourceVersion`
- `uid`
- `creationTimestamp`
- `status` block
- `last-applied-configuration` annotation
- Default values K8s filled in

Your manifest is an input. The live object is the output. They're not the same thing.

---

## Folder Hygiene

```
manifests/
  nginx-pod.yaml        # active
  nginx-svc.yaml        # active
  archive/
    nginx-pod-v1.yaml   # old version, kept for reference
```

Active manifests in the main folder. Old versions in `archive/`. Don't clutter.

---

## Iron Rules

- Always use `kubectl apply` in production. Never `create` or `replace`.
- ReplicaSet/Deployment/DaemonSet need `apps/v1`. Pod/Service/Namespace use `v1`.
- Generate manifests with `--dry-run=client -o yaml`. Don't write from scratch.
- Active manifests in main folder, drafts in `archive/`.
- `kubectl get pod <name> -o yaml` shows the FULL state. Your YAML is just the input.
- Never run `kubectl apply` on a file you haven't read.

---

## Labs

| Lab | Topic | Status |
|-----|-------|--------|
| 4.1 | Pod + Service via YAML | TODO (skipped in class) |
| 4.2 | NodePort Service via YAML | TODO |
| 4.3 | Generate YAML with --dry-run | TODO |
| 4.4 | Limits of imperative with files | Covered theoretically |
| 4.5 | Declarative with apply | Covered theoretically |
| 4.6 | apply on directory | Covered theoretically |
| 4.7 | Multi-object YAML with --- | Covered theoretically |

---

## Key Commands

| Command | What it does |
|---------|-------------|
| `kubectl apply -f file.yaml` | Create or update - idempotent |
| `kubectl create -f file.yaml` | Create only - fails if exists |
| `kubectl replace -f file.yaml` | Full overwrite - breaks with managed fields |
| `kubectl delete -f file.yaml` | Delete the objects defined in file |
| `kubectl diff -f file.yaml` | Preview changes before applying |
| `kubectl apply -f ./folder/` | Apply all YAMLs in directory |
| `kubectl get pod <name> -o yaml` | Full live object spec |
| `kubectl run --dry-run=client -o yaml` | Generate pod manifest |
| `kubectl create deploy --dry-run=client -o yaml` | Generate deployment manifest |
