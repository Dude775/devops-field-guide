subnet_config = {
  default = {
    cidr_block = "10.0.0.0/24"
  }

  subnet_one = {
    cidr_block = "10.0.1.0/24"
  }
}

ec2_instance_config_list = []

ec2_instance_config_map = {
  ubuntu_1 = {
    instance_type = "t3.micro"
    ami           = "ubuntu"
    subnet_name   = "default"
  }

  ubuntu_2 = {
    instance_type = "t3.micro"
    ami           = "ubuntu"
    subnet_name   = "subnet_one"
  }
}
