# ============================================================
# OUTPUTS
# Affiche les infos importantes après le terraform apply
# ============================================================

output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.btp_app_instance.id
}

output "elastic_ip" {
  description = "IP publique fixe de l'instance"
  value       = aws_eip.my_eip.public_ip
}

output "ssh_command" {
  description = "Commande SSH pour se connecter"
  value       = "ssh -i /home/arcus/.ssh/btp_app_key -p 2222 ubuntu@${aws_eip.my_eip.public_ip}"
}

