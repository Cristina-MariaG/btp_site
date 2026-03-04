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
# SSH KEY PAIR
# Registers the local public key on AWS.
# The corresponding private key must be kept secure locally
# and will be used to authenticate SSH connections.
# ============================================================
resource "aws_key_pair" "btp_app_key" {
  key_name   = "btp_app_key"
  public_key = file(var.public_key_path)  # reads the public key from the local filesystem
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
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
  EOF

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
  instance = aws_instance.my_instance.id
  domain   = "vpc"

  tags = {
    Name = "ec2-eip"
  }
}
