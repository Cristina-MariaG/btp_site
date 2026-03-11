#!/bin/bash

# Installation de fail2ban et blocage des IPs de bots sur EC2

set -e

# ==============================
# VARIABLES
# ==============================
AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./aws/terraform output -raw elastic_ip)
SSH_KEY="~/.ssh/btp_app_key"
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -p 2222"

# IPs de bots connus à bloquer
BOT_IPS=(
    "80.94.95.0/24"       # Bots scanning massifs
    "185.220.101.0/24"    # Tor exit nodes / bots
    "194.165.16.0/24"     # Bots agressifs
    "45.155.205.0/24"     # Scanners
    "179.43.128.0/24"     # Spam bots
    "193.32.162.0/24"     # Crawlers malveillants
    "91.108.4.0/22"       # Bots Telegram
    "5.188.206.0/24"      # Bots russes connus
    "62.233.50.0/24"      # Scanners de ports
    "195.54.160.0/24"     # Bots agressifs
)

echo "=========================================="
echo "🛡️  INSTALLATION FAIL2BAN + BLOCAGE BOTS"
echo "   $AWS_HOST"
echo "=========================================="

ssh $SSH_OPTS $AWS_USER@$AWS_HOST << 'ENDSSH'

    # ==============================
    # ÉTAPE 1 : Installation
    # ==============================
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Installation de fail2ban..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo apt-get update -qq
    sudo apt-get install -y fail2ban
    echo "✓ fail2ban installé"

    # ==============================
    # ÉTAPE 2 : Configuration
    # ==============================
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚙️  Configuration de fail2ban..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[DEFAULT]
# Bannir 24h
bantime  = 86400
# Fenêtre de détection : 10 minutes
findtime = 600
# Nombre de tentatives avant ban
maxretry = 5
# Backend de log
backend  = systemd

# Ignorer les IPs locales
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled  = true
port     = ssh
logpath  = %(sshd_log)s
maxretry = 3
bantime  = 86400

[nginx-http-auth]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/error.log
maxretry = 5

[nginx-botsearch]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/access.log
maxretry = 2
bantime  = 86400

[nginx-badbots]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/access.log
maxretry = 1
bantime  = 604800

EOF

    echo "✓ Configuration fail2ban créée"

    # ==============================
    # ÉTAPE 3 : Filtre bots nginx
    # ==============================
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 Création du filtre bots nginx..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    sudo tee /etc/fail2ban/filter.d/nginx-badbots.conf > /dev/null << 'EOF'
[Definition]
badbotscustom = Baiduspider|Yandex|Sogou|EasouSpider|BLEXBot|MJ12bot|AhrefsBot|SemrushBot|DotBot|MegaIndex|Exabot|ia_archiver|ZmEu|Nikto|sqlmap|Havij|Acunetix|Nessus|Nmap|masscan|zgrab
failregex = ^<HOST> .* "(GET|POST|HEAD).*HTTP.*" .* ".*(?:%(badbotscustom)s).*"$
ignoreregex =
EOF

    echo "✓ Filtre bots créé"

    # ==============================
    # ÉTAPE 4 : Démarrage
    # ==============================
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Démarrage de fail2ban..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo systemctl enable fail2ban
    sudo systemctl restart fail2ban
    echo "✓ fail2ban démarré"

ENDSSH

# ==============================
# ÉTAPE 5 : Blocage IPs de bots
# ==============================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚫 Blocage des IPs de bots connus..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for IP in "${BOT_IPS[@]}"; do
    ssh $SSH_OPTS $AWS_USER@$AWS_HOST "sudo iptables -I INPUT -s $IP -j DROP && echo '✓ Bloqué : $IP'"
done

# ==============================
# ÉTAPE 6 : Persister iptables
# ==============================
ssh $SSH_OPTS $AWS_USER@$AWS_HOST << 'ENDSSH'

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💾 Persistance des règles iptables..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | sudo debconf-set-selections
    echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | sudo debconf-set-selections
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent -qq
    sudo netfilter-persistent save
    echo "✓ Règles sauvegardées"

    # ==============================
    # ÉTAPE 7 : Vérification
    # ==============================
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔍 État de fail2ban..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo fail2ban-client status
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔍 Règles iptables actives..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo iptables -L INPUT -n --line-numbers | head -30

ENDSSH

echo ""
echo "=========================================="
echo "✅ Fail2ban installé et bots bloqués !"
echo "=========================================="
echo ""
echo "🔧 Commandes utiles sur le serveur :"
echo "   Status global    : sudo fail2ban-client status"
echo "   Status nginx     : sudo fail2ban-client status nginx-badbots"
echo "   Status ssh       : sudo fail2ban-client status sshd"
echo "   IPs bannies      : sudo fail2ban-client banned"
echo "   Débannir une IP  : sudo fail2ban-client set sshd unbanip <IP>"
echo "   Logs             : sudo tail -f /var/log/fail2ban.log"