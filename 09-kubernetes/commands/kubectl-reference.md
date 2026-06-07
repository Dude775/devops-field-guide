# kubectl Reference

> Work in progress - commands added as covered in class

---

## Cluster Info

```bash
# current context
kubectl config current-context

# list all contexts
kubectl config get-contexts

# cluster info
kubectl cluster-info

# list nodes
kubectl get nodes
kubectl get nodes -o wide
```

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

## Manifest Generation

```bash
# generate pod manifest
kubectl run <name> --image=<img> --dry-run=client -o yaml > pod.yaml

# generate service manifest
kubectl expose pod <name> --port=N --dry-run=client -o yaml > svc.yaml

# generate deployment manifest
kubectl create deployment <name> --image=<img> --dry-run=client -o yaml > deploy.yaml
```

`--dry-run=client` - simulates locally, nothing hits the API server  
`-o yaml` - outputs the result as YAML

---

## Apply / Create / Delete

```bash
# create or update (idempotent - use this always)
kubectl apply -f file.yaml

# apply all YAMLs in a directory
kubectl apply -f ./manifests/

# create only - fails if exists
kubectl create -f file.yaml

# full overwrite - breaks with managed fields
kubectl replace -f file.yaml

# delete objects defined in file
kubectl delete -f file.yaml

# preview what will change
kubectl diff -f file.yaml
```

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
