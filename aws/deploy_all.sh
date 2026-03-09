#!/bin/bash
set -e

# Répertoire où se trouve deploy_all.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo $SCRIPT_DIR
echo "=========================================="
echo "  🚀 DÉPLOIEMENT COMPLET — BTP App"
echo "=========================================="

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 ÉTAPE 1/6 — Création de l'instance EC2"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/1.create_instance_with_tf_install_docker.sh"

echo ""
echo "⏳ Attente 30s — boot de l'EC2..."
sleep 30

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 ÉTAPE 2/6 — Installation de Docker"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/2.ansible_install.sh"

echo ""
echo "⏳ Attente 10s..."
sleep 10

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 ÉTAPE 3/6 — Création du sous-domaine Cloudflare"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/3.create_cloudflare_subdomain.sh"

echo ""
echo "⏳ Attente 20s — propagation DNS..."
sleep 20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📤 ÉTAPE 4/6 — Login Docker Hub + push image"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/4.dockerhub_login.sh"

echo ""
echo "⏳ Attente 10s..."
sleep 10

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 ÉTAPE 5/6 — Déploiement app + SSL + Nginx"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/5.start_app_certbot_nginx.sh"

echo ""
echo "⏳ Attente 10s..."
sleep 10

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛡️  ÉTAPE 6/6 — Installation Fail2ban + blocage bots"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
bash "$SCRIPT_DIR/6.install_fail2ban.sh"

echo ""
echo "=========================================="
echo "  ✅ Déploiement terminé !"
echo "  🌐 https://btp.iamcristinadev.xyz"
echo "=========================================="