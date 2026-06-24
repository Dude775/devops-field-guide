# Lab 1.2 - Configuring the AWS Provider

## Objective
Move from the local-only `local_file` provider to a real cloud provider: AWS. This lab
configures the `hashicorp/aws` provider and proves that `terraform init` downloads it and
`terraform plan` works — **without creating any billable resources yet**. It's the
"wire up the provider" step that every AWS Terraform project starts from.

## Provider Declaration
`main.tf` declares the AWS provider and pins it to the 5.x major version, then configures
the target region:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
```

- `required_providers` — tells Terraform which provider to fetch and from where
  (`hashicorp/aws` on the public registry). `~> 5.0` allows any `5.x` but not `6.0`.
- `provider "aws"` — runtime configuration for that provider. Here only `region` is set;
  credentials are picked up from the environment / AWS CLI config (the same `Drubin-1`
  credentials used elsewhere in this repo), never hardcoded.

## `terraform init` Behavior
Running `terraform init` here:
- Found and installed **`hashicorp/aws v5.100.0`** (the latest matching `~> 5.0`).
- Created `.terraform.lock.hcl` pinning that version and its checksums.
- Populated `.terraform/` with the provider plugin binary.

This step only downloads the plugin — it is **free** and makes no API calls that create
resources.

## What `terraform plan` Returns With No Resources
Because `main.tf` defines a provider but **no resources**, `terraform plan` reports:

```
No changes. Your infrastructure matches the configuration.
```

There is nothing to create, change, or destroy. This is the expected and correct result
for a provider-only configuration — it confirms the provider is wired up and credentials
resolve, without provisioning anything.

## Files in This Lab
| File | Committed? | Purpose |
| --- | --- | --- |
| `main.tf` | yes | Provider declaration + region |
| `.gitignore` | yes | Excludes state, `.terraform/`, tfvars, crash logs |
| `.terraform.lock.hcl` | (generated) | Provider version lock (commit in real projects) |
| `.terraform/` | no (git-ignored) | Downloaded AWS provider plugin (~hundreds of MB) |
