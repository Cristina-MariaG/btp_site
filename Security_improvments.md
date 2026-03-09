# 🔒 Security Improvements

---

## Table of contents

- [Roadmap](#roadmap)
- [UFW — Firewall setup](#ufw--firewall-setup)
- [AWS SSM — Passwordless connection](#aws-ssm--passwordless-connection)

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
| 8 | Pin Docker image versions (nginx:1.27 instead of latest) | ⏳ To do |

---

## UFW — Firewall setup

### What is UFW ?

UFW (Uncomplicated Firewall) is a firewall that runs at the **OS level** on the Ubuntu instance. It filters traffic that reaches the instance itself, on top of the AWS Security Group which filters traffic before it even reaches EC2.

```
Internet → AWS Security Group → EC2 → UFW → App
```

Having both layers is called **defense in depth** — if one layer is misconfigured, the other still protects.

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

## AWS SSM — Passwordless connection

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
```

This lets you use `scp`, VSCode Remote SSH, etc. — all tunneled through SSM with no open port.

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

SSH_OPTS="-i $SSH_KEY -o StrictHostKeyChecking=no -o ProxyCommand='aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartSSHSession --parameters portNumber=22'"
```

And you can then **completely remove** the SSH ingress rule from your Security Group in `main.tf`.

---

*Cristina Ghinda — Full-Stack & DevOps Developer · [iamcristinadev.xyz](https://www.iamcristinadev.xyz)*