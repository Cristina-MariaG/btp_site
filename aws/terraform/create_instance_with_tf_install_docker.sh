#!/bin/bash

# Stop the script on any error
set -e

# Variables
KEY_NAME="btp_app_key"
KEY_FILE="/home/arcus/.ssh/${KEY_NAME}"
PUBLIC_KEY_FILE="${KEY_FILE}.pub"

# Check if the SSH key already exists
if [ ! -f "$PUBLIC_KEY_FILE" ]; then
    echo "SSH key not found, generating a new SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" # Generate a new SSH key
else
    echo "SSH key found: $KEY_FILE"
fi

# Initialize Terraform and apply the configuration to create the EC2 instance
echo "Initializing and applying Terraform..."
terraform init # Initialize Terraform
terraform apply -auto-approve # Apply Terraform configuration without manual approval

# Retrieve the public IP address of the EC2 instance
echo "Retrieving the public IP address of the EC2 instance..."
INSTANCE_IP=$(terraform output -raw elastic_ip) # Get the public IP of the instance
echo "Instance IP"
echo ${INSTANCE_IP}

# Create a dynamic Ansible inventory file
echo "Creating the Ansible inventory..."
cat > ../inventory.ini <<EOF
[awsservers]
 $INSTANCE_IP ansible_user=ubuntu
EOF

# Wait for the instance to be ready
# sleep 60 # Wait for 60 seconds to ensure the instance is ready

# # Run the Ansible playbook to install Docker
# echo "Running the Ansible playbook..."
# ansible-playbook -i inventory.ini ansible_playbook.yml --private-key ./.ssh/frontend-pre-prod --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Indicate that the deployment is complete
echo "Deployment completed successfully!"


# ansible-playbook -i inventory.ini ansible_playbook.yml --private-key  $KEY_FILE --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'


























# #!/bin/bash

# # Arrêter le script en cas d'erreur
# set -e

# # Variables
# KEY_NAME="frontend-pre-prod"
# KEY_FILE="./.ssh/${KEY_NAME}"
# PUBLIC_KEY_FILE="${KEY_FILE}.pub"

# # Vérifier si la clé SSH existe déj�
# if [ ! -f "$KEY_FILE" ]; then
#     echo "Clé SSH non trouvée, génération d'une nouvelle clé SSH..."
#     ssh-keygen -t rsa -b 4096 -f "$KEY_FILE"
# else
#     echo "Clé SSH trouvée : $KEY_FILE"
# fi

# #Initialiser Terraform et appliquer la configuration pour créer l'instance EC2
# echo "Initialisation et application de Terraform..."
# terraform init
# terraform apply -auto-approve

# # Obtenir l'adresse IP publique de l'instance EC2
# echo "Récupération de l'adresse IP publique de l'instance EC2..."
# INSTANCE_IP=$(terraform output -raw instance_public_ip)
# echo "Instance ip"
# echo ${INSTANCE_IP}

# # Créer un fichier d'inventaire Ansible dynamique
# echo "Création de l'inventaire Ansible..."
# cat > inventory.ini <<EOF
# [awsservers]
# $INSTANCE_IP ansible_user=admin
# EOF

# # Exécuter le playbook Ansible pour installer Docker
# echo "Exécution du playbook Ansible..."

# sleep 60

# ansible-playbook -i inventory.ini ansible_playbook.yml --private-key ./.ssh/frontend-pre-prod --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# echo "Déploiement terminé avec succès !"
