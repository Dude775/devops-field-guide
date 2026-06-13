# 06 - Services Deep Dive

> **Series**: Kubernetes Learning Path — Module 06
> **Topic**: Exposing workloads inside and outside the cluster

---

## Overview

Services are the stable network endpoint in front of a set of Pods. Where Pods are ephemeral and get new IPs on every restart, a Service provides a fixed DNS name and IP that routes traffic to healthy Pods using label selectors.

This module covers all four Service types, DNS-based discovery, traffic generation, and how the Kubernetes network model connects everything together.

---

## Core Concepts

| Concept | Summary |
|---------|---------|
| **ClusterIP** | Default. Reachable only inside the cluster |
| **NodePort** | Exposes service on each Node's IP at a static port (30000–32767) |
| **LoadBalancer** | Provisions a cloud load balancer; extends NodePort |
| **ExternalName** | DNS alias for an external hostname |
| **kube-proxy** | Manages iptables/IPVS rules that implement Service routing |
| **CoreDNS** | Cluster-internal DNS: `<svc>.<ns>.svc.cluster.local` |

---

## Labs

| # | Lab | Folder | Status |
|---|-----|--------|--------|
| 6.0 | Hands-On 6.0 - עדכון Color API והכנת Image חדש ל-Services [Non Developers] | [hands-on-6.0-color-api-update](./hands-on-6.0-color-api-update/) | ✓ done |
| 6.0 | Hands-On 6.0 - עדכון Color API והכנת Image חדש ל-Services [Devs Only] | [hands-on-6.0-color-api-update-devs-only](./hands-on-6.0-color-api-update-devs-only/) | ✓ done |
| 6.1 | Hands-On 6.1 - יצירת Traffic Generator והכנת Image לדמו | [hands-on-6.1-traffic-generator-image](./hands-on-6.1-traffic-generator-image/) | ✓ done |
| 6.2 | Hands-On 6.2 - עבודה עם Pods לפני Service והתקשרות ישירה | [hands-on-6.2-pods-direct-communication-before-service](./hands-on-6.2-pods-direct-communication-before-service/) | ✓ done |
| 6.3 | Hands-On 6.3 - ClusterIP Service ותקשורת יציבה | [hands-on-6.3-clusterip-service](./hands-on-6.3-clusterip-service/) | ✓ done |
| 6.4 | Hands-On 6.4 - עבודה עם NodePort Service | [hands-on-6.4-nodeport-service](./hands-on-6.4-nodeport-service/) | ✓ done |
| 6.5 | Hands-On 6.5 - NodePort ב-Linux מלא ב-KillerCoda Playground | [hands-on-6.5-nodeport-linux-killercoda](./hands-on-6.5-nodeport-linux-killercoda/) | ✓ done |
| 6.6 | Hands-On 6.6 - ExternalName Service | [hands-on-6.6-externalname-service](./hands-on-6.6-externalname-service/) | ✓ done |

---

## Image Assets Built in This Series

| Image | Tag | Digest | Built In |
|-------|-----|--------|----------|
| `idf775/color-api` | `1.1.0` | — | Hands-On 6.0 |
| `idf775/traffic-generator` | `1.0.0` | `sha256:13a4f1fb7764515bd8e73ae5d9089c9528bc328d0fe53d1166a8496c522ba5b8` | Hands-On 6.1 |

---

## Key Takeaway

Before wiring a Service, you need stable, versioned images in a registry. Hands-On 6.0 and 6.1 build that foundation: a Color API that responds with color and hostname, and a traffic generator that hits any HTTP target on a loop. These two images are the building blocks for every Service demo in this module.
