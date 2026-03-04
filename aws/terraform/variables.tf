# ============================================================
# VARIABLES
# Centralise les valeurs configurables pour ne pas les
# hardcoder dans main.tf
# ============================================================

variable "aws_region" {
  description = "Region AWS"
  type        = string
  default     = "eu-west-3"  # Paris
}

variable "ami_id" {
  description = "ID de l'AMI (image système). Ubuntu 22.04 LTS sur eu-west-3"
  type        = string
  default     = "ami-08461dc8cd9e834e0"  # Ubuntu 22.04 LTS - Paris
}

variable "public_key_path" {
  description = "Chemin vers la clé publique SSH sur ma machine"
  type        = string
  default     = "/home/arcus/.ssh/btp_app_key.pub"
}

variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
  default     = "btp_app"
}
