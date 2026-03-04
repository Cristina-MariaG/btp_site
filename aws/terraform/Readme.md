# Configure tes credentials AWS
## AWS Configuration

Before running Terraform, you need to configure your AWS credentials locally.

### 1. Install AWS CLI

If you don't have the AWS CLI installed, follow the official instructions:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

### 2. Create an IAM User
Never use your root AWS account for Terraform or any day-to-day tasks. The root user has unrestricted access to everything in your AWS account — billing, account deletion, all resources — with no way to limit its permissions through IAM policies. If root credentials are leaked or compromised, the consequences are critical and irreversible.

Instead, create a dedicated IAM user with only the permissions needed:

1. Go to **AWS Console** → **IAM** → **Users** → **Create user**
2. Give it a name (e.g. `terraform-user`)
3. Attach the **AdministratorAccess** policy (or a more restrictive one if you know exactly what resources Terraform will manage)
4. Go to the user → **Security credentials** → **Create access key** → select **CLI**
5. Save the **Access Key ID** and **Secret Access Key** immediately — the secret key will not be shown again

### 3. Configure AWS CLI
```bash
aws configure
```
```
AWS Access Key ID:     → paste your Access Key ID
AWS Secret Access Key: → paste your Secret Access Key
Default region name:   → eu-west-3
Default output format: → json
```

### 4. Verify your configuration
```bash
aws sts get-caller-identity
```

If you see your `Account ID` and `UserID` returned, your credentials are correctly configured and you can proceed with `terraform init`.r coté securité c est mieux que de les ceer a partir de root.

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