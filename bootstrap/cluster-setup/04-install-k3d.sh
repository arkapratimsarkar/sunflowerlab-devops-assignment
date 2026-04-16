#!/bin/bash

set -e

echo "🚀 Installing k3d..."

# Download and install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Verify
echo "🔍 Verifying k3d..."
k3d version

echo "✅ k3d installed successfully!"
