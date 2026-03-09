#!/bin/bash

# Stop the script on any error
set -e

# INSTANCE_IP=$INSTANCE_IP
KEY_NAME="btp_app_key"
KEY_FILE="/home/arcus/.ssh/${KEY_NAME}"

# Run the Ansible playbook to install Docker
echo "Running the Ansible playbook..."

cd ./ansible
ansible-playbook -i inventory.ini ansible_playbook.yml --private-key  $KEY_FILE --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'


# Indicate that the deployment is complete
echo "Deployment completed successfully!"

