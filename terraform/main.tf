provider "aws" {
  region  = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
}
terraform {
  cloud {
    organization = "baryn72"

    workspaces {
      name = "GitHub-test"
    }
  }
}
resource "aws_security_group" "OV_sg" {
  name        = var.ec2_sg_name
  description = "Security group for the example application"

  ingress {
    from_port   = 80
    to_port     = 80
    self        = true
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "it_lab_2" {
  ami           = "ami-04e601abe3e1a910f"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.OV_sg.id]

  key_name = "aws_key"
  tags = {
    Name = var.ec2_name
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt install docker.io -y
  sudo snap install docker
  sudo docker pull volvinbur/it-labs:0.1.0
  sudo docker run -p 80:80 -d --restart unless-stopped --name it-labs volvinbur/it-labs:0.1.0
  sudo docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower it-labs --interval 60
  EOF

}

variable "ec2_name" {
  type = string
}
variable "ec2_sg_name" {
  type = string
}
