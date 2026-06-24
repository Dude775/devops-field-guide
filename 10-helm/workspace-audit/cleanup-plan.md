# Cleanup Plan
Generated: 2026-06-20
Status: PROPOSED — awaiting David approval before any action

---

## Phase A — No-Risk Documentation Only
*Local-only changes. Zero destructive operations. David can approve immediately.*

### A1 — Add .gitignore entries to devops-field-guide
**Target:** `E:\Genspark\devops-field-guide\.gitignore` (or create if missing)
**Command:**
```bash
# In E:\Genspark\devops-field-guide
cat >> .gitignore << 'EOF'
# Audit artifacts
10-helm/helm-small-project-lab/workspace-audit/
10-helm/helm-small-project-lab/QUICK-REVIEW.txt
10-helm/helm-small-project-lab/SMALL-REVIEW.txt
10-helm/helm-small-project-lab/SUMMARY.txt
10-helm/helm-small-project-lab/TINY-REVIEW.txt
# CLI accidents
11-aws-advanced/--cluster
11-aws-advanced/--force
11-aws-advanced/--region
11-aws-advanced/--service
11-aws-advanced/aws
EOF
```
**Reason:** Prevent CI artifacts and CLI accidents from ever being committed
**Risk:** None
**Rollback:** `git checkout .gitignore`
**David Must Approve:** YES (minor)

---

## Phase B — Git Cleanup Inside devops-field-guide
*Commit the real lab work. Remove the CLI accident files.*

### B1 — Delete CLI accident files
**Target:** `E:\Genspark\devops-field-guide\11-aws-advanced\`
**Command:**
```bash
cd "E:\Genspark\devops-field-guide"
rm "11-aws-advanced/--cluster" "11-aws-advanced/--force" "11-aws-advanced/--region" "11-aws-advanced/--service" "11-aws-advanced/aws"
```
**Reason:** Files named `--cluster`, `--force`, `--region`, `--service`, `aws` are accidental outputs from a broken `aws ecs update-service` bash command. Content is a WSL process listing, not actual data.
**Risk:** LOW — confirmed these are accidents (content is `ps` output, 405 bytes each)
**Rollback:** N/A — they're garbage files. Already tracked as untracked (not committed).
**David Must Approve:** YES

### B2 — Investigate and commit helm-small-project-lab
**Target:** `E:\Genspark\devops-field-guide`
**Actions (in order):**
1. First: Investigate the 3rd `helm-small-project/` copy at `helm-small-project-lab/helm-small-project/`
   ```bash
   git -C "10-helm/helm-small-project-lab/helm-small-project" rev-parse --abbrev-ref HEAD
   git -C "10-helm/helm-small-project-lab/helm-small-project" remote -v
   ```
2. If it's a duplicate of `01-source/helm-small-project/` on the same branch: remove it
3. Commit the lab:
   ```bash
   git add 10-helm/helm-small-project-lab/
   git add 10-helm/commands.md 10-helm/notes.md 10-helm/images/
   git commit -m "feat(helm): add helm small project lab work and course notes"
   ```
**Reason:** Lab content (commands, notes, inventory, source) is legitimate course work that should be committed.
**Risk:** LOW if 3rd copy is resolved first
**Rollback:** `git reset HEAD~1` (uncommit) or `git reset --soft HEAD~1`
**David Must Approve:** YES

### B3 — Commit 11-aws-advanced content (after B1)
**Target:** `E:\Genspark\devops-field-guide`
**Command:**
```bash
git add 11-aws-advanced/ecr/ 11-aws-advanced/ecs/ 11-aws-advanced/mern-eks-app/
git add "11-aws-advanced/ECS ECR EKS Presentations/"
git add 11-aws-advanced/microservices-ecs-deploy/ 
git commit -m "feat(aws-advanced): add ECS/ECR/EKS lab work and presentations"
```
**Reason:** AWS advanced content is legitimate lab work
**Risk:** LOW
**Rollback:** `git reset HEAD~1`
**David Must Approve:** YES

### B4 — Commit 06-aws content
**Target:** `E:\Genspark\devops-field-guide`
**Command:**
```bash
git add 06-aws/
git commit -m "feat(aws): add AWS Udemy course content"
```
**Reason:** AWS course content belongs in the field guide
**Risk:** LOW
**Rollback:** `git reset HEAD~1`
**David Must Approve:** YES

### B5 — Push to GitHub
**Command:**
```bash
git push origin main
```
**Reason:** Sync local commits to remote
**Risk:** LOW (pushes to own fork)
**Rollback:** Cannot easily unpush but can revert commits
**David Must Approve:** YES

---

## Phase C — Move/Archive Duplicate Folders
*Requires careful coordination. No deletions yet.*

### C1 — Resolve ATM-Machine duplication
**The problem:** `E:\Genspark\ATM-Machine` (clean) vs `Desktop\ATM\ATM\ATM-dev` (dirty)
**Recommended action:**
1. Review dirty changes in Desktop copy:
   ```bash
   git -C "C:\Users\David\Desktop\ATM\ATM\ATM-dev" diff
   git -C "C:\Users\David\Desktop\ATM\ATM\ATM-dev" status
   ```
2. If changes are worth keeping → commit them from Desktop or copy to Genspark version
3. If not → note to delete Desktop copy later (Phase C cleanup)
**Risk:** MEDIUM (could lose uncommitted work)
**Rollback:** Don't delete until committed or explicitly decided to discard
**David Must Approve:** YES

### C2 — Resolve job-hunter duplication
**The problem:** `E:\Genspark\active\job-hunter` vs `E:\Genspark\job-hunter` (top-level)
**Action:**
```bash
ls "E:\Genspark\job-hunter"
# Determine if this is an old copy or something different
```
**Risk:** MEDIUM (active project)
**Rollback:** No deletion until confirmed
**David Must Approve:** YES

### C3 — Handle archive/local-rag-system staged files
**The problem:** Staged but uncommitted files in `archive/local-rag-system`
**Command:**
```bash
git -C "E:\Genspark\archive\local-rag-system" status
git -C "E:\Genspark\archive\local-rag-system" diff --cached
# Then either commit or unstage
```
**Risk:** LOW
**Rollback:** `git restore --staged .`
**David Must Approve:** YES

### C4 — Handle archive/genspark-conversation-toolbox deleted files
**The problem:** Deleted tracked files not committed
**Command:**
```bash
git -C "E:\Genspark\archive\genspark-conversation-toolbox-main" status
# Decide: commit the deletion or restore the files
```
**Risk:** LOW
**David Must Approve:** YES

### C5 — Move backup-fork tar to backups/
**Command:**
```powershell
Move-Item "E:\Genspark\backup-fork-untracked-2026-05-23.tar.gz" "E:\Genspark\backups\"
```
**Reason:** Archive file in root is cluttering the Genspark directory
**Risk:** NONE — file move only
**Rollback:** Move back
**David Must Approve:** YES

---

## Phase D — Docker Local Cleanup
*Remove exited containers and stale course images. ONLY after David confirms labs are done.*

### D1 — Remove stale exited containers (course labs)
**Containers to remove:**
```bash
docker rm gallant_feynman    # lironefitoussi/aws-sol-2
docker rm app                # ecr-demo
docker rm hungry_chatterjee  # lironefitoussi/aws-sol-1
docker rm movie-api          # helm lab
```
**Skip:** `mongo-old-before-step01`, `shopflow-backend`, `shopflow-postgres` — need investigation/IRAN-3 decision
**Risk:** LOW — exited containers, labs appear done
**Rollback:** Cannot restore containers but images are still present
**David Must Approve:** YES

### D2 — Remove stale course images
**Images to remove (after D1):**
```bash
docker rmi lironefitoussi/aws-sol-1:latest
docker rmi lironefitoussi/aws-sol-2:latest
docker rmi 450963613786.dkr.ecr.us-east-1.amazonaws.com/ecr-demo:latest
docker rmi ecr-demo:latest
docker rmi "gcr.io/k8s-minikube/kicbase@sha256:eb4fec00e8ad..."   # older digest only
```
**Risk:** MEDIUM — cannot re-pull ECR image without AWS credentials
**Rollback:** Cannot restore — must rebuild/re-pull
**David Must Approve:** YES — especially for ECR image

### D3 — Investigate anonymous volumes
**Command:**
```bash
docker inspect 1a23099bf55a 2bddd7d631a7 6ffa7bbac665 a5e7cf3a58b7 ca759815c0bb f9b49efbcc
```
**Reason:** 6 anonymous volumes with unknown purpose
**Risk:** HIGH to delete without knowing contents
**Rollback:** Cannot restore volumes once deleted
**David Must Approve:** YES — investigate first, decide later

---

## Phase E — Kubernetes Cleanup
*Only after confirming labs are fully done.*

### E1 — Investigate orphaned PVC
**The problem:** `data-my-wordpress-mariadb-0` PVC exists but no `my-wordpress` Helm release
**Command:**
```bash
helm list -A | grep my-wordpress
kubectl describe pvc data-my-wordpress-mariadb-0
```
**Reason:** If the release was deleted but PVC remains, it's orphaned and wasting storage
**Risk:** LOW to investigate, HIGH to delete
**Rollback:** Cannot restore PVC data once deleted
**David Must Approve:** YES

### E2 — Optional: Delete Helm releases when labs done
**Releases to potentially remove (ONLY if lab is complete):**
```bash
helm uninstall local-wp -n default     # WordPress - 26Gi of PVCs!
helm uninstall my-nginx -n default     # nginx chart
```
**WARNING:** `helm uninstall local-wp` will NOT delete the PVCs by default.
You must explicitly delete PVCs after:
```bash
kubectl delete pvc data-local-wp-mariadb-0 local-wp-wordpress
```
**Risk:** HIGH — data loss if WordPress has content. LOW if lab is complete and no content needed.
**Rollback:** Cannot restore data
**David Must Approve:** YES — explicit confirmation required

---

## Phase F — Docker Hub Verification
*Read-only checks already done. Both images exist.*

### F1 — Confirm both images are accessible
**Status:** COMPLETE ✅
- `idf775/movie-api:1.0` — EXISTS on Docker Hub
- `idf775/movie-api:1.1` — EXISTS on Docker Hub

### F2 — Optional: Remove local copies if Docker Hub is source of truth
**Command:**
```bash
docker rmi idf775/movie-api:1.0 idf775/movie-api:1.1
docker rmi dude775/movie-api:1.0  # same image, local alias
```
**Risk:** LOW — can re-pull from Docker Hub anytime
**David Must Approve:** YES

---

## Phase G — Final GitHub Repo Cleanup
*Deferred — assess after Phases A-F are done.*

### G1 — Archive old repos on GitHub (optional)
**Candidates:**
- `archive/genspark-conversation-toolbox-main` → github.com/Dude775/genspark-rtl-toolbox — can archive on GitHub
- `archive/local-rag-system` → github.com/Dude775/local-rag-system — can archive on GitHub
- `archive/photo-organizer` — placeholder remote, needs real remote or cleanup

### G2 — Handle infra/n8n-mcp (hundreds of staged files, no commits)
**This needs a decision:** Is n8n-mcp active or abandoned?
- If active → set remote, commit, push
- If abandoned → delete local repo
**Risk:** HIGH — do not touch without David's explicit decision
**David Must Approve:** YES

### G3 — Handle IRAN-3/backend (empty repo, no commits)
**This needs a decision:** Is this a new active project?
- If active → add remote, commit, push
- If experiment → delete
**Risk:** MEDIUM
**David Must Approve:** YES

---

## Priority Order (Recommended)

| Priority | Phase | Action | Risk |
|----------|-------|--------|------|
| 1 | A | Add .gitignore entries | NONE |
| 2 | B1 | Delete CLI accident files | LOW |
| 3 | B2 | Investigate + commit helm lab | LOW |
| 4 | B3-4 | Commit AWS content | LOW |
| 5 | B5 | Push to GitHub | LOW |
| 6 | C5 | Move backup tar | NONE |
| 7 | C1 | Resolve ATM duplication | MEDIUM |
| 8 | D1 | Remove stale containers | LOW |
| 9 | D3 | Investigate anonymous volumes | — |
| 10 | E1 | Investigate orphaned PVC | LOW |
| 11 | D2 | Remove stale images | MEDIUM |
| 12 | F2 | Remove local movie-api images | LOW |
| 13 | E2 | Uninstall K8s workloads | HIGH |
| 14 | G | GitHub cleanup | MEDIUM |

---

## ⚠️ CRITICAL RULES
1. **NEVER delete** `iran-3_postgres-data` or `minikube` Docker volumes
2. **NEVER delete** PVCs without explicit David confirmation and data backup
3. **NEVER delete** `E:\Genspark\sensitive`, `E:\Genspark\Genspark_New_API-KEY`, `E:\Genspark\N8N`
4. **NEVER push** to `DevOps-Materials` or `microservices-docker` (upstream IITC repos)
5. **NEVER modify** `infra/Obsidian_Dave775-Memory_Vault` content
6. **NEVER commit** without reviewing `git diff --staged` first
