# Day 03 - Lab 4.1 + 4.2: Pod via YAML & NodePort Service

> **Date**: 2026-06-07
> **Module**: 09 - Kubernetes
> **Status**: Completed and verified end-to-end

---

## Overview

Two labs back to back. First: write a Pod manifest and create it with `kubectl create -f`. Second: write a NodePort Service that binds to that Pod via label selector, then verify traffic flows all the way through from inside the cluster.

Why it matters: this is the first time you build the full app-to-network chain manually. No imperative shortcuts. Everything as YAML.

---

## Environment

| Tool | Version |
|------|---------|
| minikube | latest stable |
| Kubernetes | v1.35.1 |
| Docker (driver) | 29.2.1 |
| Shell | Git Bash on Windows |

---

## Part 1: Pod via YAML (Lab 4.1)

### Manifest - `nginx-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx-container
      image: nginx:1.27.0
      ports:
        - containerPort: 80
```

Folder path used in class: `~/Desktop/Kubeinertis/day03/manifests/labs/Object-Management/`

### Create and verify

```bash
kubectl create -f nginx-pod.yaml

kubectl get pods -o wide
# NAME        READY   STATUS    RESTARTS   AGE   IP             NODE
# nginx-pod   1/1     Running   0          30s   10.244.0.20    minikube
```

### kubectl describe output (key fields)

```
Name:         nginx-pod
Labels:       app=nginx
Status:       Running
IP:           10.244.0.20
Containers:
  nginx-container:
    Image:          nginx:1.27.0
    Port:           80/TCP
```

No annotations, label `app=nginx` confirmed, port 80/TCP, image matches spec.

---

## Part 2: NodePort Service via YAML (Lab 4.2)

### Manifest - `nginx-svc.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
```

Folder path used in class: `~/Desktop/Kubeinertis/day03/labs/04.2-nodeport-service/`

### Safe YAML authoring via heredoc (Git Bash)

```bash
mkdir -p ~/Desktop/Kubeinertis/day03/labs/04.2-nodeport-service
cd ~/Desktop/Kubeinertis/day03/labs/04.2-nodeport-service

cat > nginx-svc.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
EOF
```

Always verify before applying:

```bash
cat nginx-svc.yaml
wc -l nginx-svc.yaml
# 14 nginx-svc.yaml
```

### Apply and verify

```bash
kubectl apply -f nginx-svc.yaml
# service/nginx-svc created

kubectl get svc
# NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
# nginx-svc    NodePort    10.109.165.224   <none>        80:30080/TCP   5s

kubectl describe svc nginx-svc
```

Key fields from describe:

```
Name:                     nginx-svc
Type:                     NodePort
IP:                       10.109.165.224
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  30080/TCP
Endpoints:                10.244.0.20:80
Selector:                 app=nginx
```

`Endpoints: 10.244.0.20:80` = selector matched the Pod. The Service works.

---

## Part 3: End-to-End Traffic Test

Spin up an ephemeral Alpine pod inside the cluster and curl the service:

```bash
kubectl run tmp-alpine --rm -it --image=alpine --restart=Never -- sh
```

Inside the pod:

```sh
apk add --no-cache curl

# short name (DNS within namespace)
curl -I http://nginx-svc:80

# FQDN
curl -I http://nginx-svc.default.svc.cluster.local:80
```

Both return:

```
HTTP/1.1 200 OK
Server: nginx/1.27.0
```

---

## Traffic Flow Diagram

```
                   ┌─────────────────────────────────────────┐
                   │            minikube node                │
                   │                                         │
  curl from host   │   NodePort 30080                        │
  ───────────────► │        │                                │
                   │        ▼                                │
                   │   Service: nginx-svc (NodePort)         │
                   │   ClusterIP 10.109.165.224:80           │
                   │   selector: app=nginx                   │
                   │        │                                │
                   │        ▼ (matches label)                │
                   │   Pod: nginx-pod                        │
                   │   IP 10.244.0.20                        │
                   │   label app=nginx                       │
                   │   container nginx:1.27.0 :80            │
                   └─────────────────────────────────────────┘

  In-cluster DNS lookups (from any Pod in default namespace):
    nginx-svc                               → 10.109.165.224
    nginx-svc.default.svc.cluster.local     → 10.109.165.224
```

Port semantics:

| Field | Value | Meaning |
|-------|-------|---------|
| `nodePort` | 30080 | External port on the node, accessible from outside |
| `port` | 80 | Port the Service listens on inside the cluster |
| `targetPort` | 80 | Port the container actually listens on |

---

## Iron Rules

1. Always `cat` + `wc -l` a manifest before `kubectl apply`. Empty file = `error: no objects passed to apply`.
2. `code file.yaml` from terminal can open an unrelated VS Code workspace. Edits won't land where you think. Prefer heredoc when in doubt.
3. Never mix shell syntaxes. Bash heredoc inside PowerShell fails with `The '<' operator is reserved for future use`.
4. Service `selektor` must match Pod `labels` exactly. Empty `Endpoints` in describe = selector miss.
5. NodePort range is 30000-32767. Outside that range = validation error from the API server.
6. Each lab gets its own folder. Never mix manifests between labs.

---

## Anchors to Other Modules

- **07-docker**: `nginx:1.27.0` is the same container image artifact from Docker. K8s just wraps it in a Pod spec.
- **05-networking**: TCP/IP, ports, and DNS resolution studied there apply directly here. Cluster DNS is the same protocol, different resolver.
- **01-linux**: `heredoc`, `cat`, file redirection used to author manifests safely. Same tools, new context.

---

## Screenshots

> Create `09-kubernetes/resources/images/` and capture:

- `00-kubectl-get-svc.png` - `kubectl get svc` showing nginx-svc as NodePort
- `01-describe-svc-endpoints.png` - `kubectl describe svc nginx-svc` with Endpoints visible
- `02-curl-from-alpine.png` - Alpine pod terminal showing `HTTP/1.1 200 OK` from both short name and FQDN

Reference paths: `../resources/images/<filename>`

---

## Interview Questions

1. What is the difference between `port`, `targetPort`, and `nodePort` in a Service?
2. How does a Service know which Pods to route traffic to?
3. What does an empty `Endpoints` field on a Service indicate?
4. Why is the NodePort range limited to 30000-32767?
5. How would you debug "Service not reachable" inside a cluster?
6. What is the FQDN format for a Service in Kubernetes? Why does the short name also resolve?
7. When would you choose NodePort vs ClusterIP vs LoadBalancer?
