# Hands-On 7.11 — Readiness Probe & Service Traffic

## Goal

Test Readiness Probe behavior with a Deployment, Service, and Traffic Generator: verify that only Ready pods receive traffic, and unready pods are excluded from Service endpoints without being restarted.

## Image

`idf775/color-api:1.2.1`

## Resources Created

- Deployment: 6 replicas
- Service: `color-api-svc`
- Traffic Generator Pod: `lironefitoussi/traffic-generator:1.0.0`

## Probe Config

```yaml
startupProbe:
  httpGet:
    path: /up
    port: 80
  failureThreshold: 2
  periodSeconds: 3
readinessProbe:
  httpGet:
    path: /ready
    port: 80
  failureThreshold: 2
  periodSeconds: 5
```

## Env

```yaml
env:
  - name: FAIL_READINESS
    value: "true"
```

`FAIL_READINESS=true` causes `/ready` to return 503 on a random ~50% of pods.

## Implementation Note

The Service selector used `lab: readiness-probe` in addition to `app: color-api` to isolate traffic from older color-api Pods still running in the default namespace from previous labs.

```yaml
selector:
  app: color-api
  lab: readiness-probe
```

## Observed Behavior

### Pods

- 6 color-api Pods created
- 2 Ready
- 4 Running but Not Ready
- Restart Count stayed at 0 for all Pods

### Service Endpoints

Only Ready Pod IPs were added to the Service endpoint list:

```
10.244.0.231:80
10.244.0.233:80
```

### Traffic Proof

Traffic Generator logs showed traffic routing exclusively to the Ready Pod hostnames:

```
color-api-5db48dc649-v4kzm
color-api-5db48dc649-snzbv
```

Not-Ready Pods received zero traffic despite running.

### No Restarts

Readiness failures do not trigger container restarts. Restart Count remained 0 across all Pods. This distinguishes Readiness from Liveness.

## Cleanup

```bash
kubectl delete -f .
```

## Files

```
api-deployment.yaml
color-api-svc.yaml
traffic-generator.yaml
outputs/
  01-apply-all.txt
  02-pods-after-readiness.txt
  03-delete-unisolated-resources.txt
  04-apply-isolated-resources.txt
  05-isolated-readiness-pods.txt
  06-service-endpoints-isolated.txt
  07-pods-wide-endpoint-match.txt
  08-describe-not-ready-pod.txt
  09-traffic-generator-logs.txt
  10-service-endpoints.txt
  11-readiness-no-restart-proof.txt
  12-cleanup.txt
  13-deployment-after-cleanup.txt
  14-traffic-generator-after-cleanup.txt
  15-service-after-cleanup.txt
  16-lab-conclusion.txt
  17-final-files-created.txt
```

## Conclusion

Readiness Probe controls traffic routing, not container restarts. Pods that fail readiness checks are removed from Service endpoints and receive no traffic. They continue running and are eligible to become Ready again once the check passes.
