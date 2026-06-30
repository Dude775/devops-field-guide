# Terraform Series 9 - Creating Multiple Resources

This series was implemented as one evolving Terraform project instead of copying the same files across every lab.

Main project:

`series-09-live-project/`

The goal was to keep the workspace clean while still covering the logic from labs 9.1-9.8.

## Lab coverage

| Lab | Topic | Covered in project |
|---|---|---|
| 9.1 | Creating multiple resources with count | count concepts, partial creation, plan vs apply behavior |
| 9.2 | Referencing resources created with count | subnet references and EC2 placement logic |
| 9.3 | EC2 instances from list variable | `ec2_instance_config_list` remains supported |
| 9.4 | Extending AMI support to NGINX | AMI map includes Ubuntu and NGINX, Marketplace limitation documented |
| 9.5 | Validation for list variable | validation on instance type and AMI values |
| 9.6 | EC2 instances from map variable | `ec2_instance_config_map` with `for_each` |
| 9.7 | Validation for map variable | validation using `values()`, `contains()`, and `alltrue()` |
| 9.8 | Map-based subnet refactor | `subnet_config` map and `subnet_name` based placement |

## Final architecture

The final project uses:

- AWS provider in `eu-west-1`
- one VPC
- subnets created from a map using `for_each`
- EC2 instances created from a map using `for_each`
- AMI lookup through data sources
- validation blocks for safer input
- `terraform.tfvars` as lab configuration, with no secrets

## Important real-world findings

### Plan vs apply

`terraform plan` can succeed while `terraform apply` fails against real AWS constraints.

In this lab, apply failed once after creating only part of the infrastructure. That demonstrated partial creation:

- VPC was created
- subnets were created
- EC2 instances failed
- Terraform state showed only the successfully created resources

Cleanup was done with `terraform destroy`.

### NGINX AMI limitation

The NGINX AMI lookup worked after adjusting the AMI filter, but the EC2 launch failed because AWS Marketplace required subscription acceptance.

The code keeps NGINX support, but the final `terraform.tfvars` uses Ubuntu for both instances so the lab can apply successfully without Marketplace approval.

### Instance type limitation

The original lab used `t2.micro`, but this AWS account rejected it as not Free Tier eligible.

The final project uses `t3.micro`, which was returned as Free Tier eligible in `eu-west-1`.

## Final result

A full apply was completed successfully:

- 1 VPC
- 2 subnets
- 2 EC2 instances

Then cleanup was completed successfully:

- `Destroy complete! Resources: 5 destroyed.`

EC2 instances remained visible as `terminated`, which is expected for a short time after termination.

## Files

| File | Purpose |
|---|---|
| `provider.tf` | Terraform and AWS provider configuration |
| `data.tf` | locals and AMI data sources |
| `networking.tf` | VPC and subnet resources |
| `compute.tf` | EC2 resources from list/map inputs |
| `variables.tf` | input variables and validations |
| `terraform.tfvars` | lab configuration |
| `.terraform.lock.hcl` | provider lock file, tracked intentionally |

## Notes

`_audit/` is local-only and ignored by git. It contains plan/apply/destroy outputs and troubleshooting artifacts.
