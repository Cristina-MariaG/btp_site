
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
  default     = "ami-0f3f2cef1fc7d0edb"  # Ubuntu 22.04 LTS - Paris
}

variable "key_name" {
  description = "Nom de la key pair AWS "
  type        = string
  default     = "btp_app_key"
}

variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
  default     = "btp_app"
}
