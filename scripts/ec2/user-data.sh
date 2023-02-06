#!/bin/bash

## SYSTEM DEPENDENCIES
apt update -y
apt install -y \
    ubuntu-desktop \
    xrdp \
    xfce4 \
    xfce4-session \
    docker.io \
    docker-compose
apt-get update -y
apt-get install -y \
    apt-transport-https
    ca-certificates \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    jq
    gnupg \
    lsb-release

## REPOSITORY INSTALLATIONS
### DOCKER 
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |\
    tee /etc/apt/sources.list.d/docker.list > /dev/null

### TERRAFORM
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |\
    tee /etc/apt/sources.list.d/hashicorp.list


apt-get update -y
apt-get install -y \
    terraform \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

## SOURCE INSTALLATIONS
### AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

### xRDP CONFIGURATION
# open RDP port
ufw allow 3389/tcp
# set default GUI
echo xfce4-session >~/.xsession
sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh
service xrdp restart

### ECR LOGIN
aws ecr get-login-password \
    --region $AWS_DEFAULT_REGION |\
    docker login \
        --username AWS \
        --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com