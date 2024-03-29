terraform {
  cloud {
    organization = "cikese7476"

    workspaces {
      name = "cikese7476"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.small"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Server"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}