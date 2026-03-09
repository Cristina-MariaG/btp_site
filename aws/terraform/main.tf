# ============================================================
# TERRAFORM CONFIGURATION
# ============================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}


# ============================================================
# PROVIDER
# ============================================================
provider "aws" {
  region = var.aws_region
}


# ============================================================
# SSH KEY — Generate, register on AWS, save locally
# ============================================================
resource "tls_private_key" "btp_app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "btp_app_key" {
  key_name   = "btp-app-key"
  public_key = tls_private_key.btp_app_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.btp_app_key.private_key_pem
  filename        = "/home/arcus/.ssh/btp_app_key"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content         = tls_private_key.btp_app_key.public_key_openssh
  filename        = "/home/arcus/.ssh/btp_app_key.pub"
  file_permission = "0644"
}


# ============================================================
# SECURITY GROUP
# ============================================================
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security rules for the EC2 instance"

  # SSH — port 22
  ### Dont forget to change to your ip only in prod
  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["37.65.59.156/32"]
  }

  # HTTP — port 80
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS — port 443
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  # Application port — 3030
  # ingress {
  #   description = "Vue application"
  #   from_port   = 3030
  #   to_port     = 3030
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # Egress — allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}


# ============================================================
# EC2 INSTANCE
# ============================================================
resource "aws_instance" "btp_app_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.btp_app_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # user_data = <<-EOF
  #   #!/bin/bash
  #   apt-get update -y
  #   apt-get install -y docker.io docker-compose
  #   systemctl start docker
  #   systemctl enable docker
  #   usermod -aG docker ubuntu
  # EOF

  tags = {
    Name        = var.instance_name
    Environment = "prod"
  }
}


# ============================================================
# ELASTIC IP
# ============================================================
resource "aws_eip" "my_eip" {
  instance = aws_instance.btp_app_instance.id
  domain   = "vpc"

  tags = {
    Name = "ec2-eip"
  }
}