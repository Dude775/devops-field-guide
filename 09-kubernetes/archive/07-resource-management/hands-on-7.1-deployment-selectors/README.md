# Hands-On 7.1 - Deployment Selectors

> **Status**: done
> **Environment**: Minikube (Windows), kubectl

---

## Goal

Understand how a Deployment's `selector` block works — specifically the difference between `matchLabels` and `matchExpressions` — and verify that the Deployment can only manage Pods whose labels satisfy both conditions.

---

## Files

```
.
├── color-deploy.yaml    # Deployment with matchLabels + matchExpressions selector
└── outputs/
    ├── 01-cleanup-previous-lab.txt
    ├── 02-apply-deployment.txt
    ├── 03-deployment-wide.txt
    ├── 04-pods-labels-wide.txt
    ├── 05-describe-deployment.txt
    ├── 06-pods-tier-managed.txt
    ├── 07-color-api-pods-labels.txt
    ├── 08-deployment-yaml.txt
    ├── 09-files-created.txt
    ├── 10-lab-conclusion.txt
    ├── 11-final-proof.txt
    └── 12-final-files-created.txt
```

---

## Deployment Selector Structure

`color-deploy.yaml` defines a Deployment with a combined selector:

```yaml
selector:
  matchLabels:
    app: color-api
    environment: local
    tier: backend
  matchExpressions:
    - key: managed
      operator: Exists
```

The Pod template labels must satisfy **all** conditions — both `matchLabels` and `matchExpressions` — or the Deployment cannot claim those Pods.

Pod template labels:

```yaml
labels:
  app: color-api
  environment: local
  tier: backend
  managed: deployment   # required for the Exists operator
```

---

## matchLabels Explanation

`matchLabels` is exact key=value matching. Every pair listed must be present on the Pod with the exact value specified.

```yaml
matchLabels:
  app: color-api       # Pod must have app=color-api
  environment: local   # Pod must have environment=local
  tier: backend        # Pod must have tier=backend
```

This is equivalent to writing three equality-based selectors with AND logic.

---

## matchExpressions Explanation

`matchExpressions` supports more advanced conditions using operators. Each expression specifies a `key`, an `operator`, and optionally a list of `values`.

| Operator | Meaning |
|----------|---------|
| `In` | Label value must be in the provided list |
| `NotIn` | Label value must not be in the provided list |
| `Exists` | Label key must exist (any value, or no value) |
| `DoesNotExist` | Label key must not be present |

The YAML includes commented examples for `NotIn`, `In`, and `DoesNotExist` — only the `Exists` example is active.

---

## Exists Operator Behavior

```yaml
matchExpressions:
  - key: managed
    operator: Exists
```

This means: the Pod must have a label with key `managed`. The value does not matter — only the key must be present.

The Pod template sets `managed: deployment`. The key exists, so the condition is satisfied.

If a Pod did not have the `managed` label at all, the Deployment's selector would not match it — even if all `matchLabels` conditions were satisfied.

---

## Commands Used

```bash
# Clean up from previous lab
kubectl delete pod color-backend color-frontend

# Apply the Deployment
kubectl apply -f color-deploy.yaml

# Check Deployment status
kubectl get deployment -o wide

# See Pods with label columns
kubectl get pods -L app,environment,tier,managed -o wide

# Describe the Deployment (shows full selector)
kubectl describe deployment color-api-deployment

# Filter using -L to confirm tier and managed labels
kubectl get pods -L tier,managed
```

---

## Observed Result

Deployment created 3 Pods successfully:

```
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE   SELECTOR
color-api-deployment   3/3     3            3           6s    app=color-api,environment=local,managed,tier=backend
```

All 3 Pods include the required labels:

```
NAME                                    READY   STATUS    TIER      MANAGED
color-api-deployment-7c78664cc8-57grl   1/1     Running   backend   deployment
color-api-deployment-7c78664cc8-dd5p5   1/1     Running   backend   deployment
color-api-deployment-7c78664cc8-rcrrz   1/1     Running   backend   deployment
```

`kubectl describe` confirmed the full selector:

```
Selector: app=color-api,environment=local,managed,tier=backend
```

The `managed` entry appears without a value in the selector display — this reflects the `Exists` operator (key must exist, any value).

---

## Note: No Extra Manual Pod

The course spec for this lab focuses on the Deployment and its selector behavior. No additional manual Pod was created to test orphan adoption or selector rejection. The lab stayed aligned with the course material — the goal was to understand selector structure, not edge-case adoption behavior.

---

## Final Proof

Color API Pods only — filtered with label columns:

```
NAME                                    READY   STATUS    TIER      MANAGED
color-api-deployment-7c78664cc8-57grl   1/1     Running   backend   deployment
color-api-deployment-7c78664cc8-dd5p5   1/1     Running   backend   deployment
color-api-deployment-7c78664cc8-rcrrz   1/1     Running   backend   deployment
```

All 3 Pods show `tier=backend` and `managed=deployment` — the exact labels required by the selector.

---

## Conclusion

| Concept | Summary |
|---------|---------|
| `matchLabels` | Exact key=value AND conditions — all must match |
| `matchExpressions` | Advanced conditions: `In`, `NotIn`, `Exists`, `DoesNotExist` |
| `Exists` operator | Pod must have the label key — value is irrelevant |
| Selector + template contract | Pod template labels must satisfy the selector or the Deployment cannot manage the Pods |

The selector is a contract: if the template doesn't satisfy its own Deployment's selector, Kubernetes rejects the manifest at apply time. This prevents a Deployment from creating Pods it can never claim.
