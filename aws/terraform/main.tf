# ============================================================
# TERRAFORM CONFIGURATION
# Pins the AWS provider version to avoid breaking changes
# on future provider releases.
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
# Defines the cloud provider and target region.
# All resources will be provisioned in this AWS region.
# ============================================================
provider "aws" {
  region = var.aws_region
}


# ============================================================
# TLS PRIVATE KEY
# Generates a RSA private key locally.
# Terraform will use it to create the AWS key pair and save
# the private key as a .pem file on the local filesystem.
# ============================================================
resource "tls_private_key" "btp_app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


# ============================================================
# SSH KEY PAIR
# Registers the generated public key on AWS.
# AWS will embed this public key in the EC2 instance at launch,
# allowing SSH access with the matching .pem private key.
# ============================================================
resource "aws_key_pair" "btp_app_key" {
  key_name   = var.key_name
  public_key = tls_private_key.btp_app_key.public_key_openssh
}


# ============================================================
# SAVE PEM FILE LOCALLY
# Writes the private key to disk as a .pem file.
# This file is used to SSH into the instance.
# It is saved to ~/.ssh/ and permissions are set to 400.
# ============================================================
resource "local_sensitive_file" "btp_app_key_pem" {
  content         = tls_private_key.btp_app_key.private_key_pem
  filename        = "/home/arcus/.ssh/${var.key_name}.pem"
  file_permission = "0400"  # read-only for owner — required by SSH
}


# ============================================================
# SECURITY GROUP
# Acts as a virtual firewall for the EC2 instance.
# Ingress rules control inbound traffic.
# Egress rules control outbound traffic.
# ============================================================
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security rules for the EC2 instance"

  # SSH — port 22
  # Allows remote access to the instance via SSH.
  # WARNING: restrict cidr_blocks to a specific IP in production environments.
  ### Dont forget to change to your ip only in prod (security groups inbound rules)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP — port 80
  # Allows inbound web traffic from any source.
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS — port 443
  # Allows inbound secure web traffic from any source.
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port — 3030
  # Allows direct access to the Vue application.
  # Can be removed if traffic is routed through a reverse proxy on port 80/443.
 # ingress {
 #   description = "Vue application"
 #   from_port   = 3030
 #   to_port     = 3030
 #   protocol    = "tcp"
 #   cidr_blocks = ["0.0.0.0/0"]
 # }

  # Egress — allow all outbound traffic
  # Required for the instance to reach external services,
  # install packages, pull Docker images, etc.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}


# ============================================================
# EC2 INSTANCE
# The virtual machine that will run the application.
# ============================================================
resource "aws_instance" "btp_app_instance" {
  ami                    = var.ami_id          # OS image (Ubuntu, Amazon Linux, etc.)
  instance_type          = "t2.micro"          # small instance type, eligible for AWS free tier
  key_name               = aws_key_pair.btp_app_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Bootstrapping script executed once on first instance startup.
  # Installs Docker and Docker Compose without requiring manual intervention.
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
    Environment = "dev"
  }
}


# ============================================================
# ELASTIC IP
# Assigns a static public IP address to the instance.
# Without this, the public IP changes on every instance restart,
# which would break DNS records and any dependent configuration.
# ============================================================
resource "aws_eip" "my_eip" {
  instance = aws_instance.btp_app_instance.id
  domain   = "vpc"

  tags = {
    Name = "ec2-eip"
  }
}
