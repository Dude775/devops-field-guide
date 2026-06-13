# Hands-On 6.4 - NodePort Service

> **Status**: done
> **Environment**: Minikube (Windows), kubectl

---

## What This Lab Demonstrates

NodePort extends ClusterIP by also reserving a port on each cluster Node (30000–32767). This makes the Service reachable from outside the cluster — either directly via NodeIP:NodePort or through a tunnel on Minikube.

---

## Setup

```bash
kubectl apply -f color-api-deployment.yaml
kubectl apply -f color-api-nodeport.yaml
```

Service created:

```
NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
color-api-nodeport   NodePort   10.109.240.53   <none>        80:30007/TCP   5s    app=color-api
```

Ports:
- `port: 80` — internal cluster port
- `targetPort: 80` — Pod container port
- `nodePort: 30007` — exposed externally on every Node

The Service also received an internal ClusterIP (`10.109.240.53`), so it works as a ClusterIP inside the cluster too.

---

## Accessing on Minikube (Windows)

On Windows Minikube, the Node IP is inside a VM and not directly reachable from the host. The standard approach:

```bash
minikube service color-api-nodeport --url
```

Output:

```
http://127.0.0.1:50443
```

Minikube created a tunnel that forwarded the NodePort to localhost. The app was accessible from the browser and curl at that URL.

---

## Verified Behaviors

### HTML endpoint

```bash
curl http://127.0.0.1:50443/
```

Response:

```html
<h1 style="color:blue;">Hello from Color API</h1>
<h2>color-api-deployment-7dd66bdc46-52zzx</h2>
```

### JSON endpoint — load balancing

```bash
curl http://127.0.0.1:50443/api
```

Multiple calls returned different hostnames, confirming load balancing across Pods:

```json
{"color":"blue","hostname":"color-api-deployment-7dd66bdc46-jt7tc"}
{"color":"blue","hostname":"color-api-deployment-7dd66bdc46-4bdhw"}
{"color":"blue","hostname":"color-api-deployment-7dd66bdc46-jt7tc"}
{"color":"blue","hostname":"color-api-deployment-7dd66bdc46-52zzx"}
{"color":"blue","hostname":"color-api-deployment-7dd66bdc46-52zzx"}
```

### Service Endpoints

```
NAME                 ENDPOINTS                                                     AGE
color-api-nodeport   10.244.0.186:80,10.244.0.187:80,10.244.0.188:80 + 2 more...   56s
```

5 Pods behind the Service, same as ClusterIP.

---

## Service Describe

```
Name:       color-api-nodeport
Type:       NodePort
IP:         10.109.240.53
Port:       80/TCP
TargetPort: 80/TCP
NodePort:   30007/TCP
Endpoints:  10.244.0.186:80,10.244.0.187:80,10.244.0.188:80 + 2 more...
```

---

## Conclusion

| Aspect | Value |
|--------|-------|
| Cluster-internal access | `http://color-api-nodeport/api` (DNS) or `http://10.109.240.53/api` (ClusterIP) |
| External access | `NodeIP:30007` (Linux) or `minikube service --url` (Windows) |
| Load balancing | Works — requests distributed across all 5 Pods |
| Use case | Development and testing. Not recommended for production exposure. |

NodePort gives external access without a cloud load balancer, but the port range (30000–32767) and the need to know Node IPs make it impractical in production. For that, use LoadBalancer or Ingress.

---

## Files

```
.
├── color-api-deployment.yaml    # 5-replica Color API deployment
├── color-api-nodeport.yaml      # NodePort Service definition
├── outputs/
│   ├── 01-color-api-pods.txt
│   ├── 02-nodeport-service-created.txt
│   ├── 03-deployment-status.txt
│   ├── 04-node-info.txt
│   ├── 05-nodeport-tunnel.log
│   ├── 05-nodeport-tunnel.pid
│   ├── 05-nodeport-url.txt
│   ├── 06-browser-html-response.txt
│   ├── 07-nodeport-json-load-balancing.txt
│   ├── 08-nodeport-service-describe.txt
│   ├── 09-nodeport-endpoints.txt
│   ├── 10-nodeport-final-load-balancing.txt
│   └── 11-lab-conclusion.txt
└── images/
    └── README.md               # Planned screenshots list
```
