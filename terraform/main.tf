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
  sudo apt install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-cache policy docker-ce
  sudo apt install docker-ce
  docker pull volvinbur/it-labs:0.1.0
  docker run -p 80:80 -d --restart unless-stopped --name it-labs volvinbur/it-labs:0.1.0
  docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower it-labs --interval 60
  EOF

}

variable "ec2_name" {
  type = string
}
