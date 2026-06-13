# Hands-On 7.0 - Labels and Selectors

> **Status**: done
> **Environment**: Minikube (Windows), kubectl

---

## Goal

Learn how Kubernetes Labels work, how to display them on `kubectl get pods`, and how to filter Pods using Equality-based and Set-based selectors.

---

## Files

```
.
├── color-api.yaml              # Two Pods with labels: app, environment, tier
├── outputs/                    # Terminal outputs from the lab
│   ├── 01-apply.txt
│   ├── 02-pods-wide.txt
│   ├── 03-label-columns.txt
│   ├── 04-selector-app-color-api.txt
│   ├── 05-selector-tier-frontend.txt
│   ├── 06-selector-and-single-flag.txt
│   ├── 07-selector-and-multiple-flags.txt
│   ├── 08-selector-set-in.txt
│   ├── 09-selector-set-notin.txt
│   ├── 10-selector-multiple-flags-reversed.txt
│   ├── 11-correct-and-show-labels.txt
│   ├── 12-lab-conclusion.txt
│   ├── 13-final-lab-state.txt
│   ├── 14-final-and-proof.txt
│   └── 15-files-created.txt
└── images/
    └── README.md               # Planned screenshots list
```

---

## Labels Created

Two Pods were defined in `color-api.yaml`:

| Pod | `app` | `environment` | `tier` |
|-----|-------|---------------|--------|
| `color-backend` | `color-api` | `local` | `backend` |
| `color-frontend` | `color-api` | `local` | `frontend` |

---

## Commands Used

### Apply manifest

```bash
kubectl apply -f color-api.yaml
```

Output:
```
pod/color-backend created
pod/color-frontend created
```

### Show Pods with specific label columns

```bash
kubectl get pods -L app,tier
```

Shows `APP` and `TIER` as extra columns. Pods without a label show an empty cell — useful for spotting unlabeled resources.

### Show all labels on a Pod

```bash
kubectl get pods color-frontend --show-labels
```

Output:
```
NAME             READY   STATUS    RESTARTS   AGE    LABELS
color-frontend   1/1     Running   0          104s   app=color-api,environment=local,tier=frontend
```

---

## Equality Selectors Tested

| Command | Result |
|---------|--------|
| `kubectl get pods -l 'app=color-api'` | Returns both Pods |
| `kubectl get pods -l 'tier=frontend'` | Returns `color-frontend` only |
| `kubectl get pods -l 'app=color-api,tier=frontend'` | Returns `color-frontend` (AND logic) |

---

## Set-Based Selectors Tested

| Command | Result |
|---------|--------|
| `kubectl get pods -l 'tier in (frontend)'` | Returns `color-frontend` only |
| `kubectl get pods -l 'tier notin (frontend)'` | Returns `color-backend` + all Pods without the `tier` label |

---

## Observed Behavior

### `notin` includes Pods without the label

When using `tier notin (frontend)`, Kubernetes returns:
- Pods where `tier` is not `frontend` (e.g., `color-backend` with `tier=backend`)
- **Also: Pods that have no `tier` label at all** (`demo-statefulset-*`, `empty-dir-demo`, `movie-api-*`)

This is expected behavior. `notin` does not mean "has the label but it's not X". It means "does not satisfy X" — which includes having no label.

### Multiple `-l` flags behaved inconsistently

Attempts to use multiple `-l` flags to express AND logic:

```bash
kubectl get pods -l 'app=color-api' -l 'tier=frontend'
```

Did not reliably behave as AND in this environment — the second flag sometimes appeared to override the first (outputs `07` and `10` show different results depending on flag order).

**Reliable AND syntax** — use a single `-l` flag with comma-separated conditions:

```bash
kubectl get pods -l 'app=color-api,tier=frontend'
```

This consistently returned only `color-frontend`.

---

## Final Proof

```
NAME             READY   STATUS    RESTARTS   AGE     IP             NODE       APP         TIER
color-backend    1/1     Running   0          2m35s   10.244.0.193   minikube   color-api   backend
color-frontend   1/1     Running   0          2m34s   10.244.0.194   minikube   color-api   frontend
```

Both Pods running, labels visible as columns, selectors filtering correctly.

---

## Screenshot Plan

See `images/README.md`:

```
00-lab-files.png
01-pods-created.png
02-label-columns.png
03-equality-selector.png
04-set-based-selector.png
```

---

## Conclusion

| Tested | Result |
|--------|--------|
| Label display with `-L` | Shows label values as columns on `kubectl get pods` |
| Equality selector (`=`) | Filters to exact match |
| AND with comma in single `-l` | Reliable: `kubectl get pods -l 'app=color-api,tier=frontend'` |
| AND with multiple `-l` flags | Inconsistent in this environment — avoid |
| Set-based `in` | Works: returns only matching value |
| Set-based `notin` | Works: also returns Pods with no label at all |

Labels are the foundation of Kubernetes routing — Services, Deployments, and ReplicaSets all use label selectors to find their Pods.
