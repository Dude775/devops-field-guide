# Lab 1.1 - First Terraform Resource: local_file

## Objective
Learn the core Terraform workflow with the simplest possible resource — a file written to
the local disk. No cloud, no credentials, no cost. The goal is to internalize the
`init → plan → apply` loop, understand what state is, and see how Terraform reconciles
desired configuration against real-world resources.

## Resource Used
The [`local_file`](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)
resource from the `hashicorp/local` provider:

```hcl
resource "local_file" "example_file" {
  filename = "hello.txt"
  content  = "Hello Terraform"
}
```

This declares a file named `hello.txt` whose contents are exactly `Hello Terraform`.

## Workflow (init -> plan -> apply)
1. **`terraform init`** — downloads the `hashicorp/local` provider plugin into
   `.terraform/` and writes the dependency lock file `.terraform.lock.hcl`. Run once per
   working directory (or whenever providers change).
2. **`terraform plan`** — computes the diff between desired config and current state.
   On the first run it showed `1 to add` (the file did not exist yet).
3. **`terraform apply`** — executes the plan, creates `hello.txt` on disk, and records the
   result in `terraform.tfstate`.

## State Files Created
- **`terraform.tfstate`** — the source of truth Terraform keeps about what it manages.
  After apply it contains the `local_file.example_file` resource, including the computed
  content hash. This file is git-ignored (it can hold sensitive values).
- **`.terraform.lock.hcl`** — the provider dependency lock (pins the exact `hashicorp/local`
  version + checksums). This file **is** committed so the lab is reproducible.
- **`.terraform/`** — the local plugin cache holding the downloaded provider binary.
  Git-ignored.

## Key Concepts
- **Providers** — plugins that teach Terraform how to talk to an API or system. Here the
  `local` provider manages files on the local filesystem.
- **State** — Terraform's record of the real resources it manages, kept in
  `terraform.tfstate`. Without state, Terraform has no memory of what it created.
- **Plan** — a dry-run that shows exactly what will change before anything happens.
- **Apply** — the step that actually makes the world match the configuration.
- **Immutable Infrastructure** — Terraform doesn't edit a resource in place when certain
  attributes change; it destroys and recreates it. `local_file` content is one such case.
- **ForceNew** — attributes flagged as ForceNew (like `local_file.content`) trigger a
  destroy-and-recreate on change rather than an in-place update. In a plan this shows up as
  `-/+ destroy and then create replacement`.

## Files in This Lab
| File | Committed? | Purpose |
| --- | --- | --- |
| `main.tf` | yes | The resource definition |
| `.gitignore` | yes | Excludes state, `.terraform/`, tfvars, crash logs |
| `.terraform.lock.hcl` | yes | Pins provider version for reproducibility |
| `hello.txt` | (generated) | The output file Terraform created |
| `terraform.tfstate` | no (git-ignored) | State, evidence the apply succeeded |
| `.terraform/` | no (git-ignored) | Downloaded provider plugin cache |
