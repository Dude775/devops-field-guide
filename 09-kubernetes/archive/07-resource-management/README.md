# 07 - Resource Management

> **Series**: Kubernetes Learning Path — Module 07
> **Topic**: Labels, Selectors, Namespaces, ResourceQuota, Requests and Limits

---

## Overview

This module covers how Kubernetes organizes and controls workloads through Labels, Selectors, and Namespaces, and how it enforces resource consumption boundaries through ResourceQuota, Requests, and Limits.

Labels are the glue between Kubernetes objects. Selectors let Services, Deployments, and other controllers find their Pods. Namespaces partition the cluster into isolated virtual environments. ResourceQuotas cap how much CPU and memory a Namespace can consume in total.

---

## Labs

| # | Lab | Folder | Status |
|---|-----|--------|--------|
| 7.0 | Hands-On 7.0 - Labels and Selectors | [hands-on-7.0-labels-selectors](./hands-on-7.0-labels-selectors/) | ✓ done |
| 7.1 | Hands-On 7.1 - Deployment Selectors | [hands-on-7.1-deployment-selectors](./hands-on-7.1-deployment-selectors/) | ✓ done |
| 7.2 | Hands-On 7.2 - Namespaces | [hands-on-7.2-namespaces](./hands-on-7.2-namespaces/) | ✓ done |
| 7.3 | Hands-On 7.3 - Service DNS Across Namespaces | [hands-on-7.3-service-dns-namespaces](./hands-on-7.3-service-dns-namespaces/) | ✓ done |
| 7.4 | Hands-On 7.4 - ResourceQuotas | [hands-on-7.4-resource-quotas](./hands-on-7.4-resource-quotas/) | ✓ done |
| 7.5 | Hands-On 7.5 - ResourceQuota with Pod Requests and Limits | [hands-on-7.5-resourcequota-pods-requests-limits](./hands-on-7.5-resourcequota-pods-requests-limits/) | ✓ done |
| 7.6 | Hands-On 7.6 - ResourceQuota: Rolling Updates and Scaling | [hands-on-7.6-resourcequota-rolling-scaling](./hands-on-7.6-resourcequota-rolling-scaling/) | ✓ done |
| 7.7 | Hands-On 7.7 - Probes Prep | — | pending |

---

## Key Concepts

| Concept | Summary |
|---------|---------|
| **Label** | Key-value pair attached to any Kubernetes object |
| **Selector** | Filter expression that matches objects by label |
| **Equality-based selector** | `app=color-api`, `tier!=backend` |
| **Set-based selector** | `tier in (frontend, backend)`, `tier notin (frontend)` |
| **Namespace** | Virtual cluster partition — resources in one namespace are invisible to others by default |
| **-n flag** | Required to target a non-default namespace in kubectl |
| **Service DNS FQDN** | `<service>.<namespace>.svc.cluster.local` for cross-namespace communication |
| **ResourceQuota** | Namespace-level hard caps on CPU and memory requests and limits |
| **Resource Request** | Minimum guaranteed CPU/memory for scheduling |
| **Resource Limit** | Maximum CPU/memory the container is allowed to use |
| **Quota enforcement** | Happens at API Server time — rejected before scheduling if quota exceeded |
| **Rolling Update + Quota** | Full quota blocks Rolling Updates — need headroom for surge Pods |
