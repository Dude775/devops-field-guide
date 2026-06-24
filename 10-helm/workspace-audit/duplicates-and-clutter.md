# Duplicates and Clutter
Generated: 2026-06-20

---

## Duplicated Git Repos

| Item | Locations | Why Suspicious | Evidence | Recommendation | Risk | David Approval |
|------|-----------|---------------|----------|---------------|------|----------------|
| ATM-Machine | `E:\Genspark\ATM-Machine` (clean) + `Desktop\ATM\ATM\ATM-dev` (dirty, many modified) | Same GitHub remote, two working copies in different states | Both push to `github.com/Dude775/ATM-Machine.git` | Keep `E:\Genspark\ATM-Machine` as primary. Review Desktop WIP and commit or discard changes | needs review | YES |
| code-review-agent | `E:\Genspark\active\code-review-agent-test` + `E:\Genspark\archive\code-review-agent` | Same remote `Dude775/code-review-agent`, different branches | active: Phase2+, archive: PRD v2.0 only | Keep active, archive is an old snapshot - can be deleted after confirming | safe | YES |
| python-module | `Desktop\python-module` + `Desktop\python-module\todo-collab-lab` | Same remote, nested repo | Both push to `Dude775/python-module-.git` | Clarify: is todo-collab-lab a submodule or an accident? | needs review | YES |
| helm-small-project | 3 copies in devops-field-guide (see below) | Three different states of the same upstream repo | Different branches + one mystery copy | See dedicated section below | needs review | YES |

---

## helm-small-project Copies

| Path | Branch | Status | Purpose | Recommendation |
|------|--------|--------|---------|---------------|
| `10-helm/05-go-template-deep-dive/master-lab/helm-small-project/` | `master` | clean | Go template deep-dive reference | Keep - this is the course reference |
| `10-helm/helm-small-project-lab/01-source/helm-small-project/` | `lab-homework` | clean | Lab homework working copy | Keep - this is the active lab |
| `10-helm/helm-small-project-lab/helm-small-project/` | unknown | unknown | **Mystery** - 3rd copy at lab root | Investigate: probably `git clone` artifact | 

> **The 3rd copy** at `helm-small-project-lab/helm-small-project/` (directly inside the lab folder, not in `01-source/`) is unexpected. This was probably cloned accidentally at the wrong level. Needs investigation — check its branch and remote before removing.

---

## Accidental Files (CLI Artifacts)

| Path | Why Suspicious | Evidence | Recommendation | Risk | David Approval |
|------|---------------|----------|---------------|------|----------------|
| `11-aws-advanced/--cluster` | Named like a CLI flag | Content is a WSL `ps` process listing (~405 bytes) | Delete (CLI accident from `aws ecs update-service` command) | low | YES |
| `11-aws-advanced/--force` | Named like a CLI flag | Same ps output content | Delete | low | YES |
| `11-aws-advanced/--region` | Named like a CLI flag | Same ps output content | Delete | low | YES |
| `11-aws-advanced/--service` | Named like a CLI flag | Same ps output content | Delete | low | YES |
| `11-aws-advanced/aws` | Named like the `aws` binary | Same ps output content | Delete | low | YES |

**Explanation:** When `aws ecs update-service --cluster X --region Y --service Z --force` was run in bash/WSL with broken shell expansion or redirection, bash interpreted the flag names as file redirection targets and wrote the CLI's stderr/stdout into files named `--cluster`, `--force`, `--region`, `--service`, and `aws`. These are not legitimate files.

---

## Old Notes/Commands/Images Files

| Path | Notes | Recommendation | Risk | David Approval |
|------|-------|---------------|------|----------------|
| `E:\Genspark\devops-field-guide\10-helm\commands.md` | Course command reference, legitimate | Commit to git | safe | YES to commit |
| `E:\Genspark\devops-field-guide\10-helm\notes.md` | Course notes, legitimate | Commit to git | safe | YES to commit |
| `E:\Genspark\devops-field-guide\10-helm\images\` | Course screenshots/diagrams | Commit to git | safe | YES to commit |
| `E:\Genspark\backup-fork-untracked-2026-05-23.tar.gz` | Backup archive sitting in Genspark root | Move to `E:\Genspark\backups\` | low | YES |
| `E:\Genspark\test_genspark.sh` | Loose test script in root | Move to `misc/` or delete if old | low | YES |

---

## Generated Archives/Zips

| Path | Probable Source | Recommendation | Risk | David Approval |
|------|----------------|---------------|------|----------------|
| `Desktop\Kubeinertis\color-api-code.zip` | ZIP of color-api-code folder (unzipped copy exists alongside) | Delete after confirming `color-api-code/` is complete | low | YES |
| `Desktop\Kubeinertis\color_api_1_1_0.zip` | ZIP of v1.1.0 (unzipped copy exists alongside) | Delete after confirming folder is complete | low | YES |
| `Desktop\Kubeinertis\nb-driver-*.zip` | GPU driver installer | Delete if driver already installed | low | YES |
| `E:\Genspark\devops-field-guide\10-helm\05-go-template-deep-dive\master-lab\movie-api.zip` | movie-api source archive | Delete (movie-api folder exists) | low | YES |

---

## Misplaced Folders

| Path | Should Probably Be At | Notes | Risk | David Approval |
|------|----------------------|-------|------|----------------|
| `E:\Genspark\backup-fork-untracked-2026-05-23.tar.gz` | `E:\Genspark\backups\` | Archive sitting in root | low | YES |
| `Desktop\ATM\ATM\ATM-dev` | `E:\Genspark\active\ATM-Machine` or merged into existing | Desktop WIP of repo that lives in Genspark | low | YES |
| `Desktop\CI-CD\lab 7\CUsersDavidDesktopCI-CDstudent-api` | Probably `Desktop\CI-CD\student-api` | Oddly named - looks like git clone with Windows path as folder name | needs review | YES |
| `Desktop\python-module\oop\ATM` | Should be removed or clearly marked as foreign | This is danielyacov's repo cloned inside David's repo | safe | YES |

---

## Desktop Folders That Probably Belong Under E:\Genspark

| Desktop Folder | Evidence | Recommendation | Risk | David Approval |
|----------------|---------|---------------|------|----------------|
| `Desktop\CI-CD` | Course CI/CD labs with proper GitHub remotes | Move to `E:\Genspark\` if course is complete | low | YES |
| `Desktop\aws-databite` | Completed AWS project | Move to `E:\Genspark\career` or archive | low | YES |
| `Desktop\ATM\ATM\ATM-dev` | Duplicate of E:\Genspark\ATM-Machine | Consolidate or delete after resolving WIP | low | YES |

---

## Summary Table

| Category | Count | Total Risk |
|----------|-------|-----------|
| Duplicated repos | 4 | medium |
| CLI accident files | 5 | low |
| Misnamed clone artifacts | 1 | low |
| Archive/zip duplicates | 4 | low |
| Loose files in Genspark root | 2 | low |
| Desktop folders that belong in Genspark | 3 | low |
