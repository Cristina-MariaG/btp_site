#!/bin/bash

set -e

# Load environment variables
source .env

# Check that required variables are set
if [ -z "$CLOUDFLARE_TOKEN" ] || [ -z "$ZONE_ID" ]; then
  echo "❌ CLOUDFLARE_TOKEN ou ZONE_ID manquant dans le fichier .env"
  exit 1
fi

# ============================================================
# VARIABLES — à adapter
# ============================================================
SUBDOMAIN="btp"                           # le sous-domaine à créer
DOMAIN="iamcristinadev.xyz"

# Récupère l'IP depuis Terraform
INSTANCE_IP=$(terraform -chdir=./terraform output -raw elastic_ip)
echo "IP récupérée : $INSTANCE_IP"


# ============================================================
# CRÉER LE SOUS-DOMAINE SUR CLOUDFLARE
# ============================================================
echo "Création du sous-domaine $SUBDOMAIN.$DOMAIN → $INSTANCE_IP..."

RESPONSE=$(curl -s --max-time 10 -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"A\",
    \"name\": \"$SUBDOMAIN\",
    \"content\": \"$INSTANCE_IP\",
    \"ttl\": 1,
    \"proxied\": true
  }")

echo $RESPONSE

# Vérifie si la création a réussi
SUCCESS=$(echo $RESPONSE | grep -o '"success":true')

if [ -n "$SUCCESS" ]; then
  echo "✅ Sous-domaine créé avec succès : $SUBDOMAIN.$DOMAIN → $INSTANCE_IP"
else
  echo "❌ Erreur lors de la création du sous-domaine :"
  echo $RESPONSE
  exit 1
fi

# ============================================================
# VÉRIFICATION
# ============================================================
echo "Vérification DNS..."
sleep 5
nslookup $SUBDOMAIN.$DOMAIN 8.8.8.8
