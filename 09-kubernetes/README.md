# 09 - Kubernetes: Container Orchestration

> **Status**: IN PROGRESS
> **Prerequisites**: [Module 08 - Docker](../08-docker/)

## Overview

Kubernetes is the industry-standard container orchestrator. Where Docker runs containers, Kubernetes manages them at scale — handling availability, scaling, self-healing, and configuration across fleets of machines.

---

## Structure

### [archive/](./archive/)

Numbered course series (modules 02–11). Structured content from the Kubernetes learning path.

| Series | Topic | Status |
|--------|-------|--------|
| [02 - Installing Tools](./archive/02-installing-tools/) | kubectl, minikube, cluster setup | — |
| [03 - Running Containers in Kubernetes](./archive/03-running-containers-in-kubernetes/) | Pods, kubectl basics, inspect & logs | notes |
| [04 - Object Management & YAML Manifests](./archive/04-object-management-and-yaml-manifests/) | Declarative vs imperative, apply vs create, dry-run | notes |
| [05 - ReplicaSets and Deployments](./archive/05-replicasets-and-deployments/) | Self-healing, rolling updates, rollout commands | notes |
| [06 - Services Deep Dive](./archive/06-services-deep-dive/) | ClusterIP, NodePort, LoadBalancer, DNS, traffic generation, service routing labs | lab |
| [07 - Resource Management](./archive/07-resource-management/) | Requests, limits, QoS classes | — |
| [08 - Storage and Persistence](./archive/08-storage-and-persistence/) | PV, PVC, StorageClass | — |
| [09 - Configuration Management](./archive/09-configuration-management/) | ConfigMaps, Secrets, env injection | — |
| [10 - Project: Deploying a MongoDB Database](./archive/10-project-deploying-a-mongodb-database/) | End-to-end stateful workload | — |
| [11 - Security Fundamentals](./archive/11-security-fundamentals/) | RBAC, ServiceAccounts, TLS | lab |

---

### [rolling-lab/](./rolling-lab/)

Hands-on labs and e2e projects built outside the numbered series.

| Lab | Description |
|-----|-------------|
| [Interview Q&A - K8s Basic Architecture](./rolling-lab/interview-q-and-a-k8s-basic-architechture/) | Architecture concepts, interview prep |
| [Kubernetes e2e Lab Part 1](./rolling-lab/kubernetes-e2e-lab-part-1/) | Movie Recommendation API: Dockerfile → Deployment → Service → Scaling → Rolling Update → Rollback |
| [Kubernetes e2e Lab Part 2](./rolling-lab/kubernetes-e2e-lab-part-2/) | (in progress) |

---

### [_inbox-review/](./_inbox-review/)

Files not yet classified into the hierarchy above — preserved intact, pending review.

---

## Key Concepts

- **Declarative model** — describe desired state; K8s reconciles
- **Control Plane** — etcd, API Server, Scheduler, Controller Manager
- **Data Plane** — worker nodes running actual workloads
- **Pod** — smallest deployable unit
- **ReplicaSet** — ensures N replicas are always running
- **Deployment** — manages ReplicaSets, enables rolling updates
- **Service** — stable network endpoint in front of pods
- **Ingress** — HTTP routing into the cluster

## Resources

- [Official Kubernetes Docs](https://kubernetes.io/docs/)
- [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [TechWorld with Nana - Kubernetes Tutorial](https://www.youtube.com/@TechWorldwithNana)
- [NetworkChuck - Kubernetes](https://www.youtube.com/@NetworkChuck)
