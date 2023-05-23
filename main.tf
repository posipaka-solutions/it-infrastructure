provider "aws" {
  region = "us-west-2"
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
  ami           = "${secrets.AMI}" #"ami-04e601abe3e1a910f"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.OV_sg.id]

  key_name = "aws_key"

}
