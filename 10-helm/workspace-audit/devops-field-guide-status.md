# devops-field-guide Status
Generated: 2026-06-20
Path: `E:\Genspark\devops-field-guide`

---

## Git State

**Branch:** main
**Remote:** origin → https://github.com/Dude775/devops-field-guide.git

### Modified Files
```
 M 10-helm/05-go-template-deep-dive/master-lab/images/.gitkeep
```
(one tracked file modified - the .gitkeep content changed)

### Untracked Files/Folders (NOT yet committed)
```
?? 06-aws/1-Udemy-stefan/
?? 10-helm/05-go-template-deep-dive/master-lab/helm-small-project/
?? 10-helm/commands.md
?? 10-helm/helm-small-project-lab/00-inventory/
?? 10-helm/helm-small-project-lab/00-preflight-inventory.sh
?? 10-helm/helm-small-project-lab/01-source/
?? 10-helm/helm-small-project-lab/helm-small-project-lab.code-workspace
?? 10-helm/images/
?? 10-helm/notes.md
?? 11-aws-advanced/--cluster       ← SUSPICIOUS FILE (see below)
?? 11-aws-advanced/--force         ← SUSPICIOUS FILE (see below)
?? 11-aws-advanced/--region        ← SUSPICIOUS FILE (see below)
?? 11-aws-advanced/--service       ← SUSPICIOUS FILE (see below)
?? 11-aws-advanced/ECS ECR EKS Presentations/
?? 11-aws-advanced/aws             ← SUSPICIOUS FILE (see below)
?? 11-aws-advanced/ecr/
?? 11-aws-advanced/ecs/
?? 11-aws-advanced/mern-eks-app/
```

---

## Last 3 Commits
```
497cee1 docs(helm): document helm small project lab
d52fe21 add ecs deployment proof screenshots
526f5c9 fix orders inventory service connect url
```

---

## Suspicious Files at Wrong Level

### `11-aws-advanced/--cluster`, `--force`, `--region`, `--service`, `aws`
**What they are:** These are files accidentally created by a broken `aws ecs update-service` command.
When `aws` CLI was run with arguments like `--cluster`, `--force`, `--region`, `--service` and
bash redirected output incorrectly, it created files named after the flag names.

**Content (sample):** Contains `ps` process listing output (cygwin/WSL process table).
This is bash output that got written to files instead of being passed as CLI args.

**These files should NOT be committed.** They are artifacts of a CLI accident.

**Recommendation:** Add to `.gitignore` or delete after David confirms.

---

## 10-helm Structure

```
10-helm/
├── 02-installing-tools/
├── 03-helm-fundamentals/
├── 04-creating-our-own-helm-charts/
├── 05-go-template-deep-dive/
│   └── master-lab/
│       ├── helm-small-project/    ← SUB-REPO (master branch, upstream fork)
│       ├── images/
│       ├── docs/
│       ├── k8s/
│       ├── movie-api/
│       ├── .gitignore
│       ├── movie-api.zip          ← old zip file
│       ├── README.md
│       └── .gitkeep               ← MODIFIED
├── 06-key-value-store-api/
├── 07-managing-chart-dependencies/
├── 09-advanced-topics/
├── 10-conclusion/
├── helm-small-project-lab/        ← LAB FOLDER (main work area)
│   ├── .claude/
│   ├── 00-inventory/
│   ├── 00-preflight-inventory.sh
│   ├── 01-source/
│   │   └── helm-small-project/   ← SUB-REPO (lab-homework branch)
│   ├── 02-work/
│   ├── 03-notes/
│   ├── 04-exports/
│   ├── docker/
│   ├── filesystem/
│   ├── helm/
│   ├── kubernetes/
│   ├── repo/
│   ├── helm-small-project-lab.code-workspace
│   ├── architecture.md
│   ├── commands.md
│   ├── README.md
│   ├── troubleshooting.md
│   ├── workspace-audit/          ← THIS AUDIT (current)
│   ├── helm-small-project/       ← 3RD COPY (inside lab folder, root level?)
│   ├── QUICK-REVIEW.txt
│   ├── SMALL-REVIEW.txt
│   ├── SUMMARY.txt
│   ├── TINY-REVIEW.txt
│   └── tools-versions.txt
├── images/                        ← untracked
├── commands.md                    ← untracked
└── notes.md                       ← untracked
```

---

## Duplicate helm-small-project Copies

| Location | Branch | Status | Purpose |
|----------|--------|--------|---------|
| `10-helm/05-go-template-deep-dive/master-lab/helm-small-project/` | master | clean | Upstream fork reference / Go template deep-dive lab |
| `10-helm/helm-small-project-lab/01-source/helm-small-project/` | lab-homework | clean | Lab homework working copy |
| `10-helm/helm-small-project-lab/helm-small-project/` | (unknown) | unknown | **Unexplained 3rd copy** - needs review |

The 3rd copy at `helm-small-project-lab/helm-small-project/` (root of the lab) is suspicious.

---

## What Should Be Committed (Later, After David Approves)

| Item | Why Commit |
|------|-----------|
| `10-helm/helm-small-project-lab/` (the whole lab) | Lab work product - course documentation |
| `10-helm/commands.md` | Useful helm command reference |
| `10-helm/notes.md` | Course notes |
| `10-helm/images/` | Supporting images |
| `06-aws/1-Udemy-stefan/` | AWS course content |
| `11-aws-advanced/ecr/`, `ecs/`, `mern-eks-app/` | AWS advanced lab content |
| `11-aws-advanced/ECS ECR EKS Presentations/` | Course presentations |

---

## What Should NOT Be Committed / Needs Cleanup First

| Item | Why |
|------|-----|
| `11-aws-advanced/--cluster` | Accident file from CLI |
| `11-aws-advanced/--force` | Accident file from CLI |
| `11-aws-advanced/--region` | Accident file from CLI |
| `11-aws-advanced/--service` | Accident file from CLI |
| `11-aws-advanced/aws` | Accident file from CLI |
| `helm-small-project-lab/helm-small-project/` (3rd copy) | Probably should be in `01-source/` |
| `helm-small-project-lab/QUICK-REVIEW.txt`, `SMALL-REVIEW.txt`, `SUMMARY.txt`, `TINY-REVIEW.txt` | Audit artifacts, not course content |
| `.gitkeep` modified | Investigate why this changed |

---

## Recommended Structure Cleanup
1. Delete or gitignore: `11-aws-advanced/--cluster`, `--force`, `--region`, `--service`, `aws`
2. Clarify the 3rd `helm-small-project` copy location
3. Add entries to `.gitignore` for `QUICK-REVIEW.txt`, `*-REVIEW.txt`, `workspace-audit/`
4. Commit the lab, commands, notes, images
5. Commit `06-aws` and `11-aws-advanced` content (minus the CLI artifacts)
