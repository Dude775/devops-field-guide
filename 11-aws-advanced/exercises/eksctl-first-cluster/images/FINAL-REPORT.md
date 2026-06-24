# Lab Run - Final Report

## What Was Proven
A complete, cost-controlled EKS cluster lifecycle was executed end-to-end on AWS account
450963613786 (user Drubin-1) in eu-central-1. Using `eksctl`, a Kubernetes 1.30 cluster
named `drubin-test-cluster` was provisioned with a 2-node `t3.small` managed node group,
verified healthy (nodes Ready, all system pods Running, control plane reachable),
demonstrated elastic scaling (2 → 3 → 2 nodes), and then fully torn down. Teardown was
proven complete against three independent signals: the EKS cluster list, EC2 instance
state, and CloudFormation stack status — all confirming zero residual cost-bearing
resources. Two Terraform foundation labs (`local_file` and AWS provider wiring) were also
documented as part of the same run.

## Commits
```
02f4c07 lab docs
a5174e1 teardown verified
b1a2de0 docs 02-aws-provider
5d33511 docs 01-local-file
e2b4a20 scaled back
ba1fd1c scaled to 3
dc894bf verify nodes
1e0634f cluster up
f7fdd9a lab skeleton
cc36219 pre-flight ok
```
(10 commits this run; see `FINAL-COMMITS.txt` for surrounding history.)

## Proof Files
All in `images/`:
- `00-preflight.txt` — identity, eksctl/kubectl versions, empty cluster list
- `01-cluster-create.log` — full `eksctl create cluster` output
- `02-nodes.txt` — `kubectl get nodes -o wide` (2 nodes Ready)
- `03-system-pods.txt` — `kubectl get pods -A` (all Running)
- `04-cluster-info.txt` — `kubectl cluster-info`
- `05-cluster-list.txt` — `eksctl get cluster`
- `06-nodegroup.txt` — `eksctl get nodegroup`
- `07-scaled-up.txt` — scale to 3 initiation
- `08-nodes-after-scale.txt` — 3 nodes Ready
- `09-scaled-back.txt` — scale back to 2
- `10-delete.log` — full `eksctl delete cluster` output
- `11-teardown-proof.txt` — `aws eks list-clusters` → `[]`
- `12-no-ec2.txt` — non-terminated EC2 → `[]`
- `13-cfn-deleted.txt` — both CFN stacks `DELETE_COMPLETE`
- `FINAL-COMMITS.txt` — git log
- `FINAL-REPORT.md` — this file

## Final AWS State
- EKS clusters in eu-central-1: **0**
- EC2 instances tagged for drubin-test-cluster (non-terminated): **0**
- CloudFormation stacks for drubin-test-cluster: **deleted** (both
  `eksctl-drubin-test-cluster-nodegroup-linux-nodes` and
  `eksctl-drubin-test-cluster-cluster` → DELETE_COMPLETE)

## Errors Hit and Fixes
1. **Pre-commit hook failed closed (gitleaks missing).** The global `pre-commit` hook runs
   `gitleaks protect --staged`; gitleaks was not installed, so it exited non-zero and
   blocked every commit with a false "secrets detected" message. **Fix:** installed
   gitleaks 8.30.1 as a user-level binary to `C:\Users\David\bin` (already on PATH) — no
   admin, no system change, no `--no-verify` bypass. Hook now scans correctly.
2. **`git add` ran from inside the lab dir.** A commit failed on a doubled path because the
   shell cwd had moved into the lab folder. **Fix:** ran `git add` from repo root with the
   full path thereafter.
3. **Control plane deletes asynchronously.** `eksctl delete` reported success while
   `aws eks list-clusters` still showed the cluster (control plane in DELETING). **Fix:**
   polled `list-clusters` until it returned `[]` (~2–3 min) before declaring teardown done.
4. **`describe-stacks` 404 on deleted stack.** Confirming the deleted cluster stack by name
   errored "does not exist" — expected behavior. **Fix:** used
   `list-stacks --stack-status-filter DELETE_COMPLETE` to prove deletion.

## Total Cost Time
~79 minutes from cluster create start (2026-06-24 14:17:40) to teardown fully verified
(~15:37). Hands-on operations were shorter (create ~13.4 min, delete ~7 min); the rest was
the cluster sitting idle between automated steps.

## Estimated Cost
79 / 60 × $0.20 ≈ **$0.26**
