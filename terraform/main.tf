provider "aws" {
  region  = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
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
  ami           = "${{ secrets.AMI }}"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.OV_sg.id]

  key_name = "aws_key"
  tags = {
    Name = var.ec2_name
  }

}

variable "ec2_name" {
  type = string
}
