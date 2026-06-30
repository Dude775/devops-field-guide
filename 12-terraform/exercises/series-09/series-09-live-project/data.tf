locals {
  project = "series-09-multiple-resources"

  ami_ids = {
    ubuntu = data.aws_ami.ubuntu.id
    nginx  = data.aws_ami.nginx.id
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["nginx-plus-ubuntu-22.04-v2.5-amd64-developer-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
