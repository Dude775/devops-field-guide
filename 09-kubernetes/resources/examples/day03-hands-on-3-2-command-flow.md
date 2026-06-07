# Day 03 Hands-On 3.2 - Command Flow (Reproducible)

> Clean command sequence for repeating the lab from scratch.
> Environment: Windows PowerShell + minikube (Docker driver)

---

## Pre-flight

```powershell
# verify cluster is up
minikube status
kubectl get nodes
```

---

## Step 1 - Create nginx Pod

```powershell
kubectl run nginx --image=nginx:1.27.0
kubectl get pods -o wide
# note the nginx Pod IP - e.g. 10.244.0.5
```

---

## Step 2 - Inspect nginx Pod

```powershell
kubectl describe pod nginx
# look at: Pod IP, Image, Events section
```

---

## Step 3 - Try accessing from Windows Host (expect timeout)

```powershell
curl.exe --max-time 5 http://10.244.0.5
# expected: operation timed out
```

---

## Step 4 - Create Alpine Pod and test Pod-to-Pod communication

```powershell
# opens interactive shell inside Alpine
kubectl run alpine -it --image=alpine:3.20 -- sh
```

Inside Alpine:

```sh
apk update
apk add curl

# test Pod-to-Pod by IP (replace IP with actual nginx Pod IP)
curl 10.244.0.5
# expected: HTML response from nginx

# test DNS by name (PENDING - run this too)
curl nginx
# expected without Service: curl: (6) Could not resolve host: nginx

exit
```

---

## Step 5 - Read logs

```powershell
kubectl logs nginx
# expected: access log line showing Alpine IP
```

---

## Cleanup

```powershell
kubectl delete pod alpine --ignore-not-found
kubectl get pods
# only nginx should remain
```

---

## Optional - Full cleanup

```powershell
kubectl delete pod nginx
kubectl get pods
# No resources found
```
