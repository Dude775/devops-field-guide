# 07 - Resource Management

> **Series**: Kubernetes Learning Path — Module 07
> **Topic**: Labels, Selectors, Resource Requests, Limits, and QoS

---

## Overview

This module covers how Kubernetes manages and organizes workloads through Labels and Selectors, and how it controls resource consumption through Requests, Limits, LimitRange objects, and Quality of Service (QoS) classes.

Labels are the glue between Kubernetes objects. Selectors let Services, Deployments, and other controllers find their Pods. Resource Requests and Limits determine how the Scheduler places Pods and how the kubelet enforces consumption boundaries.

---

## Labs

| # | Lab | Folder | Status |
|---|-----|--------|--------|
| 7.0 | Hands-On 7.0 - Labels and Selectors | [hands-on-7.0-labels-selectors](./hands-on-7.0-labels-selectors/) | ✓ done |
| 7.1 | Hands-On 7.1 - Resource Requests and Limits | — | pending |
| 7.2 | Hands-On 7.2 - LimitRange and Namespace Defaults | — | pending |
| 7.3 | Hands-On 7.3 - QoS Classes | — | pending |

---

## Key Concepts

| Concept | Summary |
|---------|---------|
| **Label** | Key-value pair attached to any Kubernetes object |
| **Selector** | Filter expression that matches objects by label |
| **Equality-based selector** | `app=color-api`, `tier!=backend` |
| **Set-based selector** | `tier in (frontend, backend)`, `tier notin (frontend)` |
| **Resource Request** | Minimum guaranteed CPU/memory for scheduling |
| **Resource Limit** | Maximum CPU/memory the container is allowed to use |
| **LimitRange** | Namespace-level defaults and caps for Requests/Limits |
| **QoS Class** | Guaranteed / Burstable / BestEffort — determines eviction priority |
