
# 🏗️ BTP Showcase Website — Pro Rénovation

> **Vue 3 · Docker · Terraform · Ansible · GitLab CI/CD · AWS EC2 · Nginx · SSL · Cloudflare · Fail2ban**

![Vue](https://img.shields.io/badge/Vue.js-3-4FC08D?logo=vue.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)
![Tailwind](https://img.shields.io/badge/Tailwind_CSS-06B6D4?logo=tailwindcss&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS_EC2-FF9900?logo=amazonaws&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?logo=nginx&logoColor=white)
![GitLab CI](https://img.shields.io/badge/GitLab_CI-FC6D26?logo=gitlab&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=cloudflare&logoColor=white)
![Let's Encrypt](https://img.shields.io/badge/SSL-Let's_Encrypt-003A70?logo=letsencrypt&logoColor=white)
![Fail2ban](https://img.shields.io/badge/Fail2ban-EE0000?logoColor=white)


Showcase website for a BTP renovation company. The project covers the full cycle : design (Figma), frontend development, Docker containerization, and fully automated deployment on AWS via Terraform, Ansible and shell scripts.

🌐 **[btp.iamcristinadev.xyz](https://btp.iamcristinadev.xyz)**

---
## 🎯 About this project

Beyond the frontend, the main focus was building a **complete automated 
deployment pipeline** — from a single command on a local machine to a 
live, secured, SSL-enabled production site on AWS.

Key achievements :
- Full Infrastructure as Code with Terraform (EC2, Elastic IP, Security Groups)
- Zero-downtime deployment pipeline with 6 automated scripts
- End-to-end SSL encryption (Let's Encrypt + Cloudflare)
- Server hardening with Fail2ban and UFW

---

## 📋 Table of contents

- [Tech stack](#tech-stack)
- [Project architecture](#project-architecture)
- [Docker environments](#docker-environments)
- [Automated deployment](#automated-deployment)
- [Scripts — Usage guide](#scripts--usage-guide)
- [Environment variables](#environment-variables)
- [SSL renewal](#ssl-renewal)
- [Useful commands](#useful-commands)
- [Security](#security)

---

## Tech stack

| Layer | Technology |
|---|---|
| Frontend | Vue 3 + Vite + TypeScript |
| Styles | Tailwind CSS |
| Containerization | Docker + Docker Compose |
| Infrastructure | Terraform (AWS EC2 + Elastic IP) |
| Server configuration | Ansible |
| CI/CD | GitLab Pipelines |
| Registry | Docker Hub |
| Cloud | AWS EC2 (Ubuntu) |
| Reverse proxy | Nginx |
| SSL | Let's Encrypt via Certbot |
| DNS | Cloudflare |
| Security | Fail2ban + iptables |

---

## Project architecture

### Root structure

```
BTP_APP/
├── aws/                                         # All infrastructure, deployment scripts, and server configuration
├── doc_photos/                                  # Screenshots and visuals used in documentation
├── src/                                         # Vue 3 application source code (components, views, assets)
├── node_modules/                                # npm dependencies — auto-generated, never committed
├── .gitignore                                   # Files and folders excluded from Git versioning
├── build_and_push_dockerhub_prod_image.sh       # Builds the prod Docker image and pushes it to Docker Hub
├── docker-compose.prod.yml                      # Docker Compose config for production (EC2) — 3 services: app, nginx, certbot
├── docker-compose.yml                           # Docker Compose config for local development with hot-reload
├── Dockerfile                                   # Dev Docker image — node:20-alpine + Vite dev server
├── Dockerfile.prod                              # Prod Docker image — multi-stage build, outputs only compiled /dist
├── index.html                                   # HTML entry point loaded by Vite
├── package.json                                 # Project metadata, dependencies and npm scripts
├── package-lock.json                            # Locked dependency tree for reproducible installs
├── postcss.config.js                            # PostCSS config used by Tailwind CSS
├── tailwind.config.js                           # Tailwind CSS configuration — custom theme, purge paths
├── tsconfig.json                                # TypeScript compiler config for the app
├── tsconfig.node.json                           # TypeScript compiler config for Vite and Node tooling
├── update_prod_image.sh                         # SSH into EC2, pulls the latest Docker Hub image and recreates the app container
├── vite.config.ts                               # Vite bundler config — plugins, aliases, dev server port
└── README.md                                    # Project documentation
```

### AWS folder — Infrastructure & deployment

```
aws/
├── terraform/                                   # Terraform config — provisions EC2 instance and Elastic IP on AWS
├── ansible/
│   ├── ansible_playbook.yml                     # Ansible playbook — installs Docker and dependencies on EC2
│   └── inventory.ini                            # EC2 host file auto-generated by script 1 with the instance IP
├── nginx_config/
│   ├── btp_iamcristinadev_xyz1.conf             # Nginx config used before SSL — HTTP only, exposes /.well-known for Certbot challenge
│   └── btp_iamcristinadev_xyz2.conf             # Nginx config with SSL — HTTPS, redirects HTTP→HTTPS, proxies to app on port 3030
├── docker-compose.prod.yml                      # Production Compose file — orchestrates app, Nginx reverse proxy and Certbot
├── 1_create_instance_with_tf_install_docker.sh  # Runs Terraform to create EC2 + Elastic IP, generates SSH key and Ansible inventory
├── 2_ansible_install.sh                         # Runs Ansible playbook to install Docker on the EC2 instance via SSH
├── 3_create_cloudflare_subdomain.sh             # Creates DNS A record on Cloudflare via API — points subdomain to EC2 Elastic IP
├── 4_dockerhub_login_and_push.sh                # Logs in to Docker Hub, builds prod image with Dockerfile.prod and pushes it
├── 5_start_app_certbot_nginx.sh                 # Full deployment on EC2 — copies files, starts Docker, generates SSL cert, configures cron
├── 6_install_fail2ban.sh                        # Installs Fail2ban on EC2, configures SSH/Nginx jails and blocks known bot IPs via iptables
├── deploy_all.sh                                # Runs scripts 1 to 6 in order with sleep delays between each step
├── destroy_instance.sh                          # Destroys all AWS infrastructure via terraform destroy — stops billing
├── renew_certif.sh                              # Copied to EC2 — renews Let's Encrypt cert via Certbot and reloads Nginx
├── build_and_push_dockerhub_image.sh            # Alias script to build and push the Docker image independently of the full deploy
└── .env                                         # Secret variables (Cloudflare token, Docker Hub credentials) — never committed
```

---

## Docker environments

### Local development

The `Dockerfile` uses the `node:20-alpine` image and starts the Vite dev server. The source code is mounted as a **bind volume** to enable hot-reload : every file change is immediately visible without rebuilding.

```bash
docker compose up --build
# Available at http://localhost:3030
```

```yaml
# docker-compose.yml
volumes:
  - .:/app                    # bind mount → hot reload
  - /app/node_modules         # isolates container node_modules
environment:
  - CHOKIDAR_USEPOLLING=true  # forces file change detection
```

### Production

The `Dockerfile.prod` uses a **multi-stage build** :

- **Stage 1 (builder)** : installs dependencies and compiles the Vue app with `vite build`
- **Stage 2 (final)** : copies only the compiled `/dist` folder, without node_modules or source code

The final image is lightweight and secure — the attack surface is minimal. It is served via the `serve` package.

```bash
# Build and push the prod image to Docker Hub
./build_and_push_dockerhub_image.sh
```

The production docker-compose orchestrates **3 services** :

| Service | Role |
|---|---|
| `btp_app_prod` | Serves the compiled Vue.js app on port 3030 (Docker Hub image) |
| `webserver` (Nginx) | Reverse proxy — listens on 80/443, redirects HTTP→HTTPS |
| `certbot` | Generates and renews Let's Encrypt SSL certificates |

---

## Automated deployment

The full deployment is done with **6 numbered scripts**, to be run in order. Each script is standalone and does one specific thing.

```
[LOCAL] Script 1 → Terraform creates EC2 + generates Ansible inventory
[LOCAL] Script 2 → Ansible installs Docker on EC2
[LOCAL] Script 3 → Cloudflare : DNS subdomain creation
[LOCAL] Script 4 → Docker Hub : login + build + push image
[LOCAL] Script 5 → Full deployment : app + SSL + Nginx + cron
[LOCAL] Script 6 → Fail2ban installation + bot IP blocking
```

Or use the all-in-one script:

```
[LOCAL] deploy_all.sh → Runs scripts 1 to 6 in order, with pauses between steps
```

### Deployment flow overview

```
Source code
    │
    ▼
Script 1 — Terraform
    │  terraform init + apply
    │  → EC2 Ubuntu created
    │  → Elastic IP assigned
    │  → SSH key generated (~/.ssh/btp_app_key)
    │  → Ansible inventory.ini auto-generated
    ▼
Script 2 — Ansible
    │  ansible-playbook ansible_playbook.yml
    │  → Docker installed on EC2
    ▼
Script 3 — Cloudflare DNS
    │  Cloudflare API
    │  → A record created : btp.iamcristinadev.xyz → EC2 IP
    ▼
Script 4 — Docker Hub
    │  docker login
    │  docker build (Dockerfile.prod)
    │  docker push → Docker Hub
    ▼
Script 5 — Final deployment
    │  scp → copies docker-compose.prod.yml + Nginx config to EC2
    │  docker compose up -d (HTTP first)
    │  certbot → SSL certificate generation (Let's Encrypt)
    │  scp → Nginx config with SSL
    │  docker compose restart
    │  cron → automatic SSL renewal every 3 months
    ▼
Script 6 — Fail2ban
    │  fail2ban installed and configured
    │  → SSH jail (max 3 attempts → 24h ban)
    │  → Nginx jails (badbots, botsearch, http-auth)
    │  → Known bot IPs blocked via iptables
    │  → Rules persisted with iptables-persistent
    ▼
✅ https://btp.iamcristinadev.xyz
```

---

## Scripts — Usage guide

### Prerequisites

```bash
# Required tools
terraform --version    # >= 1.0
ansible --version      # >= 2.9
docker --version
aws configure          # AWS credentials configured
```

---

### `1_create_instance_with_tf_install_docker.sh`

Initializes and applies the Terraform configuration to create the AWS infrastructure :
- Generates an RSA SSH key and saves it to `~/.ssh/btp_app_key`
- Creates the EC2 Ubuntu instance with a fixed Elastic IP
- Registers the public key on AWS
- Automatically generates the `ansible/inventory.ini` file with the instance IP

```bash
./1_create_instance_with_tf_install_docker.sh
```

---

### `2_ansible_install.sh`

Runs the Ansible playbook that connects to EC2 via SSH and installs Docker. Uses the `inventory.ini` generated by the previous script. The `StrictHostKeyChecking=no` option skips the host confirmation prompt for the new instance.

```bash
./2_ansible_install.sh
```

---

### `3_create_cloudflare_subdomain.sh`

Automatically creates the DNS record on Cloudflare via their REST API :
- Retrieves the Elastic IP from Terraform outputs
- Creates an `A` record : `btp.iamcristinadev.xyz → EC2 IP`
- Enables the Cloudflare proxy (DDoS protection + CDN)
- Verifies DNS propagation with `nslookup`

```bash
./3_create_cloudflare_subdomain.sh
```

> Requires `CLOUDFLARE_TOKEN` and `ZONE_ID` in the `.env` file

---

### `4_dockerhub_login_and_push.sh`

Authenticates to Docker Hub, builds the production image and pushes it to the registry :
- Logs in to Docker Hub with the credentials defined in `.env`
- Builds the production image using `Dockerfile.prod` (multi-stage build)
- Tags and pushes the image to `miksiei2024/btp_app_prod:latest`

```bash
./4_dockerhub_login_and_push.sh
```

> Requires `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` in the `.env` file

---

### `5_start_app_certbot_nginx.sh`

Main deployment script — connects to EC2 via SSH and automates 10 steps :

1. Creates folders (`nginx/conf`, `certbot/www`, `certbot/conf`)
2. Copies `docker-compose.prod.yml` to the server
3. Copies the HTTP Nginx config (pre-SSL)
4. Starts Docker Compose
5. Generates the SSL certificate via Certbot (webroot challenge)
6. Copies the HTTPS Nginx config (with SSL)
7. Restarts Docker with the new config
8. Copies the SSL renewal script
9. Configures the cron job (renewal every 3 months) — optional
10. Final check and display of container status

```bash
./5_start_app_certbot_nginx.sh
```

---

### `6_install_fail2ban.sh`

Installs and configures Fail2ban on the EC2 instance to protect against brute-force attacks and malicious bots :
- Installs Fail2ban via apt
- Configures jails : SSH (max 3 attempts), Nginx bad bots, Nginx botsearch, Nginx HTTP auth
- Creates a custom filter for known malicious user agents (AhrefsBot, SemrushBot, sqlmap, Nikto, etc.)
- Blocks known bot IP ranges via `iptables`
- Persists iptables rules across reboots with `iptables-persistent`

```bash
./6_install_fail2ban.sh
```

Useful commands on the server after installation :
```bash
sudo fail2ban-client status               # global status
sudo fail2ban-client status nginx-badbots # banned IPs for nginx
sudo fail2ban-client status sshd          # banned IPs for SSH
sudo fail2ban-client banned               # all banned IPs
sudo tail -f /var/log/fail2ban.log        # live logs
```

---

### `deploy_all.sh`

Runs all 6 scripts in order with pauses between each step, allowing the infrastructure time to initialize and DNS to propagate.

```bash
./deploy_all.sh
```

```bash
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "  🚀 FULL DEPLOYMENT — BTP App"
echo "========================================"

echo "▶ [1/6] Terraform — Creating EC2 instance..."
bash "$SCRIPT_DIR/1_create_instance_with_tf_install_docker.sh"

echo "⏳ Waiting 30s for EC2 to boot..."
sleep 30

echo "▶ [2/6] Ansible — Installing Docker on EC2..."
bash "$SCRIPT_DIR/2_ansible_install.sh"

echo "⏳ Waiting 10s..."
sleep 10

echo "▶ [3/6] Cloudflare — Creating DNS subdomain..."
bash "$SCRIPT_DIR/3_create_cloudflare_subdomain.sh"

echo "⏳ Waiting 20s for DNS propagation..."
sleep 20

echo "▶ [4/6] Docker Hub — Login, build and push image..."
bash "$SCRIPT_DIR/4_dockerhub_login_and_push.sh"

echo "⏳ Waiting 10s..."
sleep 10

echo "▶ [5/6] EC2 — Starting app, SSL and Nginx..."
bash "$SCRIPT_DIR/5_start_app_certbot_nginx.sh"

echo "⏳ Waiting 10s..."
sleep 10

echo "▶ [6/6] EC2 — Installing Fail2ban + blocking bots..."
bash "$SCRIPT_DIR/6_install_fail2ban.sh"

echo "========================================"
echo "  ✅ Deployment complete!"
echo "  🌐 https://btp.iamcristinadev.xyz"
echo "========================================"
```

---

### `destroy_instance.sh`

Destroys the entire AWS infrastructure via `terraform destroy`. Use this to cleanly shut down the instance and avoid unnecessary costs.

```bash
./destroy_instance.sh
```

---

## Environment variables

Create a `.env` file at the project root (never committed — see `.gitignore`) :

```bash
# Cloudflare
CLOUDFLARE_TOKEN=your_cloudflare_api_token
ZONE_ID=your_cloudflare_zone_id

# Docker Hub
DOCKERHUB_USERNAME=your_dockerhub_username
DOCKERHUB_TOKEN=your_dockerhub_access_token
```

Create a `.env.for_scripts` file for AWS credentials (never committed) :

```bash
# AWS
Access_key=YOUR_AWS_ACCESS_KEY
Secret_access_key=YOUR_AWS_SECRET_KEY
```

> ⚠️ These files are listed in `.gitignore` and must **never** be committed to GitLab/GitHub.

---

## SSL renewal

The Let's Encrypt SSL certificate is valid for 90 days. The `renew_certif.sh` script is copied to the server during deployment and configured as an **automatic cron job every 3 months** :

```bash
# Cron configured automatically on EC2
0 0 1 */3 * /home/ubuntu/renew_certif.sh >> /home/ubuntu/ssl_renew.log 2>&1
```

The script :
1. Runs `certbot renew` via Docker
2. Restarts Nginx to load the new certificate
3. Logs the result to `ssl_renew.log`

To renew manually :
```bash
ssh -i ~/.ssh/btp_app_key ubuntu@<EC2_IP>
./renew_certif.sh
```

---

## Useful commands

```bash
# Local development
docker compose up --build               # start dev with hot-reload
docker compose down                     # stop

# Build and publish
./4_dockerhub_login_and_push.sh         # login, build and push to Docker Hub

# On EC2 (after SSH connection)
docker compose ps                       # container status
docker compose logs -f                  # live logs
docker compose logs -f webserver        # Nginx logs only
docker compose restart                  # restart all services
docker pull miksiei2024/btp_app_prod:latest && \
  docker compose up -d --no-deps btp_app_prod  # update the app

# Fail2ban
sudo fail2ban-client status             # global status
sudo fail2ban-client banned             # all banned IPs
sudo tail -f /var/log/fail2ban.log      # live logs

# SSH connection
ssh -i ~/.ssh/btp_app_key ubuntu@<EC2_IP>

# Destroy infrastructure
./destroy_instance.sh
```

---

## Security

- AWS and Cloudflare credentials are stored exclusively in local `.env` files, listed in `.gitignore`
- The SSH key is generated by Terraform and stored locally with `0400` permissions
- The app container is **not directly exposed** to the internet — only Nginx is accessible on ports 80/443
- Docker logs are configured with automatic rotation (max 10 MB × 3 files) to avoid filling the EC2 disk
- The Cloudflare proxy is enabled on the subdomain (DDoS protection + EC2 IP masking)
- Fail2ban protects SSH and Nginx against brute-force attacks and bots — automatic banning after failed attempts
- Known malicious bot IP ranges are blocked at the iptables level and persisted across reboots

---

*Cristina Ghinda — Full-Stack & DevOps Developer · [iamcristinadev.xyz](https://www.iamcristinadev.xyz)*