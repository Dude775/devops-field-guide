# Hands-On 7.3 - Service DNS Across Namespaces

## Goal

Prove that a Pod in one namespace can reach a Service in a different namespace using the Kubernetes DNS FQDN format: `<service-name>.<namespace>.svc.cluster.local`.

---

## Files

| File | Purpose |
|------|---------|
| `dev-ns.yaml` | Creates the `dev` Namespace |
| `color-api.yaml` | Deploys color-api Pod into `dev` |
| `color-api-service.yaml` | ClusterIP Service for color-api in `dev` |
| `traffic-generator.yaml` | Pod in `default` that calls the dev Service by FQDN |
| `outputs/` | Terminal captures from each step |

---

## Steps

### 1. Create the dev Namespace

```bash
kubectl apply -f dev-ns.yaml
```

Output: `outputs/01-apply-namespace.txt`

---

### 2. Deploy color-api Pod and Service into dev, traffic-generator into default

```bash
kubectl apply -f color-api.yaml
kubectl apply -f color-api-service.yaml
kubectl apply -f traffic-generator.yaml
```

Output: `outputs/02-apply-resources.txt`

`traffic-generator.yaml` has no `namespace` field — it lands in `default`.  
`color-api.yaml` and `color-api-service.yaml` both specify `namespace: dev`.

---

### 3. Verify resources

```bash
kubectl get pods          # default: traffic-generator
kubectl get pods -n dev   # dev: color-api
kubectl get svc -n dev    # dev: color-api ClusterIP
```

Output: `outputs/03-pods-default.txt`, `outputs/04-dev-resources.txt`

---

### 4. Check traffic-generator logs

```bash
kubectl logs traffic-generator
```

Output: `outputs/05-traffic-generator-logs.txt`

The logs showed HTTP responses from `http://color-api.dev.svc.cluster.local/api`. Cross-namespace DNS worked.

---

### 5. Cleanup

```bash
kubectl delete -f .
```

Output: `outputs/07-cleanup.txt`, `outputs/08-pods-default-after-cleanup.txt`, `outputs/09-dev-namespace-after-cleanup.txt`

All resources including the `dev` Namespace were removed.

---

## Key Concept: Service DNS Format

```
<service-name>.<namespace>.svc.cluster.local
```

| Part | Value in this lab |
|------|------------------|
| service-name | `color-api` |
| namespace | `dev` |
| cluster domain | `cluster.local` |
| Full FQDN | `color-api.dev.svc.cluster.local` |

Within the same namespace you can use just the service name. Across namespaces, the FQDN is required.

---

## Conclusion

Kubernetes CoreDNS resolves FQDNs for Services across namespaces. A Pod in `default` can reach a Service in `dev` as long as it uses the full `service.namespace.svc.cluster.local` format. This is the standard pattern for cross-namespace communication without exposing Services externally.
