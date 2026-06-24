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
_Filled in during Phase 6._

## Verification
_Filled in during Phase 6._

## Teardown Proof
_Filled in during Phase 6._

## Lessons Learned
_Filled in during Phase 6._

## Cost Summary
_Filled in during Phase 6._
