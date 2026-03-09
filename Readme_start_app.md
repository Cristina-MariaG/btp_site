# Guide — Local Setup & Deployment

---

## Table of contents

- [Part 1 — Run locally](#part-1--run-the-project-locally)
- [Part 2 — Deploy to production](#part-2--deploy-to-production-on-aws)
- [Update the app](#update-the-app-redeploy)
- [Destroy the infrastructure](#destroy-the-infrastructure-full-shutdown)
- [Full deployment summary](#full-deployment--commands-in-order)

---

## Part 1 — Run the project locally

### Prerequisites

- Docker and Docker Compose installed
- Node.js 20+ (optional, only if you want to run without Docker)

### 1. Clone the project
```bash
git clone https://gitlab.com/ton-repo/btp-app.git
cd btp-app
```

### 2. Start with Docker
```bash
docker compose up --build
```

The app is available at **http://localhost:3030**

The source code is mounted as a volume — every change is instantly visible without rebuilding.

### 3. Stop
```bash
docker compose down
```

### 4. Rebuild after adding dependencies

If you added packages to `package.json` :
```bash
docker compose down
docker compose up --build
```

---

## Part 2 — Deploy to production on AWS

### Prerequisites
```bash
terraform --version    # >= 1.0
ansible --version      # >= 2.9
docker --version
aws configure          # enter Access Key + Secret Key + region (e.g. eu-west-3)
```

### Files to create before starting

**`.env`** (at the project root) :
```bash
# Cloudflare
CLOUDFLARE_TOKEN=your_cloudflare_token
ZONE_ID=your_cloudflare_zone_id

# Docker Hub
DOCKERHUB_USERNAME=your_dockerhub_username
DOCKERHUB_TOKEN=your_dockerhub_access_token
```

> ⚠️ This file is listed in `.gitignore` — never commit it.

---

### Step 1 — Create the EC2 instance with Terraform
```bash
./1_create_instance_with_tf_install_docker.sh
```

This script will :
- Initialize Terraform (`terraform init`)
- Create the AWS infrastructure (`terraform apply`) :
  - Generate an RSA SSH key → saved to `~/.ssh/btp_app_key` (permissions 0400)
  - Create the EC2 Ubuntu instance
  - Assign a fixed Elastic IP
  - Register the public key on AWS
- Auto-generate `ansible/inventory.ini` with the instance IP

Expected output :
```
Deployment completed successfully!
Connect to your instance with:
  ssh -i ~/.ssh/btp_app_key ubuntu@<EC2_IP>
```

> ⏳ Wait 1 to 2 minutes for the instance to fully boot before moving on.

---

### Step 2 — Install Docker on EC2 with Ansible
```bash
./2_ansible_install.sh
```

This script will :
- Connect to EC2 via SSH using the key generated in Step 1
- Run `ansible_playbook.yml`
- Install Docker and Docker Compose on the Ubuntu instance

Expected output :
```
Deployment completed successfully!
```

---

### Step 3 — Create the DNS subdomain on Cloudflare
```bash
./3_create_cloudflare_subdomain.sh
```

This script will :
- Read `CLOUDFLARE_TOKEN` and `ZONE_ID` from `.env`
- Retrieve the Elastic IP from Terraform outputs
- Create the DNS A record : `btp.iamcristinadev.xyz → EC2 IP`
- Enable the Cloudflare proxy (DDoS protection + CDN)
- Verify DNS propagation with `nslookup`

Expected output :
```
✅ Subdomain successfully created : btp.iamcristinadev.xyz → <EC2_IP>
```

> ⏳ DNS propagation may take a few minutes.

---

### Step 4 — Login to Docker Hub and push the image
```bash
./4_dockerhub_login_and_push.sh
```

This script will :
- Log in to Docker Hub using credentials from `.env`
- Build the production image from `Dockerfile.prod` (multi-stage build)
- Tag the image : `miksiei2024/btp_app_prod:latest`
- Push the image to Docker Hub

---

### Step 5 — Deploy the app, SSL and Nginx
```bash
./5_start_app_certbot_nginx.sh
```

This is the main deployment script. It connects to EC2 via SSH and automates the following steps :

**5.1** — Create folders on the server
```
/home/ubuntu/nginx/conf
/home/ubuntu/certbot/www
/home/ubuntu/certbot/conf
```

**5.2** — Copy configuration files to EC2
```
docker-compose.prod.yml
Nginx HTTP config (pre-SSL) → btp_iamcristinadev_xyz1.conf
```

**5.3** — Start Docker Compose in HTTP mode first
```bash
docker compose up -d
# App running, Nginx listening on port 80
```

**5.4** — Generate the SSL certificate with Let's Encrypt
```bash
docker compose run --rm certbot certonly \
  --webroot --webroot-path /var/www/certbot/ \
  -d btp.iamcristinadev.xyz \
  --email arcusi.cristina95@gmail.com \
  --agree-tos --non-interactive
```

**5.5** — Replace Nginx config with SSL version
```
btp_iamcristinadev_xyz2.conf replaces the HTTP config
```

**5.6** — Restart Docker with the new SSL config
```bash
docker compose restart
# Nginx now listens on 80 (redirect → HTTPS) and 443 (HTTPS)
```

**5.7** — Set up automatic SSL renewal (cron)
```
The script will ask :
"Configure automatic SSL renewal (cron) ? (y/n)" → answer y
```

Cron configured on EC2 :
```bash
0 0 1 */3 * /home/ubuntu/renew_certif.sh >> /home/ubuntu/ssl_renew.log 2>&1
```

Expected output :
```
==========================================
✅ DEPLOYMENT COMPLETED SUCCESSFULLY
==========================================
🌐 https://btp.iamcristinadev.xyz
```

---

## Update the app (redeploy)

When you make changes and want to update the live site :
```bash
# 1. Build and push the new image
./4_dockerhub_login_and_push.sh

# 2. Connect to EC2, pull the new image and restart only the app container
./update_prod_image.sh
```

`update_prod_image.sh` will :
- SSH into the EC2 instance
- Pull `miksiei2024/btp_app_prod:latest` from Docker Hub
- Recreate only the app container (Nginx and Certbot are not affected)
- Remove old dangling images

---

## Destroy the infrastructure (full shutdown)

To delete the EC2 instance and avoid unnecessary AWS costs :
```bash
./destroy_instance.sh
```

> ⚠️ This permanently deletes the EC2 instance and the Elastic IP. All data on the server will be lost.

---

## Full deployment — commands in order
```bash
# Step 1 — Create EC2 with Terraform
./1_create_instance_with_tf_install_docker.sh

# ⏳ Wait 1-2 min for EC2 to boot

# Step 2 — Install Docker with Ansible
./2_ansible_install.sh

# Step 3 — Create DNS subdomain on Cloudflare
./3_create_cloudflare_subdomain.sh

# ⏳ Wait for DNS propagation

# Step 4 — Login to Docker Hub and push image
./4_dockerhub_login_and_push.sh

# Step 5 — Deploy app + SSL + Nginx
./5_start_app_certbot_nginx.sh

# ✅ Site live at https://btp.iamcristinadev.xyz
```

Or run everything at once :
```bash
./deploy_all.sh
```