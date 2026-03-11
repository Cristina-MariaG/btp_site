#!/bin/bash

set -e

# ==============================
# VARIABLES
# ==============================
DOCKERHUB_USER="miksiei2024"
SSH_KEY="~/.ssh/btp_app_key"
AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./terraform output -raw elastic_ip)

# Charger les variables depuis .env
source .env

# Vérifier que le token est présent
if [ -z "$DOCKERHUB_TOKEN" ]; then
  echo "❌ DOCKERHUB_TOKEN manquant dans le fichier .env"
  exit 1
fi

# ==============================
# ÉTAPE 1 : Login Docker Hub en local
# ==============================
echo "🔐 Connexion à Docker Hub en local..."
echo "$DOCKERHUB_TOKEN" | docker login -u $DOCKERHUB_USER --password-stdin
echo "✓ Connecté en local"
echo ""

# ==============================
# ÉTAPE 2 : Login Docker Hub sur l'EC2
# ==============================
echo "🔐 Connexion à Docker Hub sur l'EC2 ($AWS_HOST)..."
ssh -i $SSH_KEY  -p 2222  -o StrictHostKeyChecking=no $AWS_USER@$AWS_HOST << EOF
  echo "$DOCKERHUB_TOKEN" | docker login -u $DOCKERHUB_USER --password-stdin
  echo "✓ Connecté sur l'EC2"
EOF

echo ""
echo "✅ Login Docker Hub effectué en local et sur l'EC2"