#!/bin/bash

# Deployment script for btp.iamcristinadev.xyz
# Separate EC2 instance from portfolio

set -e

# ==============================
# VARIABLES DE CONFIGURATION
# ==============================
AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./terraform output -raw elastic_ip)                        # récupéré depuis terraform output
SSH_KEY="~/.ssh/btp_app_key"
DOCKER_COMPOSE_FILE="../docker-compose.prod.yml"
REMOTE_DIR="/home/ubuntu/"
EMAIL_ADDRESS="arcusi.cristina95@gmail.com"
DOMAIN="btp.iamcristinadev.xyz"

# # Vérifier que les fichiers existent
# if [ ! -f ".env.production" ]; then
#     echo "❌ ERREUR: Le fichier .env.production n'existe pas!"
#     exit 1
# fi

if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "❌ ERREUR: Le fichier docker-compose.prod.yml n'existe pas!"
    exit 1
fi

echo "=========================================="
echo "🚀 DÉPLOIEMENT BTP — $DOMAIN"
echo "=========================================="
echo ""

# ==============================
# ÉTAPE 1 : Créer les dossiers
# ==============================
echo "📁 Création des dossiers sur le serveur..."
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << 'EOF'
    mkdir -p /home/ubuntu/nginx/conf
    mkdir -p /home/ubuntu/certbot/www
    mkdir -p /home/ubuntu/certbot/conf
    echo "✓ Dossiers créés"
EOF

# ==============================
# ÉTAPE 2 : Copier les fichiers
# ==============================
echo ""
echo "📤 Copie des fichiers sur le serveur..."

scp -i $SSH_KEY $DOCKER_COMPOSE_FILE $AWS_USER@$AWS_HOST:$REMOTE_DIR/docker-compose.yml
echo "✓ docker-compose.yml copié"

# scp -i $SSH_KEY ./.env.production $AWS_USER@$AWS_HOST:$REMOTE_DIR/.env.production
# echo "✓ .env.production copié"

scp -i $SSH_KEY ./nginx_config/btp_iamcristinadev_xyz1.conf $AWS_USER@$AWS_HOST:$REMOTE_DIR/nginx/conf/btp.iamcristinadev.conf
echo "✓ Configuration nginx (pré-SSL) copiée"

# ==============================
# ÉTAPE 3 : Sécuriser .env
# ==============================
# echo ""
# echo "🔒 Sécurisation du fichier .env..."
# ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << EOF
#     chmod 600 $REMOTE_DIR/.env.production
#     chown ubuntu:ubuntu $REMOTE_DIR/.env.production
#     echo "✓ Permissions 600 appliquées"
# EOF

# ==============================
# ÉTAPE 4 : Démarrer Docker
# ==============================
echo ""
echo "🐋 Démarrage de Docker Compose..."
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << EOF
    cd $REMOTE_DIR
    docker compose up -d
    echo "✓ Docker Compose démarré"
EOF

echo "⏳ Attente du démarrage complet..."
sleep 10

# ==============================
# ÉTAPE 5 : Générer SSL
# ==============================
echo ""
echo "🔐 Génération du certificat SSL..."
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << EOF
    cd $REMOTE_DIR
    docker compose run --rm certbot certonly \
        --webroot \
        --webroot-path /var/www/certbot/ \
        -d $DOMAIN \
        --email $EMAIL_ADDRESS \
        --agree-tos \
        --non-interactive
    echo "✓ Certificat SSL généré"
EOF

# ==============================
# ÉTAPE 6 : Config nginx avec SSL
# ==============================
echo ""
echo "📝 Mise à jour de la configuration nginx avec SSL..."
scp -i $SSH_KEY ./nginx_config/btp_iamcristinadev_xyz2.conf $AWS_USER@$AyWS_HOST:$REMOTE_DIR/nginx/conf/btp.iamcristinadev.conf
echo "✓ Configuration nginx (avec SSL) copiée"

# ==============================
# ÉTAPE 7 :  Redémarrer Docker
# ==============================
echo ""
echo "🔄 Redémarrage de Docker avec la nouvelle configuration..."
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << EOF
    cd $REMOTE_DIR
    docker compose restart
    echo "✓ Docker redémarré"
EOF
# ==============================
# ÉTAPE 8 :   Script de renouvellement
# ==============================

echo ""
echo "📜 Copie du script de renouvellement SSL..."
scp -i $SSH_KEY ./renew_certif.sh $AWS_USER@$AWS_HOST:$REMOTE_DIR/renew_certif.sh
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST "chmod +x $REMOTE_DIR/renew_certif.sh"
echo "✓ Script de renouvellement copié"

# ==============================
# ÉTAPE 9 : Configurer Cron
# ==============================
echo ""
read -p "Configurer le renouvellement automatique SSL (cron) ? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⏰ Configuration du cron..."
    ssh -i $SSH_KEY $AWS_USER@$AWS_HOST << 'EOF'
        sudo apt-get update -qq
        sudo apt-get install -y cron
        sudo systemctl enable cron
        sudo systemctl start cron
        (crontab -l 2>/dev/null | grep -v "renew_certif.sh"; echo "0 0 1 */3 * /home/ubuntu/renew_certif.sh >> /home/ubuntu/ssl_renew.log 2>&1") | crontab -
        echo "✓ Cron configuré (renouvellement tous les 3 mois)"
EOF
fi

# ==============================
# ÉTAPE 10 : Vérification finale
# ==============================
echo ""
echo "=========================================="
echo "✅ DÉPLOIEMENT TERMINÉ AVEC SUCCÈS"
echo "=========================================="
echo ""
echo "🌐 Votre site est disponible sur :"
echo "   https://$DOMAIN"
echo ""
echo "📊 État des conteneurs :"
ssh -i $SSH_KEY $AWS_USER@$AWS_HOST "cd $REMOTE_DIR && docker compose ps"
echo ""
echo "🔧 Commandes utiles :"
echo "   Voir les logs : ssh -i $SSH_KEY $AWS_USER@$AWS_HOST 'cd $REMOTE_DIR && docker compose logs -f'"
echo "   Redémarrer   : ssh -i $SSH_KEY $AWS_USER@$AWS_HOST 'cd $REMOTE_DIR && docker compose restart'"