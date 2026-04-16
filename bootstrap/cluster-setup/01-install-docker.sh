#!/bin/bash

set -e

echo "🚀 Starting Docker installation..."

# Update system
echo "📦 Updating package index..."
sudo apt update

# Install prerequisites
echo "🔧 Installing required packages..."
sudo apt install -y ca-certificates curl

# Create keyrings directory
echo "🔑 Setting up Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker GPG key (only if not exists)
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
fi

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "📁 Adding Docker repository..."
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update again after adding repo
echo "🔄 Updating package index (Docker repo)..."
sudo apt update

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
echo "⚙️ Enabling Docker service..."
sudo systemctl enable docker --now

# Add docker group if not exists
if ! getent group docker > /dev/null; then
  echo "👥 Creating docker group..."
  sudo groupadd docker
fi

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installation completed!"
echo ""
echo "⚠️ IMPORTANT: Please reboot your system to apply group changes."
echo "👉 Run: sudo reboot"
