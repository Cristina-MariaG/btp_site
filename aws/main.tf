terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}


resource "aws_instance" "app_server" {
  ami           = "ami-087da76081e7685da"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.frontend-pre-prod.key_name

  vpc_security_group_ids = [aws_security_group.default.id]

  tags = {
    Name = "frontend-pre-prod-project"
  }
}

resource "aws_key_pair" "frontend-pre-prod" {
  key_name   = "frontend-pre-prod"
  public_key = file("./.ssh/frontend-pre-prod.pub")
}

# Create a security group for the instances
resource "aws_security_group" "default" {
  name        = "frontend-pre-prod-project"
  description = "Used in the terraform"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["141.94.138.152/32"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  # Disable after installation Parce que sinon ça va PETER, PETER !! https://www.youtube.com/watch?v=Xptd4gb3FHc
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

