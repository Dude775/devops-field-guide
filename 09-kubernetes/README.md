# Module 10: Kubernetes - Container Orchestration

> **Status**: IN PROGRESS
> **Prerequisites**: [Module 08 - Docker](../08-docker/)

## Overview

Kubernetes is the industry-standard container orchestrator. Where Docker runs containers, Kubernetes manages them at scale - handling availability, scaling, self-healing, and configuration across fleets of machines. This module covers the full picture from architecture to production patterns.

## Module Goals

- Understand why Kubernetes exists and when to use it (and when not to)
- Map the cluster architecture: Control Plane + Data Plane
- Master the declarative model and reconciliation loop
- Learn core objects: Pod, ReplicaSet, Deployment, Service, Ingress
- Develop kubectl fluency for day-to-day operations

## Contents

| Date | Exercise | Topics |
|------|----------|--------|
| 2026-06-03 | [Day 01 - Why Kubernetes + Architecture Overview](./exercises/day-01-overview-and-architecture.md) | K8s motivation, cluster architecture, control plane, worker nodes, object hierarchy |
| 2026-06-03 | [Day 03 Hands-On 3.2 - Inspect, Communication and Logs](./exercises/kubernetes-day03-hands-on-3-2-inspect-communication-logs.md) | kubectl get/describe, Pod-to-Pod IP communication, kubectl logs, DNS-by-name vs Service |
| 2026-06-04 | [Module 4 - Object Management & YAML Manifests](./exercises/04-object-management-yaml.md) | 3 management approaches, manifest structure, apply vs create vs replace, --dry-run, 3-way merge |
| 2026-06-04 | [Module 5 - ReplicaSets](./exercises/05-replicasets.md) | Self-healing demo, selector/template matching, RS limitations, image update problem |
| 2026-06-04 | [Module 6 - Deployments](./exercises/06-deployments-intro.md) | Deployment hierarchy, pod-template-hash, RollingUpdate strategy, rollout commands |
| 2026-06-07 | [Day 03 Lab 4.1 + 4.2 - Pod & NodePort Service](./exercises/day03-pod-and-nodeport-service.md) | Pod manifest, NodePort Service, selector-to-label binding, in-cluster DNS, ephemeral debug pods |

## Key Concepts

- **Declarative model** - you describe the desired state, K8s makes it happen
- **Reconciliation loop** - continuous comparison of current state vs desired state
- **Control Plane** - the brain: etcd, API Server, Scheduler, Controller Manager
- **Data Plane** - the muscle: worker nodes running actual workloads
- **Pod** - smallest deployable unit (one or more containers)
- **ReplicaSet** - ensures N copies of a pod are always running
- **Deployment** - manages ReplicaSets, enables rolling updates
- **Service** - stable network endpoint in front of pods
- **Ingress** - HTTP routing rules into the cluster

## Resources

- [NetworkChuck - Kubernetes](https://www.youtube.com/@NetworkChuck)
- [TechWorld with Nana - Kubernetes Tutorial](https://www.youtube.com/@TechWorldwithNana)
- [Official Kubernetes Docs](https://kubernetes.io/docs/)
- [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
