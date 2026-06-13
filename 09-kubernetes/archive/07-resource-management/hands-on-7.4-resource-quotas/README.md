# Hands-On 7.4 - ResourceQuotas

## Goal

Create ResourceQuota objects for two namespaces (`dev` and `prod`) with different limits, and verify quota reporting before any workloads consume resources.

---

## Files

| File | Purpose |
|------|---------|
| `dev-ns.yaml` | Creates the `dev` Namespace |
| `prod-ns.yaml` | Creates the `prod` Namespace |
| `dev-quota.yaml` | ResourceQuota for dev (smaller limits) |
| `prod-quota.yaml` | ResourceQuota for prod (larger limits) |
| `outputs/` | Terminal captures from each step |

---

## Quota Values

### dev-quota

| Resource | Hard Limit |
|----------|-----------|
| requests.cpu | 1 |
| requests.memory | 1Gi |
| limits.cpu | 2 |
| limits.memory | 2Gi |

### prod-quota

| Resource | Hard Limit |
|----------|-----------|
| requests.cpu | 2 |
| requests.memory | 2Gi |
| limits.cpu | 4 |
| limits.memory | 4Gi |

---

## Steps

### 1. Apply all manifests

```bash
kubectl apply -f .
```

Output: `outputs/01-apply-all.txt`

Creates both namespaces and both ResourceQuota objects in a single apply.

---

### 2. Verify namespaces exist

```bash
kubectl get namespaces
```

Output: `outputs/02-namespaces.txt`

Both `dev` and `prod` appeared alongside the system namespaces.

---

### 3. Check ResourceQuotas across all namespaces

```bash
kubectl get resourcequota -A
```

Output: `outputs/03-resourcequotas-all.txt`

Both `dev-quota` and `prod-quota` were listed. `Used` column showed `0` for all resources because no workloads had been deployed yet.

---

### 4. Describe each quota

```bash
kubectl describe resourcequota dev-quota -n dev
kubectl describe resourcequota prod-quota -n prod
```

Output: `outputs/04-describe-dev-quota.txt`, `outputs/05-describe-prod-quota.txt`

`describe` shows the `Resource / Used / Hard` table clearly. With no Pods, Used=0 across the board.

---

### 5. No cleanup

The namespaces and quotas were intentionally left in place. The next lab (7.5) deploys Pods into `dev` to test quota enforcement.

---

## Key Concepts

- A ResourceQuota object is scoped to a single Namespace.
- Once a quota exists, every Pod in that namespace must declare `resources.requests` and `resources.limits`. Pods without requests/limits are rejected.
- `Used` stays at 0 until workloads are running.
- `dev` gets smaller quotas than `prod` — this reflects a real pattern where dev environments are intentionally constrained.

---

## Conclusion

ResourceQuota objects are lightweight to create and immediately enforce limits on namespace resource consumption. The quota shows up in `kubectl describe` even before any Pods exist, making it easy to verify the configuration before deploying workloads.
