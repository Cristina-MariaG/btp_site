#!/bin/bash

set -e

# ==============================
# VARIABLES
# ==============================
DOCKERHUB_USER="miksiei2024"
IMAGE_NAME="btp_app_prod"
IMAGE_TAG="latest"
FULL_IMAGE="$DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG"
DOCKERFILE="Dockerfile.prod"

echo "=========================================="
echo "🐋 BUILD & PUSH — $FULL_IMAGE"
echo "=========================================="
echo ""

# ==============================
# ÉTAPE 1 : Login DockerHub
# ==============================
echo "🔐 Connexion à DockerHub..."
docker login
echo "✓ Connecté à DockerHub"
echo ""

# ==============================
# ÉTAPE 2 : Build de l'image
# ==============================
echo "🔨 Build de l'image Docker..."
docker build -t $IMAGE_NAME -f $DOCKERFILE .
echo "✓ Image buildée : $IMAGE_NAME"
echo ""

# ==============================
# ÉTAPE 3 : Tag de l'image
# ==============================
echo "🏷️  Tag de l'image..."
docker tag $IMAGE_NAME $FULL_IMAGE
echo "✓ Image taguée : $FULL_IMAGE"
echo ""

# ==============================
# ÉTAPE 4 : Push sur DockerHub
# ==============================
echo "📤 Push sur DockerHub..."
docker push $FULL_IMAGE
echo "✓ Image pushée : $FULL_IMAGE"
echo ""

echo "=========================================="
echo "✅ TERMINÉ"
echo "=========================================="
echo ""
echo "🌐 Image disponible sur :"
echo "   https://hub.docker.com/r/$DOCKERHUB_USER/$IMAGE_NAME"
echo ""
echo "📥 Pour la récupérer depuis n'importe où :"
echo "   docker pull $FULL_IMAGE"
