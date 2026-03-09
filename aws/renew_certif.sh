#!/bin/bash

# Script de renouvellement du certificat SSL
# Exécuté automatiquement par le cron tous les 3 mois
# Domaine : btp.iamcristinadev.xyz

set -e

REMOTE_DIR="/home/ubuntu"
LOG_DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "=========================================="
echo "🔐 [$LOG_DATE] Renouvellement SSL"
echo "=========================================="

cd $REMOTE_DIR

# ==============================
# Renouveler le certificat
# ==============================
echo "📋 Tentative de renouvellement..."
docker compose run --rm certbot renew --non-interactive

echo "✓ Certificat renouvelé"

# ==============================
# Redémarrer nginx pour prendre
# en compte le nouveau certificat
# ==============================
echo "🔄 Redémarrage de nginx..."
docker compose restart webserver

echo "✓ Nginx redémarré"
echo "✅ Renouvellement terminé avec succès"