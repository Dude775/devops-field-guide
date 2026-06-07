# Cluster State Verification Workflow

> **Date**: 2026-06-07
> **Module**: 09 - Kubernetes
> **Status**: Reference doc - applies before every lab

---

## Overview

Before starting any lab, spend 60 seconds verifying your environment. It prevents wasted time debugging something that was never actually a problem with the lab.

This is not paranoia. Kubernetes is stateful. If you left a Pod running from yesterday, a `kubectl apply -f .` today might silently interact with it. If your context is pointing at the wrong cluster, you're doing real work against the wrong environment.

The routine is always the same four steps.

---

## The Four-Step Routine

### Step 1: Where am I?

```bash
pwd
```

Never assume. If you closed your terminal and reopened it, you're probably in your home directory, not in the lab folder. A `kubectl apply -f .` in the wrong directory can apply completely unrelated YAMLs.

### Step 2: What's here?

```bash
ls -la
```

Confirm the directory contains what you expect. Hidden files (`-a`) matter - `.gitignore`, leftover temp files, etc.

If you're at the repo root, navigate first:

```bash
cd ~/Desktop/Kubeinertis/day03
ls -la
```

Confirm you see `images/`, `labs/`, `manifests/`.

### Step 3: Which cluster am I pointing at?

```bash
kubectl config current-context
```

Expected output for local minikube work:

```
minikube
```

If this says something else (a cloud cluster, a staging context), stop. Switch context before proceeding:

```bash
kubectl config use-context minikube
```

### Step 4: What is actually running?

```bash
kubectl get pods,svc,deploy,rs -o wide
```

One query that shows the full picture: Pods, Services, Deployments, and ReplicaSets, with node and IP columns. Run this before every lab so you know the baseline.

You're looking for:
- Are there lingering objects from a previous lab that should have been cleaned up?
- Is the cluster in a state consistent with what I expect going into this lab?
- Are there objects in an error state (`ErrImagePull`, `CrashLoopBackOff`) I need to address first?

---

## Worked Example: Session Start on 2026-06-07

This is the actual output from the start of the Day03 session after Lab 4.6 teardown.

### Context check

```bash
kubectl config current-context
# minikube
```

### Directory check

```bash
pwd
# /c/Users/<user>/Desktop/Kubeinertis/day03

ls -la
# total 0
# drwxr-xr-x 1 user user ... .
# drwxr-xr-x 1 user user ... ..
# drwxr-xr-x 1 user user ... images
# drwxr-xr-x 1 user user ... labs
# drwxr-xr-x 1 user user ... manifests
```

Three directories: `images/`, `labs/`, `manifests/`. No stray YAML files at the root.

### Labs folder structure

```bash
ls -la labs/
# 04.2-nodeport-service/
# 04.3-dry-run-yaml/
# 04.4-imperative-replace-limits/
# 04.5-declarative-apply/
# 04.6-create-to-apply-migration/
```

Each lab has its own isolated folder. No files loose between folders.

See screenshot: `../resources/images/lab-4.6/01-labs-folder-structure.png`

### Cluster state

```bash
kubectl get pods,svc,deploy,rs -o wide
```

```
NAME                                            READY   STATUS    RESTARTS   AGE
pod/color-api-deployment-77946bd689-2xddt       1/1     Running   0          ...
pod/color-api-deployment-77946bd689-q45zm       1/1     Running   0          ...
pod/color-api-deployment-77946bd689-xj88f       1/1     Running   0          ...
pod/rogue-pod                                   1/1     Running   0          ...

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   ...

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/color-api-deployment   3/3     3            3           ...

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/color-api-deployment-77946bd689  3         3         3       ...
replicaset.apps/color-api-deployment-7c78664cc8  0         0         0       ...
```

Reading this output:
- `color-api-deployment` with 3/3 pods running - expected, this is the persistent workload from Day03 exercises
- `rogue-pod` - standalone pod, expected (not managed by the deployment)
- `service/kubernetes` - the internal K8s API service, always present
- Active RS (`77946bd689`) - image `idf775/color-api:1.1.0`, 3 replicas
- Old RS (`7c78664cc8`) - image `lironefitoussi/color-api:1.1.0`, 0 replicas - this is rollback history from a previous image update
- No `nginx-pod` or `nginx-svc` - confirms Lab 4.6 teardown was clean

See screenshot: `../resources/images/lab-4.6/00-cluster-context-and-get.png`

**Assessment**: cluster is in expected state. Safe to proceed.

---

## Why Combined get (`pods,svc,deploy,rs`)

You could run four separate commands. One is faster and gives you the full picture in context:

```bash
# Instead of this:
kubectl get pods
kubectl get svc
kubectl get deployments
kubectl get rs

# Do this:
kubectl get pods,svc,deploy,rs -o wide
```

`-o wide` adds IP addresses and the Node column for pods. Useful when debugging network issues or confirming which node a pod landed on.

---

## The Lab Folder Isolation Rule

Each lab gets its own folder:

```
labs/
  04.2-nodeport-service/
  04.3-dry-run-yaml/
  04.4-imperative-replace-limits/
  04.5-declarative-apply/
  04.6-create-to-apply-migration/
```

Why this matters:

- `kubectl apply -f .` in `04.6-create-to-apply-migration/` applies only the YAMLs in that folder
- If you mix files from different labs, a single `apply -f .` applies everything - unintended side effects
- Each lab folder is self-contained: copy in the YAMLs you need, work in isolation, teardown at the end

Rule: never mix YAML files between lab folders. If a lab builds on a previous one, copy the files you need into the new folder.

---

## Cat + wc Before Every Apply

One more habit worth building:

```bash
# Before any apply or create:
wc -l nginx-pod.yaml   # sanity check - file has content
cat nginx-pod.yaml     # read what you're actually applying
```

This catches:
- Empty files (redirect went to the wrong file, or `>` was missing)
- Stale files from a previous lab you forgot to update
- YAML that looks right but has a wrong image tag or label

`wc -l` first (fast, catches empty file), then `cat` to actually read it.

---

## Checklist

Before each lab:

- [ ] `pwd` - confirm you're in the right directory
- [ ] `ls -la` - confirm directory contents match expectations
- [ ] `kubectl config current-context` - confirm correct cluster
- [ ] `kubectl get pods,svc,deploy,rs -o wide` - baseline cluster state
- [ ] `cat <file>.yaml` + `wc -l <file>.yaml` before every apply/create
