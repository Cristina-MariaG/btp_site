#!/bin/bash

# Stop the script on any error
set -e

# INSTANCE_IP=$INSTANCE_IP
KEY_NAME="btp_app_key"
KEY_FILE="/home/arcus/.ssh/${KEY_NAME}"
PUBLIC_KEY_FILE="${KEY_FILE}.pub"


# # Create a dynamic Ansible inventory file
# echo "Creating the Ansible inventory..."
# cat > inventory.ini <<EOF
# [awsservers]
# $INSTANCE_IP ansible_user=ubuntu
# EOF

# Wait for the instance to be ready
# sleep 60 # Wait :for 60 seconds to ensure the instance is ready

# Run the Ansible playbook to install Docker
echo "Running the Ansible playbook..."

ansible-playbook -i inventory.ini ansible_playbook.yml --private-key  /home/arcus/.ssh/btp_app_key --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'


# Indicate that the deployment is complete
echo "Deployment completed successfully!"

