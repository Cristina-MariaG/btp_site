# 🔒 Security Improvements

---

## Table of contents

- [Roadmap](#roadmap)
- [1 — SSH port custom](#1--ssh-port-custom)
- [2 — UFW Firewall](#2--ufw--firewall-setup)
- [3 — Disable SSH password authentication](#3--disable-ssh-password-authentication)
- [4 — AWS SSM Session Manager](#4--aws-ssm--passwordless-connection)
- [5 — check_security.sh](#5--check_securitysh)
- [6 — UptimeRobot](#6--uptimerobot)
- [7 — S3 backend for Terraform state](#7--s3-backend-for-terraform-state)
- [8 — Pin Docker image versions](#8--pin-docker-image-versions)

---

## Roadmap

| # | Improvement | Status |
|---|---|---|
| 1 | Change default SSH port (22 → 2222) | ✅ Done |
| 2 | UFW firewall — allow only ports 80, 443, 2222 | ✅ Done |
| 3 | Disable SSH password authentication | ⏳ To do |
| 4 | AWS SSM Session Manager — connect without open SSH port | ⏳ To do |
| 5 | Add `check_security.sh` script | ⏳ To do |
| 6 | UptimeRobot — external healthcheck + email alert | ⏳ To do |
| 7 | S3 backend for Terraform state | ⏳ To do |
| 8 | Pin Docker image versions (nginx:1.27 instead of latest) | ✅ Done |

---

## 1 — SSH port custom

### Why change the default port ?

Port 22 is the default SSH port and is **constantly scanned by bots** on the internet. Changing it to a non-standard port drastically reduces automated attack attempts — not a security measure on its own, but a good first filter combined with Fail2ban and UFW.

### How to change it

```bash
# Connect to EC2
ssh -i ~/.ssh/btp_app_key ubuntu@<EC2_IP>

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

Find and change :
```
#Port 22   ← uncomment and change
Port 2222
```

Restart SSH :
```bash
sudo systemctl restart sshd
```

> ⚠️ Do NOT close your current session before testing the new port — you could lock yourself out permanently.

### Update AWS Security Group in Terraform

```hcl
# main.tf — remove port 22, add port 2222
ingress {
  from_port   = 2222
  to_port     = 2222
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

```bash
terraform apply
```

### Test before closing your session

```bash
# Open a NEW terminal and test
ssh -i ~/.ssh/btp_app_key -p 2222 ubuntu@<EC2_IP>
```

If it works → close the old session and remove port 22 from `main.tf`.

### Update all scripts

Everywhere you have `SSH_OPTS`, add `-p 2222` :

```bash
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -p 2222"
```

For `scp`, use `-P` (uppercase) :
```bash
scp -i $SSH_KEY -P 2222 -o StrictHostKeyChecking=no file ubuntu@<EC2_IP>:/home/ubuntu/
```

---

## 2 — UFW — Firewall setup

### What is UFW ?

UFW (Uncomplicated Firewall) is a firewall that runs at the **OS level** on the Ubuntu instance. It filters traffic that reaches the instance itself, on top of the AWS Security Group which filters traffic before it even reaches EC2.

```
Internet → AWS Security Group → EC2 → UFW → App
```

Having both layers is called **defense in depth** — if one layer is misconfigured, the other still protects.

### How it works

UFW works with simple allow/deny rules per port. The default policy blocks everything incoming unless explicitly allowed :

```
Port 80  → ALLOW  → HTTP traffic reaches Nginx
Port 443 → ALLOW  → HTTPS traffic reaches Nginx
Port 2222 → ALLOW → SSH connections allowed
Port 5432 → DENY  → PostgreSQL never reachable from outside
Port 3030 → DENY  → App container not directly accessible
```

### Installation

```bash
# Connect to EC2
ssh -i ~/.ssh/btp_app_key -p 2222 ubuntu@<EC2_IP>

# Install UFW
sudo apt-get install -y ufw

# Default rules — block all incoming, allow all outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow only required ports
sudo ufw allow 2222/tcp    # SSH custom port
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS

# Enable — WARNING: make sure port 2222 is allowed before running this
sudo ufw enable

# Verify
sudo ufw status verbose
```

Expected output :
```
Status: active

To           Action    From
--           ------    ----
2222/tcp     ALLOW     Anywhere
80/tcp       ALLOW     Anywhere
443/tcp      ALLOW     Anywhere
```

> ⚠️ Always allow your SSH port **before** enabling UFW — otherwise you will lock yourself out of the instance.

### UFW vs Fail2ban

Both tools are complementary and do not do the same thing :

| | UFW | Fail2ban |
|---|---|---|
| Role | Blocks entire ports | Blocks specific IPs |
| When | Before any connection | After detecting suspicious behavior |
| Example | Port 5432 blocked for everyone | IP X banned after 5 failed SSH attempts |

UFW decides **which doors are open**. Fail2ban decides **who is allowed through** those doors.

---

## 3 — Disable SSH password authentication

### Why disable it ?

Even with a custom SSH port, brute-force attacks can try to guess passwords. Disabling password authentication means **only SSH key holders can connect** — a password guess is simply impossible.

On AWS EC2, password authentication is usually disabled by default, but it's good practice to explicitly enforce it in the config.

### How to do it

```bash
# Connect to EC2
ssh -i ~/.ssh/btp_app_key -p 2222 ubuntu@<EC2_IP>

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

Find and set these lines :
```
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin no
```

Restart SSH :
```bash
sudo systemctl restart sshd
```

### Verify

```bash
# Try connecting with a password — should be refused
ssh -o PreferredAuthentications=password ubuntu@<EC2_IP> -p 2222
# Expected: Permission denied (publickey)
```

### What each option does

| Option | Value | Effect |
|---|---|---|
| `PasswordAuthentication no` | no | Disables password login entirely |
| `ChallengeResponseAuthentication no` | no | Disables keyboard-interactive auth |
| `PermitRootLogin no` | no | Root user cannot SSH in at all |

---

## 4 — AWS SSM — Passwordless connection

### What is SSM Session Manager ?

AWS SSM (Systems Manager) Session Manager allows you to connect to your EC2 instance **without any open SSH port**. The connection goes through the AWS API instead of a direct TCP connection.

```
# Classic SSH
Dev → internet → port 2222 open → EC2

# With SSM
Dev → AWS API (HTTPS) → SSM Agent on EC2 → shell session
```

**Advantages :**
- No SSH port exposed at all (port 22 or 2222 completely closed)
- Access controlled via AWS IAM — no SSH keys to manage
- Full audit trail of all sessions in AWS CloudTrail
- Perfect for teams — each developer uses their own AWS IAM credentials

### How it works technically

The SSM Agent runs on the instance and maintains a **permanent outbound HTTPS connection** to the AWS API. When you want to connect, AWS sends a signal through that existing connection — no inbound port needed :

```
EC2
└── SSM Agent
    └── outbound HTTPS → ssm.eu-west-3.amazonaws.com
        └── waiting for commands from AWS API

You → request session → AWS verifies IAM permissions
    → AWS signals SSM Agent via existing connection
    → shell session opened → you are connected
```

### Prerequisites

**1. IAM Role on the EC2 instance**

The instance needs an IAM role with the `AmazonSSMManagedInstanceCore` policy attached. Add this in your `main.tf` :

```hcl
# IAM Role for EC2
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Attach SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile to attach the role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# Attach the profile to your EC2 instance
resource "aws_instance" "btp_app" {
  # ... your existing config ...
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}
```

**2. SSM Agent on the instance**

Already pre-installed on Ubuntu 22.04 AWS AMIs. Verify :

```bash
sudo systemctl status amazon-ssm-agent
```

**3. AWS CLI + Session Manager plugin on your local machine**

```bash
# Install AWS CLI Session Manager plugin (Linux/WSL)
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
  -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb

# Verify
session-manager-plugin --version
```

### Connect via CLI

```bash
# Get your instance ID
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=btp-app" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text

# Start a session
aws ssm start-session --target i-0123456789abcdef
```

You get a shell directly on the instance — no SSH key needed.

### Connect via AWS Console

1. Go to **AWS Console → EC2 → Instances**
2. Select your instance
3. Click **Connect** (top right)
4. Choose the **Session Manager** tab
5. Click **Connect**

A browser terminal opens directly — no SSH, no key, no open port.

### Connect via SSH tunnel through SSM

If you still want to use your regular SSH tools (VSCode, scp, etc.) but through SSM :

```bash
# Add this to ~/.ssh/config
Host i-*
  ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"

# Then connect normally
ssh -i ~/.ssh/btp_app_key ubuntu@i-0123456789abcdef

# scp works too
scp -i ~/.ssh/btp_app_key file ubuntu@i-0123456789abcdef:/home/ubuntu/
```

### Use SSM in CI/CD pipeline

```yaml
# GitHub Actions — deploy without SSH key or open port
- name: Deploy via SSM
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_DEFAULT_REGION: eu-west-3
  run: |
    INSTANCE_ID=$(aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=btp-app" \
      --query "Reservations[0].Instances[0].InstanceId" \
      --output text)

    COMMAND_ID=$(aws ssm send-command \
      --instance-ids $INSTANCE_ID \
      --document-name "AWS-RunShellScript" \
      --parameters 'commands=[
        "docker pull miksiei2024/btp_app_prod:latest",
        "cd /home/ubuntu && docker compose up -d --no-deps --force-recreate btp_app_prod"
      ]' \
      --query "Command.CommandId" \
      --output text)

    # Wait for completion
    aws ssm wait command-executed \
      --command-id $COMMAND_ID \
      --instance-id $INSTANCE_ID

    # Show result
    aws ssm get-command-invocation \
      --command-id $COMMAND_ID \
      --instance-id $INSTANCE_ID \
      --query "StandardOutputContent"
```

### Update scripts to use SSM

Once SSM is set up, update `SSH_OPTS` in all your scripts :

```bash
# Before — direct SSH
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -p 2222"

# After — SSH tunneled through SSM
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=btp-app" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no \
  -o ProxyCommand='aws ssm start-session --target $INSTANCE_ID \
  --document-name AWS-StartSSHSession --parameters portNumber=22'"
```

And you can then **completely remove** the SSH ingress rule from your Security Group in `main.tf`.

---

## 5 — check_security.sh

### What it does

A script to run from your local machine that connects to EC2 via SSH and checks the status of every security layer in one shot — UFW, SSH config, Fail2ban, open ports, SSL expiry, disk usage and Docker containers.

```bash
./check_security.sh
```

### The script

```bash
#!/bin/bash

AWS_USER="ubuntu"
AWS_HOST=$(terraform -chdir=./aws/terraform output -raw elastic_ip)
SSH_KEY="~/.ssh/btp_app_key"
SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -p 2222"

echo "=========================================="
echo "🔍 SECURITY CHECK — $AWS_HOST"
echo "=========================================="

ssh $SSH_OPTS $AWS_USER@$AWS_HOST << 'EOF'

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔥 UFW — Firewall status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo ufw status verbose

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔑 SSH — Config"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    grep -E "^PasswordAuthentication|^PermitRootLogin|^Port" /etc/ssh/sshd_config

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🛡️  Fail2ban — Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo fail2ban-client status

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚫 Fail2ban — Banned IPs"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo fail2ban-client banned

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌐 Open ports"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo ss -tlnp | grep LISTEN

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔐 SSL — Certificate expiry"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo openssl x509 -enddate -noout \
      -in /home/ubuntu/certbot/conf/live/btp.iamcristinadev.xyz/fullchain.pem

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💾 Disk usage"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    df -h /

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🐳 Docker — Container status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cd /home/ubuntu && docker compose ps

EOF

echo ""
echo "=========================================="
echo "✅ Security check complete"
echo "=========================================="
```

---

## 6 — UptimeRobot

### What is it ?

UptimeRobot is a **free external monitoring service** that checks your site every 5 minutes from multiple locations around the world and sends you an alert (email, Slack, Telegram) if it goes down.

The key word is **external** — it checks from outside your server, so it detects issues that internal monitoring would miss (network down, EC2 stopped, DNS issue, etc.).

```
UptimeRobot servers (worldwide)
    │
    │  GET https://btp.iamcristinadev.xyz every 5 min
    ▼
Your site
    ├── 200 OK → ✅ all good, no alert
    └── timeout / 5xx → ❌ alert sent immediately
```

### Setup (free plan)

1. Go to **[uptimerobot.com](https://uptimerobot.com)** → create a free account
2. Click **Add New Monitor**
3. Fill in :
   ```
   Monitor Type  : HTTPS
   Friendly Name : BTP App
   URL           : https://btp.iamcristinadev.xyz
   Monitoring Interval : Every 5 minutes
   ```
4. Add your email in **Alert Contacts**
5. Click **Create Monitor**

### What the free plan includes

| Feature | Free |
|---|---|
| Monitors | 50 |
| Check interval | 5 minutes |
| Alert channels | Email |
| Status page | ✅ public page |
| Uptime history | 3 months |

### Status page

UptimeRobot generates a **public status page** for free — useful to show clients or recruiters that your site has X% uptime :

```
https://stats.uptimerobot.com/YOUR_ID
```

---

## 7 — S3 backend for Terraform state

### The problem with local state

By default Terraform stores its state in a local `terraform.tfstate` file. This creates two problems :

```
Problem 1 — If you lose the file
─────────────────────────────────
terraform.tfstate deleted or lost
→ Terraform no longer knows what it created on AWS
→ you cannot run terraform destroy
→ you have to manually delete resources from the AWS console

Problem 2 — Team collaboration
────────────────────────────────
Developer A runs terraform apply → tfstate updated locally
Developer B runs terraform apply → works from an old tfstate
→ duplicate resources, conflicts, infrastructure drift
```

### The solution — S3 backend

Store the state file in an S3 bucket so it is shared, versioned and never lost :

```
terraform apply
    │
    │  reads/writes state
    ▼
S3 bucket (terraform-state-btp)
    └── terraform.tfstate  ← shared, versioned, never lost
```

### Setup in Terraform

**1. Create the S3 bucket (once, manually or with Terraform) :**

```hcl
# backend_setup/main.tf — run this once before everything else
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-btp-cristina"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

**2. Configure the backend in your main Terraform config :**

```hcl
# terraform/main.tf
terraform {
  backend "s3" {
    bucket = "terraform-state-btp-cristina"
    key    = "btp-app/terraform.tfstate"
    region = "eu-west-3"
  }
}
```

**3. Migrate existing local state to S3 :**

```bash
cd terraform/
terraform init -migrate-state
# Terraform will ask to copy local state to S3 → answer yes
```

### With DynamoDB for state locking (optional but recommended in team)

In a team, two people could run `terraform apply` at the same time and corrupt the state. DynamoDB prevents this with a lock :

```hcl
# Add DynamoDB table for locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Add lock table to backend config
terraform {
  backend "s3" {
    bucket         = "terraform-state-btp-cristina"
    key            = "btp-app/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state-lock"
  }
}
```

---

## 8 — Pin Docker image versions

### The problem with `latest`

Using `latest` tags means every `docker pull` or `docker compose up` can pull a **different version** without you knowing :

```
Today
docker pull nginx:latest → pulls nginx 1.27.0 → works fine

3 months later
docker pull nginx:latest → pulls nginx 1.27.3 → breaking change → site down
```

You have no control over when updates happen or what they contain.

### The solution — pin to specific versions

```yaml
# docker-compose.prod.yml

# ❌ Before — unpredictable
webserver:
  image: nginx:latest

certbot:
  image: certbot/certbot:latest

# ✅ After — fully controlled
webserver:
  image: nginx/1.29.5

certbot:
  image: certbot/certbot:v5.3.1
```

### How to find the current version

```bash
# Check what version is currently running
docker exec ubuntu-webserver-1 nginx -v
# nginx version: nginx/1.27.0

docker exec ubuntu-certbot-1 certbot --version
# certbot 2.10.0
```

Or check Docker Hub :
- [hub.docker.com/_/nginx/tags](https://hub.docker.com/_/nginx/tags)
- [hub.docker.com/r/certbot/certbot/tags](https://hub.docker.com/r/certbot/certbot/tags)

### How to update safely

When you want to upgrade a version :

```bash
# 1. Update the version in docker-compose.prod.yml
# nginx:1.27.0 → nginx:1.27.3

# 2. Test locally first
docker compose pull
docker compose up -d

# 3. If all good → push and deploy to EC2
```

This way upgrades are **intentional and controlled** — never automatic surprises.

---

*Cristina Ghinda — Full-Stack & DevOps Developer · [iamcristinadev.xyz](https://www.iamcristinadev.xyz)*
