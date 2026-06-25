ec2_instance_type = "t3.micro"

ec2_volume_config = {
  type = "gp2"
  size = 10
}

additional_tags = {
  ValuesFrom = "terraform.tfvars"
}
