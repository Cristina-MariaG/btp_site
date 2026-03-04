# Configure tes credentials AWS
aws configure

# Initialise Terraform (télécharge le provider AWS)
terraform init

# Vérifie ce qui va être créé
terraform plan

# Crée l'infrastructure
terraform apply

# Pour tout supprimer
terraform destroy

Variables
This Terraform configuration is split into two files to keep the code clean and secure.
variables.tf declares all variables — their name, type, and default value. Think of it as the contract: it tells Terraform which variables exist and what kind of value they expect. This file is always committed to Git.
terraform.tfvars assigns the actual values to those variables. This is where you put environment-specific configuration without touching the core infrastructure code. This file should never be committed to Git if it contains sensitive values such as API keys or passwords — it is listed in .gitignore for this reason.

Overriding variables
You can override any variable in three ways:
bash# 1. In terraform.tfvars (recommended)
instance_name = "my-server"

# 2. Via command line
terraform apply -var="instance_name=my-server"

# 3. Via environment variable
export TF_VAR_instance_name="my-server"

Using multiple environments
Since values are decoupled from declarations, you can maintain separate .tfvars files per environment and switch between them easily:
bash# Deploy to dev
terraform apply -var-file="terraform.dev.tfvars"

# Deploy to production
terraform apply -var-file="terraform.prod.tfvars"
This keeps the same main.tf and variables.tf across all environments — only the values change.