# Hands-On 6.3 - ClusterIP Service Stable Communication

> **Status**: done
> **Environment**: Minikube (Windows), kubectl

---

## What This Lab Demonstrates

ClusterIP is the default Service type. It provides a stable virtual IP and DNS name that routes traffic to all healthy Pods matching its label selector. This lab verifies that the Service stays functional through Pod deletions, Deployment removal, and Service recreation.

---

## Setup

```bash
kubectl apply -f color-api-deployment.yaml
kubectl apply -f color-api-clusterip.yaml
```

Service created:

```
NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE   SELECTOR
color-api-clusterip   ClusterIP   10.99.134.47   <none>        80/TCP    2s    app=color-api
```

Selector: `app=color-api` — matches all Color API Pods.

---

## Step 1: Load Balancing via ClusterIP

Traffic generator used the ClusterIP directly:

```yaml
args:
  - "http://10.99.134.47/api"
  - "0.5"
```

Logs immediately showed different hostnames across requests:

```
[17:37:47] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-h7hg5
[17:37:48] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-9frz7
[17:37:49] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-9frz7
[17:37:50] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-vqj24
[17:37:51] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-srjm9
```

The Service distributes requests across all 5 Pods.

---

## Step 2: Pod Deleted — Service Keeps Working

One Pod was deleted while traffic was running. The Deployment replaced it. Traffic continued without interruption, and the new Pod started appearing in logs:

```
[17:38:41] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-v2qx7   ← new replacement
[17:38:42] COLOR: blue, HOSTNAME: color-api-deployment-7dd66bdc46-h7hg5
```

Service Endpoints after the delete still showed 5 active Pods:

```
Endpoints: 10.244.0.180:80,10.244.0.178:80,10.244.0.177:80 + 2 more...
```

---

## Step 3: Deployment Deleted — Service Remains

```bash
kubectl delete deployment color-api-deployment
```

Pods disappeared. The Service object remained but Endpoints became empty:

```
NAME                  ENDPOINTS   AGE
color-api-clusterip   <none>      3m28s
```

The Service keeps its ClusterIP and exists independently of the Pods behind it.

---

## Step 4: Deployment Restored — Endpoints Auto-Recovered

```bash
kubectl apply -f color-api-deployment.yaml
```

New Pods came up with fresh IPs. The Service automatically discovered them:

```
NAME                  ENDPOINTS                                                     AGE
color-api-clusterip   10.244.0.186:80,10.244.0.187:80,10.244.0.188:80 + 2 more...   3m42s
```

No manual re-registration needed. Label selector does it automatically.

---

## Step 5: Switch from ClusterIP to DNS Name

Traffic generator was updated to use the Service DNS name instead of the raw IP:

```yaml
args:
  - "http://color-api-clusterip/api"
  - "0.5"
```

CoreDNS was verified running in kube-system:

```
coredns-7d764666f9-xxkhw   1/1   Running   6 (3h25m ago)   10d
```

Traffic continued working — different hostnames in logs, load balancing still active.

---

## Step 6: Service Recreated — IP Changed, DNS Stable

```bash
kubectl delete service color-api-clusterip
kubectl apply -f color-api-clusterip.yaml
```

ClusterIP changed:

```
OLD=10.99.134.47   →   NEW=10.111.211.17
```

But the DNS name `color-api-clusterip` remained the same. Traffic generator using the DNS name continued working without any changes to its configuration.

This is the key reason to prefer DNS over raw ClusterIP.

---

> **Note**: kubectl printed `Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice` when running `kubectl get endpoints`. This is an API version warning — Endpoints still works, but newer clusters prefer EndpointSlice.

---

## Conclusion

| Behavior | Result |
|----------|--------|
| Pod deleted while traffic runs | Service kept routing to remaining Pods |
| Deployment deleted | Service stayed, Endpoints went empty |
| Deployment re-applied | Endpoints auto-populated with new Pod IPs |
| Service recreated | ClusterIP changed, DNS name stayed the same |

Prefer `http://color-api-clusterip/api` over `http://10.99.134.47/api`. The IP can change. The name does not.

---

## Files

```
.
├── color-api-deployment.yaml    # 5-replica Color API deployment
├── color-api-clusterip.yaml     # ClusterIP Service definition
├── traffic-generator.yaml       # Pod using Service DNS name
├── outputs/                     # Terminal outputs from the lab
│   ├── 01-clusterip-service-created.txt
│   ├── 02-color-api-pods-before-service-test.txt
│   ├── 03-cluster-ip-used.txt
│   ├── 04-clusterip-load-balancing-logs.txt
│   ├── 05-victim-pod-selected.txt
│   ├── 06-pods-after-one-delete.txt
│   ├── 07-traffic-after-pod-delete.txt
│   ├── 08-service-endpoints-after-pod-delete.txt
│   ├── 09-endpoints-before-deployment-delete.txt
│   ├── 10-no-color-api-pods-after-deployment-delete.txt
│   ├── 11-service-still-exists-without-pods.txt
│   ├── 12-empty-endpoints-after-deployment-delete.txt
│   ├── 13-pods-after-deployment-restore.txt
│   ├── 14-endpoints-after-deployment-restore.txt
│   ├── 15-service-dns-load-balancing-logs.txt
│   ├── 16-coredns-pods.txt
│   ├── 17-service-ip-before-delete.txt
│   ├── 18-service-ip-after-recreate.txt
│   ├── 19-service-ip-changed-proof.txt
│   ├── 20-dns-after-service-recreate.txt
│   └── 21-service-final-describe.txt
└── images/
    └── README.md               # Planned screenshots list
```
