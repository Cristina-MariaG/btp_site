#!/bin/bash

# Update de l'image de production sur EC2

set -e

# ==============================
# VARIABLES
# ==============================
AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./aws/terraform output -raw elastic_ip)
SSH_KEY="~/.ssh/btp_app_key"
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -p 2222"
IMAGE="miksiei2024/btp_app_prod:latest"

echo "=========================================="
echo "🔄 UPDATE IMAGE PROD — $IMAGE"
echo "   $AWS_HOST"
echo "=========================================="

ssh $SSH_OPTS $AWS_USER@$AWS_HOST << EOF

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📥 Pull de la nouvelle image..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker pull $IMAGE
    echo "✓ Image mise à jour"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "♻️  Redémarrage du conteneur app..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker compose up -d --no-deps --force-recreate btp_app_prod
    echo "✓ Conteneur relancé avec la nouvelle image"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🗑️  Suppression des anciennes images..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker images miksiei2024/btp_app_prod --filter "dangling=true" -q | xargs -r docker rmi
    echo "✓ Anciennes images supprimées"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 État des conteneurs"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker compose ps

EOF

echo ""
echo "=========================================="
echo "✅ Image mise à jour avec succès !"
echo "   🌐 https://btp.iamcristinadev.xyz"
echo "=========================================="