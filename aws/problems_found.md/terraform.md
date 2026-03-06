# 🔧 Troubleshooting — Connexion SSH sur EC2 avec Terraform

## 📋 Contexte

Mise en place d'une infrastructure AWS via Terraform pour déployer une instance EC2.
L'objectif était de se connecter en SSH à l'instance après le provisionnement.

---

## ❌ Problème rencontré

```
ubuntu@13.39.189.39: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

Impossible de se connecter en SSH à l'instance EC2 malgré plusieurs tentatives et modifications du code Terraform.

---

## 🔍 Cause racine

**L'AMI ID utilisé ne correspondait pas à une image Ubuntu.**

L'AMI ID initial (`ami-08461dc8cd9e834e0`) ne correspondait pas à une AMI Ubuntu officielle dans la région `eu-west-3` (Paris).
Le user par défaut pour se connecter en SSH dépend du système d'exploitation de l'AMI :

| AMI / OS        | User SSH par défaut |
|-----------------|---------------------|
| Ubuntu          | `ubuntu`            |
| Amazon Linux    | `ec2-user`          |
| Debian          | `admin`             |
| CentOS          | `centos`            |

En utilisant une AMI non-Ubuntu avec le user `ubuntu`, la connexion SSH était systématiquement rejetée.

✅ **Solution** : Récupérer le bon AMI ID directement depuis la console AWS :
```
EC2 → Launch Instance → Ubuntu → copier l'AMI ID officiel pour eu-west-3
```

---

## 🔄 Tentatives effectuées avant de trouver la cause

### 1. Script shell initial — génération manuelle des clés SSH

Au départ, un script shell était utilisé pour générer les clés SSH manuellement avant de lancer Terraform :

```bash
#!/bin/bash
KEY_NAME="btp_app_key"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/$KEY_NAME" -N ""

echo "Clés générées :"
ls -la "$HOME/.ssh/$KEY_NAME"*
```

### 2. Modification de main.tf — génération des clés via Terraform

Le script externe a été abandonné au profit d'une gestion complète des clés dans Terraform :

```hcl
# Génération de la clé
resource "tls_private_key" "btp_app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload de la clé publique sur AWS
resource "aws_key_pair" "btp_app_key" {
  key_name   = "btp-app-key"
  public_key = tls_private_key.btp_app_key.public_key_openssh
}

# Sauvegarde de la clé privée en local
resource "local_file" "private_key" {
  content         = tls_private_key.btp_app_key.private_key_pem
  filename        = "/home/arcus/.ssh/btp_app_key.pem"
  file_permission = "0600"
}

# Sauvegarde de la clé publique en local
resource "local_file" "public_key" {
  content         = tls_private_key.btp_app_key.public_key_openssh
  filename        = "/home/arcus/.ssh/btp_app_key.pub"
  file_permission = "0644"
}
```

### 3. Multiples cycles terraform destroy / apply

Chaque modification du `main.tf` nécessitait de recréer l'instance depuis zéro :

```bash
terraform destroy -auto-approve
terraform apply -auto-approve
```

> ⚠️ Un simple `terraform apply` ne recrée pas l'instance si elle existe déjà.
> La clé SSH est injectée **une seule fois au premier démarrage** de l'instance.
> Changer la key pair dans la console AWS après coup n'a aucun effet sur `authorized_keys`.

### 4. Vérifications effectuées côté Ubuntu

```bash
# Vérifier les permissions de la clé privée
ls -la /home/arcus/.ssh/
chmod 400 /home/arcus/.ssh/btp_app_key.pem

# Vérifier l'empreinte de la clé locale
ssh-keygen -l -f /home/arcus/.ssh/btp_app_key.pem

# Tentative de connexion standard
ssh -i /home/arcus/.ssh/btp_app_key.pem ubuntu@<elastic_ip>

# Tentative de connexion en mode verbose pour diagnostic
ssh -vvv -i /home/arcus/.ssh/btp_app_key.pem ubuntu@<elastic_ip>
```

### 5. Vérifications effectuées côté Terraform / AWS

```bash
# Initialiser les providers
terraform init

# Vérifier le plan avant d'appliquer
terraform plan

# Appliquer l'infrastructure
terraform apply

# Voir les outputs (IP, etc.)
terraform output

# Détruire toute l'infrastructure
terraform destroy
```

---

## ✅ Solution finale

1. Aller dans la console AWS → **EC2 → Launch Instance**
2. Sélectionner **Ubuntu 22.04 LTS**
3. Copier l'AMI ID affiché pour la région `eu-west-3` (Paris)
4. Mettre à jour `variables.tf` ou `main.tf` avec le bon AMI ID
5. Relancer un cycle complet :

```bash
terraform destroy -auto-approve
terraform apply -auto-approve
```

6. Se connecter en SSH :

```bash
ssh -i /home/arcus/.ssh/btp_app_key ubuntu@<elastic_ip>
```

---

## 📝 Leçons apprises

- **Toujours vérifier l'AMI ID** directement depuis la console AWS pour la bonne région — les AMI IDs sont spécifiques à chaque région.
- **La clé SSH est injectée une seule fois** au premier démarrage de l'instance. Changer la key pair après ne sert à rien sans recréer l'instance.
- **`terraform destroy` + `terraform apply`** est obligatoire pour recréer une instance avec une nouvelle clé.
- **Générer les clés dans Terraform** (via `tls_private_key`) est plus propre qu'un script externe, mais la clé privée est stockée dans le state — à sécuriser.
- Le **mode verbose SSH** (`-vvv`) est indispensable pour diagnostiquer les problèmes de connexion.