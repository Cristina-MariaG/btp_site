#!/bin/bash

# Reset script — remet l'instance EC2 dans l'état post-création
# À utiliser en cas de problème pour repartir de zéro

set -e

# ==============================
# VARIABLES
# ==============================
AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./terraform output -raw elastic_ip)
SSH_KEY="~/.ssh/btp_app_key"

echo "=========================================="
echo "🧹 RESET DE L'INSTANCE EC2"
echo "   $AWS_HOST"
echo "=========================================="
echo ""
echo "⚠️  Cette opération va supprimer :"
echo "   - Tous les conteneurs Docker"
echo "   - Toutes les images Docker"
echo "   - Tous les volumes Docker"
echo "   - Les fichiers copiés (nginx, certbot, docker-compose...)"
echo ""
read -p "Confirmer le reset complet ? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Reset annulé."
    exit 0
fi

# ==============================
# ÉTAPE 1 : Arrêter Docker
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛑 Arrêt des conteneurs..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh -i $SSH_KEY -p 2222 $AWS_USER@$AWS_HOST << 'EOF'
    cd /home/ubuntu
    if [ -f "docker-compose.yml" ]; then
        docker compose down --volumes --remove-orphans || true
        echo "✓ Conteneurs arrêtés"
    else
        echo "⚠ Pas de docker-compose.yml trouvé, on continue..."
    fi
EOF

# ==============================
# ÉTAPE 2 : Purge Docker
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐋 Purge Docker (images, volumes, network)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh -i $SSH_KEY -p 2222 $AWS_USER@$AWS_HOST << 'EOF'
    docker stop $(docker ps -aq) 2>/dev/null || true
    docker rm -f $(docker ps -aq) 2>/dev/null || true
    docker rmi -f $(docker images -aq) 2>/dev/null || true
    docker volume rm $(docker volume ls -q) 2>/dev/null || true
    docker network prune -f 2>/dev/null || true
    docker system prune -af --volumes 2>/dev/null || true
    echo "✓ Docker entièrement purgé"
EOF

# ==============================
# ÉTAPE 3 : Supprimer les fichiers
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🗑️  Suppression des fichiers déployés..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh -i $SSH_KEY -p 2222 $AWS_USER@$AWS_HOST << 'EOF'
    rm -rf /home/ubuntu/nginx/
    rm -rf /home/ubuntu/certbot/
    rm -f  /home/ubuntu/docker-compose.yml
    rm -f  /home/ubuntu/renew_certif.sh
    rm -f  /home/ubuntu/ssl_renew.log
    sudo rm -rf  /certbot
    echo "✓ Fichiers supprimés"
EOF

# ==============================
# ÉTAPE 4 : Supprimer le cron
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏰ Suppression du cron SSL..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh -i $SSH_KEY -p 2222 $AWS_USER@$AWS_HOST << 'EOF'
    crontab -l 2>/dev/null | grep -v "renew_certif.sh" | crontab - || true
    echo "✓ Cron supprimé"
EOF

# ==============================
# ÉTAPE 5 : Vérification
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 État final de l'instance..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh -i $SSH_KEY -p 2222 $AWS_USER@$AWS_HOST << 'EOF'
    echo "--- Conteneurs Docker ---"
    docker ps -a
    echo ""
    echo "--- Images Docker ---"
    docker images
    echo ""
    echo "--- Fichiers /home/ubuntu ---"
    ls -la /home/ubuntu/
    echo ""
    echo "--- Crontab ---"
    crontab -l 2>/dev/null || echo "(vide)"
EOF

echo ""
echo "=========================================="
echo "✅ Instance remise à zéro !"
echo "   Tu peux relancer depuis le script 4 ou 5"
echo "   selon ce que tu veux refaire."
echo "=========================================="
echo ""
echo "🔁 Pour tout redéployer :"
echo "   bash ./deploy_all.sh"
echo ""
echo "🔁 Pour redéployer seulement l'app :"
echo "   bash ./5_start_app_certbot_nginx.sh"