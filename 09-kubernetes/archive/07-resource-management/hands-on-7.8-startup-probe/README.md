# Hands-On 7.8 — Startup Probe

## Goal

Test Startup Probe behavior: successful startup, startup failure leading to CrashLoopBackOff, and recovery.

## Image

`idf775/color-api:1.2.0`

> **Note:** The course text mentioned `/health` as the probe endpoint. The actual implemented endpoint in 1.2.0 is `/live`. The pod YAML uses `/live`.

## Startup Probe Config

```yaml
startupProbe:
  httpGet:
    path: /live
    port: 80
  failureThreshold: 2
  periodSeconds: 3
```

## Scenarios

### Successful Case

- `DELAY_STARTUP` not set (defaults false)
- Pod reached `Running` state
- Logs showed normal startup

### Failure Case

- `DELAY_STARTUP=true`
- App blocked the event loop for 60 seconds before `app.listen()`
- Probe hit connection refused (port not open yet)
- After 2 failures × 3 second period = 6 seconds, Kubernetes marked startup as failed
- Pod reached `CrashLoopBackOff`
- Restart Count increased

### Fixed Case

- `DELAY_STARTUP=false`
- Pod returned to `Running` state

## Cleanup

No final cleanup was performed — the lab ended with the Pod in a healthy Running state.

## Files

```
color-api-pod.yaml
outputs/
  01-apply-good-pod.txt
  02-good-pod-running.txt
  03-good-pod-logs.txt
  04-delete-good-pod.txt
  05-apply-broken-startup.txt
  06-pod-after-startup-fail.txt
  07-describe-startup-fail.txt
  08-delete-broken-pod.txt
  09-apply-fixed-pod.txt
  10-fixed-pod-running.txt
  11-fixed-pod-logs.txt
  12-lab-conclusion.txt
  13-final-files-created.txt
```

## Conclusion

Startup Probe prevents liveness/readiness checks from running until the app is ready to serve. When startup blocks (DELAY_STARTUP=true), the probe fails fast and Kubernetes cycles the container.
