# Day 01 - Why Kubernetes + Architecture Overview

> **Date**: 2026-06-03
> **Module**: 09 - Kubernetes
> **Status**: Complete

---

## 1. Why Kubernetes - The 6 Docker Pain Points at Scale

Docker solves "works on my machine." Kubernetes solves "works on one container, on one machine, in one datacenter."

| Pain Point | Docker Alone | Kubernetes Solution |
|-----------|--------------|---------------------|
| **High Availability** | Container dies, service is down | Pods restarted automatically across healthy nodes |
| **Load Balancing** | Manual nginx config, brittle | Services distribute traffic across pod replicas natively |
| **Scaling** | Manual `docker run` more containers | HPA (Horizontal Pod Autoscaler) scales on CPU/memory/custom metrics |
| **Self-Healing** | Dead container = manual intervention | Controller Manager detects drift, reconciles to desired state |
| **Service Discovery** | Hardcoded IPs, breaks on restart | DNS-based discovery - services get stable hostnames |
| **Config Management** | .env files scattered everywhere | ConfigMaps and Secrets as first-class cluster objects |

**The key insight**: Docker is a tool. Kubernetes is an operating model.

---

## 2. K8s is NOT a Default Choice

Kubernetes adds real operational complexity. The decision should be deliberate.

| Question | Use K8s | Skip K8s |
|----------|---------|----------|
| How many services? | 10+ microservices | 1-3 services |
| Team size? | 5+ engineers | Solo / small team |
| Traffic patterns? | Variable, needs autoscaling | Predictable, flat |
| Uptime requirements? | 99.9%+ SLA | Best-effort acceptable |
| On-call maturity? | Dedicated platform team | No ops capacity |
| Deployment frequency? | Multiple times/day | Weekly or less |

**ECS vs K8s** - the honest comparison:

| | AWS ECS | Kubernetes |
|-|---------|-----------|
| Ops overhead | Low (AWS manages it) | High (you own the control plane) |
| Vendor lock-in | Yes | No |
| Flexibility | AWS ecosystem only | Any cloud or on-prem |
| Learning curve | Moderate | Steep |
| Sweet spot | AWS-native teams, simpler workloads | Large orgs, multi-cloud, complex routing |

> "Starting with K8s on a 2-service app is like buying a forklift to move a couch."

---

## 3. Core Design Principles

### Declarative vs Imperative

| | Imperative | Declarative |
|-|-----------|------------|
| **What you write** | "Run 3 nginx containers, open port 80" | "desired state: 3 nginx replicas, port 80 exposed" |
| **What K8s does** | Executes your commands | Figures out HOW to get there |
| **On failure** | You re-run commands | K8s reconciles automatically |
| **In production** | Dangerous - drift is silent | Safe - state is always versioned |
| **Example** | `kubectl run nginx --image=nginx` | `kubectl apply -f deployment.yaml` |

**The cake analogy**: Imperative is a recipe ("mix 200g flour, add eggs, bake 30min"). Declarative is a photo of the cake ("make it look like this"). K8s figures out the recipe.

### Reconciliation Loop

This is the engine behind everything Kubernetes does:

```
Current State  ──────────────────────────►  Desired State
     │                                            │
     │         Controller observes gap            │
     │◄───────────────────────────────────────────┤
     │                                            │
     ▼                                            │
  Take Action  (create pod / delete pod / etc.)   │
     │                                            │
     └────────────────────────────────────────────►
                     Loop continues
```

The Controller Manager runs this loop constantly. "Current state != desired state" always triggers action.

### Horizontal Scaling vs Resilience - Critical Distinction

These are NOT the same thing. Juniors conflate them constantly.

| | Scaling | Resilience |
|-|---------|-----------|
| **Trigger** | Load increase (CPU, RPS, etc.) | Failure (node down, pod crash) |
| **Action** | Add more pods | Replace failed pods |
| **Tool** | HPA, KEDA | ReplicaSet, restart policy |
| **Question it answers** | "Can we handle more traffic?" | "Can we survive failures?" |
| **Analogy** | Hiring more staff for busy season | Having backup staff when someone calls in sick |

You need both. They solve different problems.

---

## 4. Responsibility Boundaries

Kubernetes manages **workloads**. It does not manage **infrastructure**.

**Building analogy**:
- The building (servers, network, storage) = your responsibility or cloud provider's
- What runs inside the building (apartments/containers) = Kubernetes manages
- K8s is the building manager, not the construction crew

| Layer | Who Manages It |
|-------|---------------|
| Physical/virtual machines | You (on-prem) or cloud provider |
| Network, storage, DNS | You or cloud provider |
| Kubernetes control plane | You (on-prem) or EKS/GKE/AKS |
| Workloads (pods, services) | Kubernetes |
| Application code | Your team |

**On-prem vs Managed**:

| | Self-Managed (kubeadm) | Managed (EKS/GKE/AKS) |
|-|----------------------|----------------------|
| Control plane ops | You patch, upgrade, backup etcd | Cloud provider handles it |
| Cost | Infra cost only | Infra + management fee |
| Control | Full | Partial (cloud constraints) |
| Recommended for | Labs, on-prem enterprise | Most production workloads |

---

## 5. Cluster Architecture

A Kubernetes cluster always has exactly two planes:

```
┌─────────────────────────────────────────────────────────┐
│                    KUBERNETES CLUSTER                    │
│                                                          │
│  ┌──────────────────────┐  ┌──────────────────────────┐ │
│  │    CONTROL PLANE     │  │       DATA PLANE         │ │
│  │    (Master Nodes)    │  │     (Worker Nodes)       │ │
│  │                      │  │                          │ │
│  │  - etcd              │  │  Node 1  Node 2  Node 3  │ │
│  │  - API Server        │  │  ┌────┐  ┌────┐  ┌────┐  │ │
│  │  - Scheduler         │  │  │Pod │  │Pod │  │Pod │  │ │
│  │  - Controller Mgr    │  │  │Pod │  │Pod │  │    │  │ │
│  │  - Cloud Ctrl Mgr    │  │  └────┘  └────┘  └────┘  │ │
│  │                      │  │                          │ │
│  └──────────────────────┘  └──────────────────────────┘ │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**HA requirement**: Production clusters need **3+ master nodes** (or any odd number). This is not a performance concern - it is a consensus concern. etcd uses the Raft protocol which requires a majority quorum to make decisions.

- 2 masters: 1 failure = no quorum, cluster is read-only
- 3 masters: 1 failure = 2/3 quorum, cluster keeps running
- 5 masters: 2 failures = 3/5 quorum, cluster keeps running

> "Even number of masters is worse than one master. Don't do it."

---

## 6. Control Plane Components

All control plane components communicate **exclusively through the API Server**. No component talks directly to another.

| Component | Role | Analogy |
|-----------|------|---------|
| **etcd** | Distributed key-value store - the single source of truth for ALL cluster state | The database |
| **API Server** | The only entry point for all operations - validates, persists to etcd, notifies watchers | The receptionist / router |
| **Scheduler** | Watches for unscheduled pods, assigns them to nodes based on resource availability and constraints | HR assigning desks |
| **Controller Manager** | Runs all built-in reconciliation loops (ReplicaSet, Node, Job controllers, etc.) | The operations manager |
| **Cloud Controller Manager** | Integrates with cloud provider APIs (create LoadBalancer, provision PV, etc.) | The vendor liaison |

**Communication flow** (hub-and-spoke):

```
etcd  ◄──── API Server ────► Scheduler
                 │
                 ├──────────► Controller Manager
                 │
                 └──────────► Worker Nodes (kubelet)
```

Nothing bypasses the API Server. This is by design - single audit log, single auth point.

---

## 7. Worker Node Components

Every worker node must have these 3 components:

| Component | Role |
|-----------|------|
| **kubelet** | The node agent. Registers the node with the cluster, watches for pod assignments from API Server, manages container lifecycle via CRI |
| **Container Runtime** | Actually runs containers. containerd (default), CRI-O, or Docker Engine. Implements CRI (Container Runtime Interface) |
| **kube-proxy** | Manages iptables / ipvs rules for Service networking. Enables pod-to-pod and external-to-pod traffic routing |

**Objects that run on worker nodes** (not node processes, but K8s objects):

| Object | Purpose |
|--------|---------|
| Pod | One or more containers sharing network/storage |
| ReplicaSet | Ensures N pods always running |
| Deployment | Manages ReplicaSets, rolling updates |
| Service | Stable virtual IP + DNS for a set of pods |
| Ingress | HTTP/HTTPS routing rules (needs Ingress Controller) |
| Job | Run-to-completion tasks |
| StatefulSet | Pods with stable identity (databases, queues) |
| ConfigMap | Non-sensitive configuration data |
| Secret | Sensitive data (passwords, tokens, certs) |

---

## 8. Object Hierarchy

```
Ingress
   └── Service
          └── Deployment
                 └── ReplicaSet
                        └── Pod
                               └── Container(s)
```

Reading it bottom-up:
1. **Container** - your actual app
2. **Pod** - wraps container(s), adds network identity
3. **ReplicaSet** - ensures N pods exist, replaces failed ones
4. **Deployment** - manages ReplicaSets, handles rollouts/rollbacks
5. **Service** - stable endpoint pointing to pod(s) via label selector
6. **Ingress** - routes external HTTP traffic to Service(s)

You almost never create Pods or ReplicaSets directly. You create Deployments and let them manage below.

---

## 9. kubectl apply Flow

What actually happens when you run `kubectl apply -f deployment.yaml`:

```
1. kubectl reads the YAML file
         │
         ▼
2. kubectl sends HTTP request to API Server
         │
         ▼
3. API Server authenticates + authorizes the request
         │
         ▼
4. API Server validates the object schema
         │
         ▼
5. API Server writes the desired state to etcd
         │
         ▼
6. API Server notifies watchers (Controller Manager, Scheduler)
         │
         ▼
7. Controller Manager sees new Deployment → creates ReplicaSet
         │
         ▼
8. ReplicaSet controller sees unscheduled pods → creates Pod objects
         │
         ▼
9. Scheduler sees unscheduled Pods → assigns each to a Node
         │
         ▼
10. kubelet on assigned Node sees the Pod assignment
         │
         ▼
11. kubelet tells Container Runtime to pull image + start container
         │
         ▼
12. kubelet reports status back to API Server → etcd updated
```

The key: `kubectl apply` is just writing to etcd. Everything after is async reconciliation.

---

## 10. Iron Rules Earned Today

- Cluster = Control Plane + Data Plane, always. Never one node doing both in production.
- Master nodes do not run workloads. Workers do not make scheduling decisions.
- Declarative > Imperative in production. Imperative is for learning and debugging only.
- K8s is not the default. It is an architectural decision with real operational cost.
- K8s manages what runs on infrastructure, not the infrastructure itself.
- Production HA requires an odd number of masters - etcd quorum is not negotiable.
- All cluster communication flows through the API Server. No exceptions.
- Scaling responds to load. Resilience responds to failure. They are not the same.

---

## 11. Anchors to Previous Modules

New concepts land better when mapped to things already understood:

| Previous Module | Concept | K8s Equivalent |
|----------------|---------|----------------|
| AWS | Availability Zones | Node distribution across failure domains |
| AWS | Auto Scaling Groups | HPA (Horizontal Pod Autoscaler) |
| AWS | ALB (Application Load Balancer) | Service (ClusterIP/LoadBalancer) + Ingress |
| Python | Flask Blueprints (modular routing) | Service abstraction (stable endpoint over pods) |
| Python/Linux | `.env` files | ConfigMap (non-secret) / Secret (sensitive) |
| Linux | systemd units (desired service state) | K8s controllers (reconciliation loop) |
| Coming: Jenkins | Master + Agents architecture | Control Plane + Worker Nodes (same pattern) |
| Coming: Ansible | Control Node + Managed Nodes | Control Plane + Worker Nodes (same pattern) |

The master/worker pattern appears everywhere in distributed systems. K8s is not unique - it's the clearest example.

---

## 12. Interview Questions

These are where Junior engineers get filtered. The instructor was explicit about this.

**Q: What is the difference between Control Plane and Data Plane?**
> Control Plane is the brain - it stores state (etcd), makes decisions (Scheduler), and runs reconciliation loops (Controller Manager). Data Plane is the muscle - worker nodes actually run the containers. They are physically and logically separated.

**Q: What does the Scheduler do?**
> The Scheduler watches for Pods that have been created but not yet assigned to a node. It selects the best node based on available resources, affinity rules, taints/tolerations, and other constraints. It writes the node assignment to etcd via the API Server but does NOT actually start the container - that is kubelet's job.

**Q: Why does etcd need an odd number of nodes?**
> etcd uses the Raft consensus protocol which requires a majority quorum (n/2 + 1 nodes) to commit a write. With even numbers, a 50/50 split produces no quorum and the cluster halts. With odd numbers (3, 5, 7), you can always tolerate (n-1)/2 failures while maintaining quorum.

**Q: What happens step-by-step when you run `kubectl apply`?**
> kubectl sends the manifest to the API Server. API Server authenticates, validates, and writes desired state to etcd. Controller Manager sees the new object and creates child objects (ReplicaSet creates Pods). Scheduler assigns unscheduled Pods to nodes. kubelet on each node starts the containers via the Container Runtime.

**Q: What is the difference between Controller Manager and Cloud Controller Manager?**
> Controller Manager runs the built-in controllers: ReplicaSet, Deployment, Job, Node, etc. - generic Kubernetes logic. Cloud Controller Manager handles cloud-provider-specific operations: provisioning a LoadBalancer on AWS, attaching an EBS volume, registering nodes with the cloud. Separating them allows K8s core to stay cloud-agnostic.

**Q: What is the difference between Scaling and Resilience in K8s?**
> Scaling (HPA) responds to load - it adds or removes pod replicas based on metrics like CPU utilization. Resilience (ReplicaSet, restart policies) responds to failure - it replaces crashed pods to maintain the desired count. You need both. Scaling is "can we handle more?" Resilience is "can we survive failure?"

**Q: When would you NOT use Kubernetes?**
> Simple applications (1-3 services), small teams without ops capacity, tight deadlines where infra complexity is a risk, or when a managed alternative (ECS, App Runner, Heroku) covers your requirements with less overhead. K8s complexity must be justified by the problems it solves.

---

## Course Materials

No external course materials were found at the expected source paths during repo restructure (2026-06-07):
- `E:\Genspark\DevOps-Materials\K8s` - not found
- `C:\Users\David\Desktop\Kubeinertis` - not found

When materials become available, copy them to `09-kubernetes/resources/` with this structure:
- `.pdf`, `.pptx` → `resources/slides/`
- `.png`, `.jpg`, `.jpeg`, `.svg`, `.gif` → `resources/images/`
- `.yaml`, `.yml` → `resources/examples/`
- `.md` notes → `resources/notes/`
- `.sh` scripts → `resources/scripts/`
