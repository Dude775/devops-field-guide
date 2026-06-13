# Hands-On 7.5 - ResourceQuota: Pods with Requests and Limits

## Goal

Prove that ResourceQuota enforcement is real: deploy a Pod that fits within the quota, then attempt to deploy one that exceeds it and observe the Forbidden error from the Kubernetes API Server.

---

## Files

| File | Purpose |
|------|---------|
| `api-pod.yaml` | color-api Pod with resource requests and limits that fit within dev-quota |
| `outputs/` | Terminal captures from each step |

> `heavy-api-pod.yaml` is not present. It was intentionally removed after the forbidden test to avoid accidental recreation on future `kubectl apply -f .` runs. The forbidden error is captured in `outputs/06-apply-heavy-forbidden.txt`.

---

## Pod Resources (api-pod.yaml)

```yaml
resources:
  requests:
    cpu: "200m"
    memory: 256Mi
  limits:
    cpu: "500m"
    memory: 512Mi
```

---

## Steps

### 1. Check dev quota before deploying

```bash
kubectl describe resourcequota dev-quota -n dev
```

Output: `outputs/01-check-dev-quota.txt`

All resources at Used=0. Dev quota limits: requests.cpu=1, requests.memory=1Gi, limits.cpu=2, limits.memory=2Gi.

---

### 2. Deploy color-api Pod

```bash
kubectl apply -f api-pod.yaml
```

Output: `outputs/02-apply-api-pod.txt`

Pod was created. The declared requests and limits fit within the quota.

---

### 3. Verify Pod is running

```bash
kubectl get pods -n dev
kubectl describe pod color-api -n dev
```

Output: `outputs/03-pods-dev-after-api.txt`, `outputs/04-describe-api-pod.txt`

Pod status: Running. Describe confirmed the resource declarations were accepted.

---

### 4. Quota after color-api Pod

```bash
kubectl describe resourcequota dev-quota -n dev
```

Output: `outputs/05-quota-after-api-pod.txt`

```
Resource         Used   Hard
--------         ----   ----
limits.cpu       500m   2
limits.memory    512Mi  2Gi
requests.cpu     200m   1
requests.memory  256Mi  1Gi
```

Used increased to reflect the running Pod's declared resources.

---

### 5. Attempt to deploy heavy-api (exceeds quota)

The heavy-api Pod requested resources that would push the namespace over quota:
- requests.cpu: 1, requests.memory: 1Gi
- limits.cpu: 2, limits.memory: 2Gi

```bash
kubectl apply -f heavy-api-pod.yaml
```

Output: `outputs/06-apply-heavy-forbidden.txt`

```
Error from server (Forbidden): error when creating "heavy-api-pod.yaml":
pods "heavy-api" is forbidden: exceeded quota: dev-quota,
requested: limits.cpu=2,limits.memory=2Gi,requests.cpu=1,requests.memory=1Gi,
used: limits.cpu=500m,limits.memory=512Mi,requests.cpu=200m,requests.memory=256Mi,
limited: limits.cpu=2,limits.memory=2Gi,requests.cpu=1,requests.memory=1Gi
```

The API Server rejected the Pod before it was scheduled. No Pod object was created.

---

### 6. Verify heavy-api Pod was never created

```bash
kubectl get pods -n dev
```

Output: `outputs/07-pods-dev-after-heavy-attempt.txt`

Only `color-api` appeared. `heavy-api` did not exist.

---

### 7. Cleanup

```bash
kubectl delete pod color-api -n dev
```

Output: `outputs/08-cleanup.txt`, `outputs/09-pods-dev-after-cleanup.txt`, `outputs/10-quota-after-cleanup.txt`

After deletion, quota Used dropped back to 0. The `heavy-api-pod.yaml` file was also deleted from the working directory to prevent accidental future applies.

---

## Key Concept

ResourceQuota enforcement happens at creation time, not at scheduling time. The API Server checks the quota before accepting the object. If the request would exceed the hard limit, the API Server returns 403 Forbidden immediately and the Pod is never created.

---

## Conclusion

With a quota in place, Pod definitions must declare requests and limits, and the declared values must fit within what remains of the namespace quota. The error message from the API Server is precise: it shows what was requested, what was already used, and what the hard limit is — making it easy to diagnose.
