# Hands-On 7.6 - ResourceQuota: Rolling Updates and Scaling

## Goal

Observe how ResourceQuota blocks Rolling Updates and Scaling when the namespace quota is at capacity, diagnose the quota error through ReplicaSet events, and fix it by expanding the quota.

---

## Files

| File | Purpose |
|------|---------|
| `dev-ns.yaml` | Creates the `dev` Namespace |
| `dev-quota.yaml` | ResourceQuota (initially tight, expanded during lab) |
| `color-api-deployment.yaml` | Deployment with 4 replicas and resource constraints |
| `outputs/` | Terminal captures from each step |

---

## Initial Deployment

```yaml
replicas: 4
image: lironefitoussi/color-api:1.1.0
resources:
  requests:
    cpu: "200m"
    memory: 256Mi
  limits:
    cpu: "500m"
    memory: 512Mi
```

Initial quota (before expansion):

| Resource | Hard |
|----------|------|
| requests.cpu | 1 |
| requests.memory | 1Gi |
| limits.cpu | 2 |
| limits.memory | 2Gi |

4 replicas × 500m = 2000m CPU limits (exactly at the 2 limit).  
4 replicas × 512Mi = 2Gi memory limits (exactly at the 2Gi limit).

---

## Steps

### 1. Apply initial state

```bash
kubectl apply -f .
```

Output: `outputs/01-apply-initial.txt`

Namespace, quota, and deployment all created.

---

### 2. Verify 4 Pods running

```bash
kubectl get pods -n dev
```

Output: `outputs/02-pods-initial.txt`

> Real observation: `lironefitoussi/color-api:1.1.0` (the image in the YAML after the update) showed `ImagePullBackOff` in this environment. The quota behavior was still proven through ReplicaSet events rather than live Pod traffic.

---

### 3. Check initial quota usage

```bash
kubectl describe resourcequota dev-quota -n dev
```

Output: `outputs/03-quota-initial.txt`

Quota was at or near full: limits.cpu 2/2, limits.memory 2Gi/2Gi.

---

### 4. Trigger Rolling Update

```bash
kubectl set image deployment/color-api-deployment color-api=lironefitoussi/color-api:1.0.0 -n dev
kubectl apply -f .
```

Output: `outputs/05-image-updated.txt`, `outputs/06-apply-rolling-update.txt`

Kubernetes tried to create a new ReplicaSet with the updated image. A Rolling Update needs at least one new Pod before removing an old one — but the namespace was at full quota.

---

### 5. Rollout got stuck

```bash
kubectl rollout status deployment/color-api-deployment -n dev
```

Output: `outputs/08-rollout-status-timeout.txt`

Rollout did not progress. Timed out.

---

### 6. Diagnose with ReplicaSet events

```bash
kubectl get replicasets -n dev
kubectl describe replicaset -n dev
```

Output: `outputs/09-replicasets-after-update.txt`, `outputs/10-describe-replicasets.txt`

The new ReplicaSet showed `FailedCreate` events with the message:

```
exceeded quota: dev-quota, ...
```

The Deployment controller could not create a single new Pod because the namespace was at full quota. Rolling Update was blocked.

---

### 7. Fix: expand the quota

Updated `dev-quota.yaml` to:

| Resource | Hard (expanded) |
|----------|----------------|
| requests.cpu | 2 |
| requests.memory | 2Gi |
| limits.cpu | 4 |
| limits.memory | 4Gi |

```bash
kubectl apply -f dev-quota.yaml
```

Output: `outputs/14-apply-expanded-quota.txt`, `outputs/15-quota-expanded.txt`

---

### 8. Restart rollout after quota fix

```bash
kubectl rollout restart deployment/color-api-deployment -n dev
kubectl rollout status deployment/color-api-deployment -n dev
```

Output: `outputs/16-rollout-restart.txt`, `outputs/17-rollout-status-after-quota-fix.txt`

Rollout completed successfully after quota was expanded.

---

### 9. Attempt to scale to 10 replicas

```bash
kubectl scale deployment color-api-deployment --replicas=10 -n dev
kubectl get pods -n dev
```

Output: `outputs/20-scale-to-10.txt`

The Deployment accepted the scale command, but quota blocked new Pods beyond what the expanded quota allowed.

Output: `outputs/22-scale-quota-error-proof.txt`

ReplicaSet events again showed `FailedCreate` / `exceeded quota` — same pattern as during the Rolling Update.

---

### 10. Cleanup

```bash
kubectl delete -f .
```

Output: `outputs/24-cleanup.txt`, `outputs/25-dev-namespace-after-cleanup.txt`, `outputs/26-pods-after-cleanup.txt`

All resources including the `dev` Namespace were removed.

---

## Key Concepts

- Rolling Update requires headroom above the current replica count to create new Pods temporarily.
- A full quota blocks Rolling Updates entirely — the rollout stalls and never progresses.
- `kubectl describe replicaset` shows the `FailedCreate` events with the quota error — this is the correct place to diagnose stuck rollouts.
- Scaling beyond quota is silently accepted by the Deployment controller but Pods are never created — ReplicaSet events reveal the real error.
- Expanding a quota unblocks stuck rollouts immediately.

---

## Real Observation

The `lironefitoussi/color-api:1.0.0` image showed `ImagePullBackOff` in this environment. The quota blocking behavior was still fully demonstrated through ReplicaSet events, quota describe output, and rollout status — all of which accurately reflected the enforcement without requiring live Pod traffic.

---

## Conclusion

ResourceQuota does not just block new deployments — it blocks Rolling Updates and scaling attempts when the namespace is at capacity. Always size quotas with enough headroom for the Rolling Update surge (typically one extra replica worth of resources). Use `kubectl describe replicaset` to diagnose stuck rollouts when `kubectl rollout status` times out.
