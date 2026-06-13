# kubectl Reference

> Work in progress - commands added as covered in class

---

## Cluster Info

```bash
# current context
kubectl config current-context

# list all contexts
kubectl config get-contexts

# switch context
kubectl config use-context <context-name>

# cluster info
kubectl cluster-info

# list nodes
kubectl get nodes
kubectl get nodes -o wide
```

---

## Combined Resource Queries

```bash
# full cluster snapshot - pods, services, deployments, replicasets in one shot
kubectl get pods,svc,deploy,rs -o wide

# same but for all resource types kubectl knows about
kubectl get all -o wide

# useful pre-lab baseline check: run this before starting any lab
kubectl get pods,svc,deploy,rs -o wide
```

`-o wide` adds the IP address and Node columns for pods. Saves you a separate `kubectl describe` when you just need to know which node a pod landed on.

---

## Pod Commands

```bash
# list pods
kubectl get pods
kubectl get pods -o wide          # +IP and Node columns
kubectl get pods --show-labels    # display labels
kubectl get pods -w               # watch mode - real-time changes

# create a pod (imperative)
kubectl run nginx --image=nginx:1.27.0

# pod details
kubectl describe pod <name>

# container logs
kubectl logs <pod-name>
kubectl logs <pod-name> -f        # follow/stream logs
kubectl logs <pod-name> -c <container>  # multi-container pod

# interactive shell
kubectl exec -it <pod-name> -- sh
kubectl exec -it <pod-name> -- bash

# full pod spec (including K8s-managed fields)
kubectl get pod <name> -o yaml

# delete a pod
kubectl delete pod <name>
```

---

## ReplicaSet Commands

```bash
# list ReplicaSets
kubectl get rs

# detailed view with Events
kubectl describe rs <name>

# manual scaling
kubectl scale rs <name> --replicas=N

# remove RS and all owned Pods
kubectl delete rs <name>
```

---

## Deployment Commands

```bash
# list deployments
kubectl get deploy

# detailed view - shows strategy + Events
kubectl describe deployment <name>

# watch rollout progress
kubectl rollout status deployment/<name>

# list revision history
kubectl rollout history deployment/<name>

# rollback to previous revision
kubectl rollout undo deployment/<name>

# rollback to specific revision
kubectl rollout undo deployment/<name> --to-revision=N

# pause a rollout
kubectl rollout pause deployment/<name>

# resume a paused rollout
kubectl rollout resume deployment/<name>

# tag a revision for history readability
kubectl annotate deployment/<name> kubernetes.io/change-cause="message here"

# scale a deployment
kubectl scale deployment <name> --replicas=N
```

---

## Service Commands

```bash
# list services
kubectl get svc
kubectl get services

# service details
kubectl describe svc <name>

# expose a pod as a service (imperative)
kubectl expose pod <name> --port=80 --type=ClusterIP

# delete a service
kubectl delete svc <name>
```

---

## Debugging & Inspection

```bash
# watch mode for real-time changes
kubectl get pods -w

# show IP and Node columns
kubectl get pods -o wide

# display labels
kubectl get pods --show-labels

# container logs
kubectl logs <pod>
kubectl logs <pod> -f             # stream

# interactive shell into container
kubectl exec -it <pod> -- sh

# full Pod spec (including K8s-managed fields)
kubectl get pod <pod> -o yaml

# preview changes before applying
kubectl diff -f file.yaml

# all objects in namespace
kubectl get all
```

---

## Manifest Generation (dry-run)

```bash
# generate pod manifest
kubectl run <name> --image=<img> --dry-run=client -o yaml > pod.yaml

# generate pod with custom labels (default is run:<name>, not app:<name>)
kubectl run <name> --image=<img> --labels=app=<name> --dry-run=client -o yaml > pod.yaml

# generate service from existing pod
kubectl expose pod <name> --type=NodePort --port=80 --dry-run=client -o yaml > svc.yaml

# generate service with custom name (default is same as pod name)
kubectl expose pod <name> --name=<svc-name> --type=NodePort --port=80 --dry-run=client -o yaml > svc.yaml

# generate deployment manifest
kubectl create deployment <name> --image=<img> --replicas=3 --dry-run=client -o yaml > deploy.yaml

# generate configmap from literal values
kubectl create configmap <name> --from-literal=KEY=VALUE --dry-run=client -o yaml > cm.yaml

# generate job manifest
kubectl create job <name> --image=<img> --dry-run=client -o yaml > job.yaml
```

### dry-run flags

| Flag | Behavior |
|------|----------|
| `--dry-run=client` | Validates locally in kubectl only. Nothing sent to API server. Faster. Safe on any cluster. |
| `--dry-run=server` | Sends to API server for validation but doesn't persist. Catches admission webhook errors, quota limits, name conflicts. |
| `-o yaml` | Output manifest as YAML to stdout. Combine with `>` to save to file. |
| `-o json` | Output as JSON instead. Useful if you need to pipe to `jq`. |

### workflow

```
generate → cat (verify) → edit (clean up + add fields) → kubectl apply -f
```

### noise fields to clean up before committing

- `creationTimestamp: null` - not set until object is created
- `resources: {}` - add limits/requests or remove
- `status: {}` / `status: { loadBalancer: {} }` - always empty in a manifest
- `dnsPolicy: ClusterFirst` - default, safe to remove if you're not changing it

---

## Minikube

```bash
# start local cluster (Docker Desktop must be running first)
minikube start

# check minikube status
minikube status

# stop the cluster
minikube stop

# get the node IP (for NodePort access from host)
minikube ip
```

> If `kubectl cluster-info` returns `connection refused`, check `docker ps` first. If the minikube container is missing, the cluster is down - run `minikube start`.

---

## Apply / Create / Delete

```bash
# create or update (idempotent - use this always)
kubectl apply -f file.yaml

# apply all YAMLs in a directory
kubectl apply -f ./manifests/

# create only - fails if exists
kubectl create -f file.yaml

# create and write last-applied annotation (so apply works cleanly after)
kubectl create -f file.yaml --save-config

# full overwrite - breaks with managed fields
kubectl replace -f file.yaml

# delete objects defined in file
kubectl delete -f file.yaml

# delete multiple objects by file in one command
kubectl delete -f file1.yaml -f file2.yaml

# preview what will change
kubectl diff -f file.yaml
```

---

## create vs apply: Quick Comparison

| | `kubectl create` | `kubectl apply` |
|--|-----------------|-----------------|
| Writes `last-applied-configuration` | No (add `--save-config` to force it) | Yes, always |
| Idempotent | No - errors if object exists | Yes - updates if exists |
| 3-way merge on update | No | Yes |
| Use for one-off imperative ops | Yes | Overkill |
| Use for GitOps / declarative workflow | No | Yes |

When migrating a `create`-d object to `apply`, the first `apply` triggers a warning and backfills the annotation automatically. After that it's fully declarative. See [Lab 4.6](../exercises/04.6-create-to-apply-migration.md) for the full walkthrough.

---

## Label & Selector Queries

```bash
# show labels on pods
kubectl get pods --show-labels

# filter pods by label
kubectl get pods -l app=nginx

# filter pods by label (equality)
kubectl get pods -l app=nginx,tier=frontend

# show labels on all resource types
kubectl get all --show-labels
```

---

## Ephemeral Debug Pods

```bash
# launch temporary Alpine pod with interactive shell
kubectl run tmp-alpine --rm -it --image=alpine --restart=Never -- sh

# launch temporary busybox pod
kubectl run tmp-busybox --rm -it --image=busybox --restart=Never -- sh

# one-off command without interactive shell
kubectl run tmp-curl --rm -it --image=curlimages/curl --restart=Never -- curl -I http://nginx-svc:80
```

`--rm` - deletes the pod when you exit  
`--restart=Never` - prevents K8s from restarting it (keeps it as a plain Pod, not a Job)

---

## Service YAML Authoring (heredoc, Git Bash)

```bash
# safe way to author YAML - avoids VS Code workspace path bugs
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

# always verify before applying
cat nginx-svc.yaml
wc -l nginx-svc.yaml
```

> WARNING: heredoc syntax (`<< 'EOF'`) is Bash only. It fails in PowerShell with `The '<' operator is reserved for future use`. Use Git Bash.
