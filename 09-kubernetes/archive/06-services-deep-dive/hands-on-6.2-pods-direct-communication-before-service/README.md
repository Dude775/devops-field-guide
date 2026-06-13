# Hands-On 6.2 - Pods Direct Communication Before Service

> **Status**: done
> **Environment**: Minikube (Windows), kubectl

---

## What This Lab Demonstrates

Direct Pod-to-Pod communication using a Pod IP is unstable. This lab proves it by connecting a traffic generator directly to one Pod's IP, then deleting that Pod and watching what breaks.

---

## Setup

**Deployment**: 5 replicas of Color API

```bash
kubectl apply -f color-api-deployment.yaml
kubectl apply -f traffic-generator.yaml
```

The traffic-generator Pod was configured with a hardcoded Pod IP in its `args`:

```yaml
args:
  - "http://10.244.0.179/api"
  - "0.5"
```

Target Pod before delete:
- Name: `color-api-deployment-7dd66bdc46-5zgn6`
- IP: `10.244.0.179`

---

## What Happened

### Before delete — working

Traffic generator was hitting the Pod directly. Logs showed consistent output:

```
[2026-06-13 17:21:38] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-5zgn6
[2026-06-13 17:21:39] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-5zgn6
```

Same Pod name every time — no load balancing, just one target.

### Pod deleted

```bash
kubectl delete pod color-api-deployment-7dd66bdc46-5zgn6
```

Deployment immediately created a replacement:
- New Pod: `color-api-deployment-7dd66bdc46-9frz7`
- New IP: `10.244.0.183`

The old IP `10.244.0.179` was gone.

### After delete — broken

Traffic generator still pointed to `10.244.0.179`. Logs started showing empty timestamp lines with no COLOR or HOSTNAME:

```
[2026-06-13 17:21:44] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-5zgn6
[2026-06-13 17:21:45] 
```

The traffic-generator image does not print a nice error message when the connection fails — it just outputs the timestamp with nothing after it. That empty line is the failure evidence.

Confirmed manually:

```
traffic generator still points to: 10.244.0.179
old target ip not found in current pods
```

---

## Conclusion

- Kubernetes recovered the missing replica automatically (Deployment self-healing works).
- The client (traffic-generator) had no way to discover the new Pod IP.
- Direct Pod IP communication is fundamentally unreliable in Kubernetes.
- This is why `Service` abstraction exists — it provides a stable endpoint that tracks live Pod IPs automatically.

---

## Files

```
.
├── color-api-deployment.yaml    # 5-replica Color API deployment
├── traffic-generator.yaml       # Pod using hardcoded Pod IP
├── outputs/                     # Terminal outputs captured during the lab
│   ├── 01-color-api-pods-before-delete.txt
│   ├── 02-traffic-generator-before-delete.txt
│   ├── 03-target-pod-before-delete.txt
│   ├── 04-traffic-generator-success-logs.txt
│   ├── 05-color-api-pods-after-delete.txt
│   ├── 06-traffic-generator-errors-after-delete.txt
│   ├── 07-traffic-generator-fixed-target.txt
│   ├── 08-current-color-api-pods.txt
│   ├── 09-traffic-generator-current-state.txt
│   ├── 10-traffic-generator-after-target-delete-live.txt
│   ├── 11-traffic-generator-events.txt
│   ├── 12-fixed-pod-ip-proof.txt
│   ├── 13-deployment-still-healthy.txt
│   ├── 14-replicaset-status.txt
│   └── 15-lab-conclusion.txt
└── images/
    └── README.md               # Planned screenshots list
```

---

## Next

Lab 6.3 introduces ClusterIP Service — a stable virtual IP with label-selector-based routing that solves exactly this problem.
