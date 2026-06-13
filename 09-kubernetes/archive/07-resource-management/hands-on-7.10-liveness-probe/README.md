# Hands-On 7.10 — Liveness Probe

## Goal

Test Liveness Probe behavior: verify that Kubernetes restarts a container when the liveness check fails.

## Image

`idf775/color-api:1.2.1`

> **Note:** The course text mentioned `/health` as the liveness endpoint. The actual endpoint in 1.2.1 is `/live`.

## Probe Config

```yaml
startupProbe:
  httpGet:
    path: /up
    port: 80
  failureThreshold: 2
  periodSeconds: 3
livenessProbe:
  httpGet:
    path: /live
    port: 80
  failureThreshold: 3
  periodSeconds: 10
```

## Scenarios

### Startup Probe Only (baseline)

- Applied pod with only Startup Probe
- Pod reached `Running` state successfully
- Deleted before liveness test

### Liveness Failure

- Applied pod with `FAIL_LIVENESS=true`
- `/live` returned HTTP 503
- After 3 failures × 10 second period, Kubernetes restarted the container
- Restart Count increased to 1
- `kubectl describe` showed: `Liveness probe failed`
- Events showed: container failed liveness probe, will be restarted

## Cleanup

```bash
kubectl delete -f color-api-pod.yaml
```

## Files

```
color-api-pod.yaml
outputs/
  01-clean-previous-color-api-pod.txt
  02-apply-startup-up.txt
  03-startup-up-running.txt
  04-startup-up-logs.txt
  05-delete-startup-only-pod.txt
  06-apply-liveness-fail.txt
  07-pod-after-liveness-fail.txt
  08-describe-liveness-fail.txt
  09-previous-container-logs.txt
  10-cleanup.txt
  11-pod-after-cleanup.txt
  12-lab-conclusion.txt
  13-final-files-created.txt
```

## Conclusion

Liveness Probe triggers container restarts (not Pod deletion) when health checks fail. The Pod stays alive; only the container is restarted. Restart Count is the evidence.
