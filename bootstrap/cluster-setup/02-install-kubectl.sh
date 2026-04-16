#!/bin/bash

set -e

echo "🚀 Starting kubectl installation..."

# Update system
echo "📦 Updating package index..."
sudo apt-get update

# Install prerequisites
echo "🔧 Installing required packages..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Create keyrings directory if not exists
echo "🔑 Setting up Kubernetes GPG key..."
sudo mkdir -p -m 755 /etc/apt/keyrings

# Add GPG key (only if not exists)
if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi

sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo "📁 Adding Kubernetes repository..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Update package index again
echo "🔄 Updating package index (Kubernetes repo)..."
sudo apt-get update

# Install kubectl
echo "⚙️ Installing kubectl..."
sudo apt-get install -y kubectl

echo "✅ kubectl installation completed!"

# Verify
echo "🔍 Verifying installation..."
kubectl version --client

echo "🎉 kubectl is ready to use!"
