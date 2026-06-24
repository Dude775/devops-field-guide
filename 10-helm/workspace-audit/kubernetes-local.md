# Kubernetes Local State
Generated: 2026-06-20

---

## Context

```
Current context: minikube
```

---

## Nodes

```
NAME       STATUS   ROLES           AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE
minikube   Ready    control-plane   6d8h   v1.35.1   192.168.49.2   <none>        Debian GNU/Linux 12 (bookworm)
```
Kernel: `6.6.87.2-microsoft-standard-WSL2` | Runtime: `docker://29.2.1`

Single-node minikube cluster running in WSL2. Active and healthy.

---

## Namespaces

| Namespace | Status | Age | Notes |
|-----------|--------|-----|-------|
| `default` | Active | 6d8h | Main workloads |
| `kube-node-lease` | Active | 6d8h | System |
| `kube-public` | Active | 6d8h | System |
| `kube-system` | Active | 6d8h | System |
| `kubernetes-dashboard` | Active | 6d6h | Dashboard UI |

---

## Pods

| Namespace | Pod | Status | Restarts | Age | Classification |
|-----------|-----|--------|----------|-----|----------------|
| `default` | `local-wp-mariadb-0` | Running | 1 | 6d6h | **WordPress DB — Helm lab** |
| `default` | `local-wp-wordpress-697d97cf5d-6cvt8` | Running | 1 | 6d6h | **WordPress — Helm lab** |
| `default` | `nginx-85bc587484-cpf94` | Running | 1 | 6d2h | **nginx — Helm lab (my-nginx chart)** |
| `kube-system` | `coredns-7d764666f9-4fhrz` | Running | 4 | 6d8h | System DNS |
| `kube-system` | `coredns-7d764666f9-zt9lm` | Running | 4 | 6d8h | System DNS |
| `kube-system` | `etcd-minikube` | Running | 4 | 6d8h | System etcd |
| `kube-system` | `kube-apiserver-minikube` | Running | 4 | 6d8h | System API server |
| `kube-system` | `kube-controller-manager-minikube` | Running | 4 | 6d8h | System controller |
| `kube-system` | `kube-proxy-5k5gp` | Running | 4 | 6d8h | System proxy |
| `kube-system` | `kube-scheduler-minikube` | Running | 4 | 6d8h | System scheduler |
| `kube-system` | `storage-provisioner` | Running | 9 | 6d8h | System storage |
| `kubernetes-dashboard` | `dashboard-metrics-scraper-5565989548-xdkhm` | Running | 1 | 6d6h | Dashboard |
| `kubernetes-dashboard` | `kubernetes-dashboard-b84665fb8-zw8vd` | Running | 2 | 6d6h | Dashboard UI |

---

## Services

| Namespace | Service | Type | Cluster-IP | Port(s) | Notes |
|-----------|---------|------|-----------|---------|-------|
| `default` | `kubernetes` | ClusterIP | 10.96.0.1 | 443 | System |
| `default` | `local-wp` | NodePort | 10.111.164.1 | 8080:30182, 8443:31604 | **WordPress Helm release** |
| `default` | `local-wp-mariadb` | ClusterIP | 10.111.99.187 | 3306 | MariaDB for WordPress |
| `default` | `local-wp-mariadb-headless` | ClusterIP | None | 3306 | MariaDB headless |
| `default` | `local-wp-wordpress` | LoadBalancer | 10.100.195.29 | 80:32753, 443:30209 | External pending |
| `default` | `nginx-svc` | ClusterIP | 10.108.187.25 | 80 | nginx service |
| `kube-system` | `kube-dns` | ClusterIP | 10.96.0.10 | 53/UDP, 53/TCP, 9153 | System DNS |
| `kubernetes-dashboard` | `dashboard-metrics-scraper` | ClusterIP | 10.106.91.32 | 8000 | Dashboard |
| `kubernetes-dashboard` | `kubernetes-dashboard` | ClusterIP | 10.96.1.67 | 80 | Dashboard UI |

---

## Persistent Volume Claims (PVCs)

| Namespace | PVC Name | Status | Volume | Capacity | Notes |
|-----------|---------|--------|--------|----------|-------|
| `default` | `data-local-wp-mariadb-0` | **Bound** | pvc-10ff... | 8Gi | MariaDB data - **DO NOT DELETE** |
| `default` | `data-my-wordpress-mariadb-0` | **Bound** | pvc-f3221... | 8Gi | Old WordPress MariaDB? **Investigate** |
| `default` | `local-wp-wordpress` | **Bound** | pvc-bb27... | 10Gi | WordPress content - **DO NOT DELETE** |

> **Note:** `data-my-wordpress-mariadb-0` — there are TWO MariaDB PVCs. One for `local-wp` and one for `my-wordpress`. The `my-wordpress` Helm release may have been deleted but the PVC remains. Needs investigation.

---

## Helm Releases (`helm list -A`)

| Release | Namespace | Version | Status | Chart | App Version | Notes |
|---------|-----------|---------|--------|-------|------------|-------|
| `local-wp` | default | 1 | deployed | wordpress-29.2.4 | 6.9.4 | **Active WordPress** |
| `my-nginx` | default | 1 | deployed | nginx-0.1.0 | 1.27.0 | **Custom nginx chart** |

---

## Classification

### Active Resources (do not touch without David's approval)
- Entire minikube cluster
- `local-wp` Helm release (WordPress + MariaDB)
- `my-nginx` Helm release (custom chart for helm lab)
- All 3 PVCs (especially `local-wp-*`)
- Kubernetes Dashboard

### Resources Related to helm-small-project Lab
- `my-nginx` — nginx chart created during the helm-small-project-lab
- nginx pod + nginx-svc in default namespace

### Suspicious / Needs Investigation
- `data-my-wordpress-mariadb-0` PVC — matches a different release name (`my-wordpress`) that no longer appears in `helm list`. Was this a previous WordPress install? The PVC is Bound but orphaned if the release is gone. **Do NOT delete without confirming.**

### Resources That Should NOT Be Deleted Without Confirmation
- All PVCs (total ~26Gi of storage)
- `local-wp` Helm release and all its resources
- minikube volume
- `my-nginx` Helm release

---

## Summary
- Cluster: healthy, single-node minikube
- Running pods: 13 total (2 user workloads, 1 nginx, rest system)
- Helm releases: 2 (wordpress + nginx)
- PVCs: 3 (26Gi total, all bound)
- Namespaces: 5
