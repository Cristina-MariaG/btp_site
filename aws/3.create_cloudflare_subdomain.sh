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
# VARIABLES
# ============================================================
SUBDOMAIN="btp"
DOMAIN="iamcristinadev.xyz"

# Récupère l'IP depuis Terraform
INSTANCE_IP=$(terraform -chdir=./terraform output -raw elastic_ip)
echo "🌐 IP récupérée depuis Terraform : $INSTANCE_IP"
echo ""

# ============================================================
# VÉRIFIER SI LE RECORD DNS EXISTE DÉJÀ
# ============================================================
echo "🔍 Vérification si le sous-domaine $SUBDOMAIN.$DOMAIN existe déjà..."

EXISTING=$(curl -s --max-time 10 -X GET \
  "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$SUBDOMAIN.$DOMAIN" \
  -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
  -H "Content-Type: application/json")

RECORD_ID=$(echo $EXISTING | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
EXISTING_IP=$(echo $EXISTING | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4)

# ============================================================
# CAS 1 : Le record existe déjà
# ============================================================
if [ -n "$RECORD_ID" ]; then
  echo "⚠️  Sous-domaine déjà existant : $SUBDOMAIN.$DOMAIN → $EXISTING_IP"

  if [ "$EXISTING_IP" == "$INSTANCE_IP" ]; then
    echo "✅ L'IP est déjà correcte ($INSTANCE_IP), rien à faire."
    exit 0
  fi

  echo "🔄 Mise à jour du record DNS : $EXISTING_IP → $INSTANCE_IP"

  RESPONSE=$(curl -s --max-time 10 -X PUT \
    "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"A\",
      \"name\": \"$SUBDOMAIN\",
      \"content\": \"$INSTANCE_IP\",
      \"ttl\": 1,
      \"proxied\": true
    }")

  SUCCESS=$(echo $RESPONSE | grep -o '"success":true')

  if [ -n "$SUCCESS" ]; then
    echo "✅ Record mis à jour : $SUBDOMAIN.$DOMAIN → $INSTANCE_IP"
  else
    echo "❌ Erreur lors de la mise à jour :"
    echo $RESPONSE
    exit 1
  fi

# ============================================================
# CAS 2 : Le record n'existe pas — on le crée
# ============================================================
else
  echo "➕ Aucun record trouvé, création du sous-domaine..."

  RESPONSE=$(curl -s --max-time 10 -X POST \
    "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"A\",
      \"name\": \"$SUBDOMAIN\",
      \"content\": \"$INSTANCE_IP\",
      \"ttl\": 1,
      \"proxied\": true
    }")

  SUCCESS=$(echo $RESPONSE | grep -o '"success":true')

  if [ -n "$SUCCESS" ]; then
    echo "✅ Sous-domaine créé : $SUBDOMAIN.$DOMAIN → $INSTANCE_IP"
  else
    echo "❌ Erreur lors de la création :"
    echo $RESPONSE
    exit 1
  fi
fi

# ============================================================
# VÉRIFICATION DNS
# ============================================================
echo ""
echo "🔍 Vérification DNS..."
sleep 5
# nslookup $SUBDOMAIN.$DOMAIN 8.8.8.8