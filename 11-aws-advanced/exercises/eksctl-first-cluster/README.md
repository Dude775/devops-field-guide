# EKS Cluster with eksctl

## Objective
Provision a fully working Amazon EKS cluster from scratch using `eksctl`, verify the
control plane and worker nodes are healthy, demonstrate scaling the node group up and
back down, and then tear everything down cleanly so no cost-bearing resources are left
running. The whole lifecycle (create → verify → scale → destroy) is captured with proof
files in `images/`.

## Cluster Specs
| Setting | Value |
| --- | --- |
| AWS Account | 450963613786 |
| IAM User | Drubin-1 (admin) |
| Region | eu-central-1 |
| Cluster name | drubin-test-cluster |
| Node group | linux-nodes |
| Instance type | t3.small |
| Node count | 2 (scaled to 3 then back to 2 in the scaling demo) |
| Kubernetes version | 1.30 |
| eksctl version | 0.227.0 |

> **Why t3.small and not t2.micro?** `t2.micro` only supports `max-pods=4`, which is not
> enough headroom for the EKS system pods (CoreDNS, kube-proxy, aws-node) plus any
> workload. `t3.small` gives the ENI/pod density EKS needs.

## Commands Used
Pre-flight:
```bash
aws sts get-caller-identity
eksctl version
kubectl version --client
aws eks list-clusters --region eu-central-1
```

Create:
```bash
eksctl create cluster --name drubin-test-cluster --version 1.30 --region eu-central-1 \
  --nodegroup-name linux-nodes --node-type t3.small --nodes 2
```

Verify:
```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl cluster-info
eksctl get cluster --region eu-central-1
eksctl get nodegroup --cluster drubin-test-cluster --region eu-central-1
```

Scale (up to 3, then back to 2):
```bash
eksctl scale nodegroup --cluster drubin-test-cluster --name linux-nodes \
  --nodes 3 --nodes-min 1 --nodes-max 5 --region eu-central-1
eksctl scale nodegroup --cluster drubin-test-cluster --name linux-nodes \
  --nodes 2 --nodes-min 1 --nodes-max 5 --region eu-central-1
```

Teardown + verification:
```bash
eksctl delete cluster --name drubin-test-cluster --region eu-central-1
aws eks list-clusters --region eu-central-1
aws ec2 describe-instances --region eu-central-1 \
  --filters "Name=tag:alpha.eksctl.io/cluster-name,Values=drubin-test-cluster" \
  --query 'Reservations[].Instances[?State.Name!=`terminated`]'
aws cloudformation list-stacks --region eu-central-1 --stack-status-filter DELETE_COMPLETE \
  --query "StackSummaries[?contains(StackName, 'drubin-test-cluster')].StackName"
```

## Verification
Two `t3.small` worker nodes came up Ready, running Kubernetes `v1.30.14-eks` on Amazon
Linux 2023 (full output in `images/02-nodes.txt`):

```
NAME                                              STATUS   ROLES    AGE   VERSION
ip-192-168-18-29.eu-central-1.compute.internal    Ready    <none>   20m   v1.30.14-eks-93b80c6
ip-192-168-83-199.eu-central-1.compute.internal   Ready    <none>   20m   v1.30.14-eks-93b80c6
```

All system pods (`aws-node`, `coredns`, `kube-proxy`, `metrics-server`) reached Running
(`images/03-system-pods.txt`). Control plane reachable (`images/04-cluster-info.txt`):

```
Kubernetes control plane is running at https://DE1E7BED8A55D290F94396E11290669D.gr7.eu-central-1.eks.amazonaws.com
CoreDNS is running at https://DE1E7BED8A55D290F94396E11290669D.gr7.eu-central-1.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

Scaling demo: node group went 2 → 3 (third node reached Ready in ~1 min,
`images/08-nodes-after-scale.txt`) then back to 2.

## Teardown Proof
After `eksctl delete cluster`, all three resource classes confirmed gone:

- **EKS clusters** in eu-central-1 (`images/11-teardown-proof.txt`):
  ```json
  { "clusters": [] }
  ```
- **Non-terminated EC2** tagged for the cluster (`images/12-no-ec2.txt`):
  ```json
  []
  ```
- **CloudFormation stacks** — both `DELETE_COMPLETE` (`images/13-cfn-deleted.txt`):
  ```json
  [
    "eksctl-drubin-test-cluster-nodegroup-linux-nodes",
    "eksctl-drubin-test-cluster-cluster"
  ]
  ```

## Lessons Learned
- **Pre-commit hook needed gitleaks.** The global `pre-commit` hook runs
  `gitleaks protect --staged` but gitleaks wasn't installed, so it failed closed and
  blocked every commit with a misleading "secrets detected" message. Fixed by installing
  the gitleaks binary to a user-level PATH dir (no `--no-verify` bypass).
- **Control plane deletes asynchronously.** `eksctl delete cluster` returns "all cluster
  resources were deleted" while the EKS control plane is still in `DELETING`. Right after,
  `aws eks list-clusters` still listed the cluster. Had to poll `list-clusters` until it
  returned `[]` (~2–3 min) before teardown was truly complete.
- **`describe-stacks` by name 404s on deleted stacks.** Confirming a deleted CFN stack via
  `describe-stacks --stack-name` errors with "does not exist" — that's expected; use
  `list-stacks --stack-status-filter DELETE_COMPLETE` to prove deletion instead.
- **t3.small over t2.micro** — t2.micro caps at `max-pods=4`, too few for EKS system pods.
- **Long-running ops run in the background.** Cluster create (~13 min) and delete (~7 min)
  exceed the foreground command timeout, so they were run as background jobs and monitored.

## Cost Summary
| Metric | Value |
| --- | --- |
| Cluster create start | 2026-06-24 14:17:40 |
| Teardown fully verified | 2026-06-24 ~15:37 |
| Total billable runtime | ~79 minutes |
| Approx. rate | ~$0.20/hour (EKS control plane $0.10/hr + 2× t3.small) |
| **Estimated cost** | **79 / 60 × $0.20 ≈ $0.26** |

Actual hands-on operations were shorter (create ~13.4 min, delete ~7 min); the remainder
of the 79 min is the cluster sitting idle between automated steps. The control plane is the
fixed cost driver, so the practical lesson is: **create, prove it works, tear down fast.**
