#!/bin/bash

set -e

echo "🚀 Starting Helm 3 installation..."

# Download Helm install script (only if not exists)
if [ ! -f get_helm.sh ]; then
  echo "📥 Downloading Helm install script..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
fi

# Make it executable
echo "🔧 Setting execute permission..."
chmod 700 get_helm.sh

# Run installer
echo "⚙️ Installing Helm..."
./get_helm.sh

# Cleanup
echo "🧹 Cleaning up..."
rm -f get_helm.sh

# Verify installation
echo "🔍 Verifying Helm installation..."
helm version

echo "🎉 Helm installation completed!"
