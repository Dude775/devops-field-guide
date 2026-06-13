# 06 - Services Deep Dive

> **Series**: Kubernetes Learning Path — Module 06
> **Topic**: Exposing workloads inside and outside the cluster

## Overview

Services are the stable network endpoint in front of a set of Pods. Where Pods are ephemeral and get new IPs on every restart, a Service provides a fixed DNS name and IP that routes traffic to healthy Pods using label selectors.

This module covers all four Service types, DNS-based discovery, and how the K8s network model connects everything together.

## Core Concepts

| Concept | Summary |
|---------|---------|
| **ClusterIP** | Default. Reachable only inside the cluster |
| **NodePort** | Exposes service on each Node's IP at a static port (30000–32767) |
| **LoadBalancer** | Provisions a cloud load balancer; extends NodePort |
| **ExternalName** | DNS alias for an external hostname |
| **kube-proxy** | Manages iptables/IPVS rules that implement Service routing |
| **CoreDNS** | Cluster-internal DNS: `<svc>.<ns>.svc.cluster.local` |

## Labs

| Lab | Description | Status |
|-----|-------------|--------|
| [Hands-On 6.0 - Color API Update](./hands-on-6.0-color-api-update/) | Build and push a containerised Node app; verify hostname-based routing mental model | ✓ done |

## Key Takeaway

Before wiring a Service, you need a stable, versioned image in a registry. Hands-On 6.0 builds that foundation: run the app locally, verify endpoints, containerise it, and push it to Docker Hub — so that later labs can reference `idf775/color-api:1.1.0` in a Deployment manifest.
