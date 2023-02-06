#!/bin/bash

## SYSTEM DEPENDENCIES
# apt update -y
# apt install -y \
#     docker.io \
#     docker-compose

## REPOSITORY INSTALLATIONS
### DOCKER 
echo "Manually adding Docker apt repository..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |\
    tee /etc/apt/sources.list.d/docker.list > /dev/null

### TERRAFORM
echo "Manually adding Terraform apt repository..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |\
    tee /etc/apt/sources.list.d/hashicorp.list


echo "Updating apt-get repositories..."
apt-get update -y

echo "Installing apt-get dependencies..."
apt-get install -y \
    terraform \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

## SOURCE INSTALLATIONS
### AWS CLI
echo "Manually installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

### ECR LOGIN
echo "Logging into AWS ECR..."
aws ecr get-login-password \
    --region $AWS_DEFAULT_REGION |\
    docker login \
        --username AWS \
        --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com