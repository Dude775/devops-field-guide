# Module 5 - ReplicaSets

> **Date**: 2026-06-04
> **Module**: 09 - Kubernetes
> **Status**: Hands-On 5.0 + 5.1 Complete

---

## What is a ReplicaSet

A ReplicaSet's one job: make sure N copies of a Pod are always running.

It watches the cluster continuously. If a Pod dies, it creates a new one. If there are too many, it deletes one. The controller loop never stops.

**What it manages**: quantity of Pods  
**What it does NOT manage**: the content (image, config) of running Pods

---

## YAML Structure

```yaml
apiVersion: apps/v1      # NOT v1 - common mistake
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
spec:
  replicas: 3            # desired count
  selector:
    matchLabels:
      app: nginx         # must match template labels exactly
  template:
    metadata:
      labels:
        app: nginx       # must match selector above
    spec:
      containers:
        - name: nginx
          image: nginx:1.27.0
          ports:
            - containerPort: 80
```

**Critical**: `selector.matchLabels` and `template.metadata.labels` must be identical.  
If they don't match, the RS creates Pods it can't find, loops forever creating more.

**No `name` field in template** - the RS appends a random 5-char suffix.  
Result: `nginx-replicaset-hm4tp`, `nginx-replicaset-z4hsn`, etc.

---

## Hands-On 5.0 - Self-Healing Demo (COMPLETED)

Applied `nginx-replicaset.yaml` with 3 replicas.

```powershell
kubectl apply -f nginx-replicaset.yaml
kubectl get rs
```

Output:
```
NAME               DESIRED   CURRENT   READY   AGE
nginx-replicaset   3         3         3       63s
```

**Self-healing test:**

```powershell
kubectl delete pod nginx-replicaset-hm4tp
kubectl get pods -w
```

Within 1-2 seconds, a new Pod appeared:
```
NAME                     READY   STATUS    RESTARTS   AGE
nginx-replicaset-z4hsn   1/1     Running   0          17s   # new
nginx-replicaset-kbx92   1/1     Running   0          63s
nginx-replicaset-9tprd   1/1     Running   0          63s
```

The 17s vs 63s AGE difference confirms it was freshly created. The RS noticed the count dropped to 2, created `z4hsn` immediately.

> Screenshot: `../resources/images/00-replicaset-self-healing.png`

---

## Hands-On 5.1 - The Limitation (COMPLETED)

Changed image in YAML from `nginx:1.27.0` to `nginx:1.27.0-alpine`.

```powershell
kubectl apply -f nginx-replicaset.yaml
# replicaset.apps/nginx-replicaset configured
```

Applied successfully. Now check what's actually running:

```powershell
kubectl describe pod nginx-replicaset-kbx92
```

Output shows:
```
Image:         nginx:1.27.0
...
Events:
  Container image "nginx:1.27.0" already present on machine
```

Still running the old image. The RS accepted the new spec but didn't restart the Pods.

**Why**: The RS only checks whether the Pod count matches the selector. The running Pod `kbx92` still has label `app: nginx` - it matches. Count is 3. RS considers this "desired state achieved." It doesn't look inside the Pod.

To get the new image, you'd have to manually delete each Pod one by one and let the RS recreate them. At 50 pods, that's a terrible workflow.

> Screenshot: `../resources/images/01-replicaset-image-not-updated.png`

**This is why Deployments exist.**

---

## Commands Covered

```bash
# list ReplicaSets
kubectl get rs

# detailed view with Events
kubectl describe rs <name>

# manual scaling
kubectl scale rs <name> --replicas=N

# remove RS and all owned Pods
kubectl delete rs <name>

# watch Pod changes in real time
kubectl get pods -w

# show IP + Node columns
kubectl get pods -o wide

# show labels
kubectl get pods --show-labels

# container logs (no 'get' prefix)
kubectl logs <pod-name>

# interactive shell into container
kubectl exec -it <pod-name> -- sh
```

---

## Iron Rules

- Never create ReplicaSets directly in production. Use Deployments.
- ReplicaSet manages quantity, not content. It won't update running Pods when the template changes.
- `selector.matchLabels` must match `template.metadata.labels` exactly. No exceptions.
- Pod template has no `name` field. RS generates the suffix automatically.
- `apiVersion: apps/v1` - NOT `v1`. The error `no matches for kind "ReplicaSet"` means you used `v1`.

---

## Why We Need Deployments

| Problem | ReplicaSet behavior |
|---------|---------------------|
| Update image | Pods keep old image until manually deleted |
| Rollback bad deploy | No history, no rollback mechanism |
| Zero-downtime update | You'd have to script it yourself |
| Track change history | No native support |

A Deployment wraps the ReplicaSet and solves all of these. The RS still does the actual Pod management - the Deployment just orchestrates RS versions.

Next: [Module 6 - Deployments](./06-deployments-intro.md)
