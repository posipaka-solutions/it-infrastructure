provider "aws" {
  region  = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "OV_sg" {
  name        = "OV_security_group"
  description = "Security group for the example application"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "it_lab_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.OV_sg.id]

  key_name = "aws_key"
  tags = {
    Name = var.ec2_name
  }

}

variable "ec2_name" {
  type = string
}
