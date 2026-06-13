# Hands-On 7.2 - Namespaces

## Goal

Understand how Kubernetes Namespaces isolate resources, how to target a specific namespace with `kubectl`, and what happens when a Namespace is deleted.

---

## Files

| File | Purpose |
|------|---------|
| `dev-ns.yaml` | Creates the `dev` Namespace |
| `color-api.yaml` | Deploys a Pod into the `dev` Namespace |
| `outputs/` | Terminal captures from each step |

---

## Steps

### 1. Create the dev Namespace

```bash
kubectl apply -f dev-ns.yaml
kubectl get namespaces
```

Output: `outputs/01-apply-namespace.txt`, `outputs/02-namespaces.txt`

The `dev` Namespace appeared alongside `default`, `kube-system`, `kube-public`, and `kube-node-lease`.

---

### 2. Check existing Pods before creating the dev Pod

```bash
kubectl get pods          # default namespace
kubectl get pods -n kube-system
```

Output: `outputs/03-pods-default-before-dev-pod.txt`, `outputs/04-pods-kube-system.txt`

> Real observation: the `default` namespace already had Pods from previous labs. The output was not empty — this was expected.

---

### 3. Deploy color-api Pod into dev

```bash
kubectl apply -f .
```

Output: `outputs/05-apply-all.txt`

The `color-api.yaml` targets `namespace: dev` explicitly. Applying from the default context placed the Pod in `dev`, not `default`.

---

### 4. Verify Pod is in dev, not default

```bash
kubectl get pods -n dev
kubectl get pods          # should not show color-api
```

Output: `outputs/06-pods-dev.txt`, `outputs/07-pods-default-after-dev-pod.txt`

Pod was visible only in `dev`. The `default` namespace retained its previous Pods but `color-api` was not there.

---

### 5. Describe fails without -n

```bash
kubectl describe pod color-api
# Error: pod not found in default namespace
```

Output: `outputs/08-describe-without-namespace-fails.txt`

Without `-n dev`, kubectl looked in `default` and returned an error. This confirms namespace isolation is real.

---

### 6. Change current context namespace to dev

```bash
kubectl config set-context --current --namespace=dev
kubectl config view --minify
kubectl get pods
```

Output: `outputs/09-current-context.txt`, `outputs/10-set-context-dev.txt`, `outputs/11-pods-after-context-dev.txt`, `outputs/12-describe-after-context-dev.txt`, `outputs/13-config-view-current-context.txt`

After switching context, `kubectl get pods` without `-n` showed the `color-api` Pod in `dev`.

---

### 7. List all Pods across all namespaces

```bash
kubectl get pods -A
```

Output: `outputs/14-pods-all-namespaces-before-delete.txt`

Showed Pods in `default`, `dev`, and `kube-system` in one view.

---

### 8. Delete the dev Namespace

```bash
kubectl config set-context --current --namespace=default
kubectl delete namespace dev
```

Output: `outputs/15-set-context-default.txt`, `outputs/16-delete-namespace.txt`

> Important: Deleting a Namespace deletes all resources inside it — Pods, Services, ConfigMaps, and everything else scoped to that Namespace. There is no partial delete.

Context was restored to `default` before deletion.

---

## Key Concepts

- Namespaces are a way to partition a cluster into virtual sub-clusters.
- `-n <namespace>` is required if you are not operating in the target namespace.
- `kubectl config set-context --current --namespace=<ns>` changes the default namespace for the current context.
- `kubectl get pods -A` shows all Pods across all namespaces.
- Deleting a Namespace is irreversible and cascading.

---

## Conclusion

Namespaces isolate resources and kubectl commands. If you forget `-n`, you are operating on the wrong namespace — and kubectl will tell you the resource does not exist. Always verify your active context with `kubectl config view --minify`.
