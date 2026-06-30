# Series 9 Live Project

This is the working Terraform project for Series 9 - Creating Multiple Resources.

The project was built as one evolving lab instead of duplicating the same Terraform files for every step.

## What this project creates

- VPC
- subnets from a map
- EC2 instances from a map
- AMI lookup through data sources
- variable validations

## Main concepts

- `count`
- `count.index`
- list of objects
- map of objects
- `for_each`
- `each.key`
- `each.value`
- `values()`
- `contains()`
- `alltrue()`
- `can()`
- `cidrnetmask()`
- `optional()`
- map-based subnet references

## File layout

| File | Role |
|---|---|
| `provider.tf` | Terraform version and AWS provider |
| `data.tf` | project local value and AMI data sources |
| `networking.tf` | VPC and subnet configuration |
| `compute.tf` | EC2 instances from list/map config |
| `variables.tf` | variables and validation rules |
| `terraform.tfvars` | lab input values |

## Current configuration

The final configuration uses:

- `t3.micro`
- Ubuntu AMI
- two subnet keys:
  - `default`
  - `subnet_one`
- two EC2 map entries:
  - `ubuntu_1`
  - `ubuntu_2`

NGINX support exists in the code, but it is not used in the final `terraform.tfvars` because AWS Marketplace required subscription approval during apply.

## Commands used

Initialize:

`terraform init`

Validate:

`terraform validate`

Plan:

`terraform plan`

Apply:

`terraform apply -auto-approve`

Inspect state:

`terraform state list`

Destroy:

`terraform destroy -auto-approve`

## Important lesson

Terraform syntax can be valid and `plan` can pass, but `apply` still tests the real AWS account, region, Marketplace permissions, quotas, and instance type rules.

Plan shows intent. Apply tests reality.
