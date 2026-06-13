# 08 - Storage and Persistence

> **Series**: Kubernetes Learning Path — Module 08
> **Topic**: PersistentVolumes, PersistentVolumeClaims, StorageClass, ReclaimPolicy

---

## Overview

This module covers how Kubernetes manages persistent storage. Containers are ephemeral by default — data written inside a container is lost when the container restarts. Kubernetes solves this through PersistentVolumes (PV), PersistentVolumeClaims (PVC), and StorageClasses, which abstract the underlying storage from the workload.

---

## Labs

| # | Lab | Folder | Status |
|---|-----|--------|--------|
| 8.1 | Hands-On 8.1 - ReclaimPolicy | [hands-on-8.1-reclaim-policy](./hands-on-8.1-reclaim-policy/) | ✓ done |

---

## Key Concepts

| Concept | Summary |
|---------|---------|
| **PersistentVolume (PV)** | Cluster-level storage resource, provisioned statically or dynamically |
| **PersistentVolumeClaim (PVC)** | Namespace-level request for storage; binds to a PV |
| **StorageClass** | Template for dynamic PV provisioning; defines provisioner and reclaim policy |
| **Dynamic provisioning** | StorageClass automatically creates a PV when a matching PVC is applied |
| **ReclaimPolicy: Delete** | PV and underlying storage deleted automatically when PVC is deleted |
| **ReclaimPolicy: Retain** | PV moves to Released when PVC is deleted; data preserved, manual reclaim required |
| **Released state** | PV is no longer bound but not yet available; previous data still present |
| **Patching PV reclaim policy** | Can be changed on an existing PV without touching the StorageClass |
