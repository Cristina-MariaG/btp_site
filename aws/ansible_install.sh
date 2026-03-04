#!/bin/bash

# Stop the script on any error
set -e

INSTANCE_IP=$INSTANCE_IP

# Create a dynamic Ansible inventory file
echo "Creating the Ansible inventory..."
cat > inventory.ini <<EOF
[awsservers]
$INSTANCE_IP ansible_user=ubuntu
EOF

# Wait for the instance to be ready
# sleep 60 # Wait :for 60 seconds to ensure the instance is ready

# Run the Ansible playbook to install Docker
echo "Running the Ansible playbook..."
ansible-playbook -i inventory.ini ansible_playbook.yml --private-key ~/.ssh/my-portfolio.pem --ssh-extra-args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Indicate that the deployment is complete
echo "Deployment completed successfully!"

