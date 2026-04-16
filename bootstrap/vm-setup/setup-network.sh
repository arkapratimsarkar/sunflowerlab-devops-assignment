#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting VM network setup..."

# Copy netplan config
echo "📁 Applying Netplan configuration..."
sudo cp "$SCRIPT_DIR/01-netcfg.yaml" /etc/netplan/01-netcfg.yaml
sudo chmod 600 /etc/netplan/01-netcfg.yaml

# Disable cloud-init network override
echo "🚫 Disabling cloud-init network configuration..."
sudo cp "$SCRIPT_DIR/99-disable-network-config.cfg" /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# Apply netplan
echo "🔄 Applying Netplan..."
sudo netplan apply

echo ""
echo "✅ Network configuration applied successfully!"
echo ""
echo "⚠️ It is recommended to reboot the VM to ensure persistence."
echo "👉 Run: sudo reboot"
