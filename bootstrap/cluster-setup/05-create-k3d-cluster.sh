#!/bin/bash

set -e

CLUSTER_NAME="dev-cluster"
CONTROL_PLANE_NODE="k3d-${CLUSTER_NAME}-server-0"

echo "🚀 Creating k3d cluster: $CLUSTER_NAME"

# Check if cluster already exists
if k3d cluster list | grep -q "$CLUSTER_NAME"; then
  echo "⚠️ Cluster '$CLUSTER_NAME' already exists. Skipping creation."
  exit 0
fi

# Create cluster
k3d cluster create "$CLUSTER_NAME" \
  --servers 1 \
  --agents 2 \
  -p "8080:80@loadbalancer" \
  -p "8443:443@loadbalancer" \
  --wait \
  --k3s-arg "--disable=traefik@server:0"

echo "✅ Cluster created successfully!"

# Verify nodes
echo "🔍 Verifying nodes..."
kubectl get nodes

# Wait for control plane node to be ready (extra safety)
echo "⏳ Waiting for control plane node to be ready..."
kubectl wait --for=condition=Ready node/$CONTROL_PLANE_NODE --timeout=120s

# Apply taint
echo "🚧 Applying taint to control plane node..."

if kubectl describe node "$CONTROL_PLANE_NODE" | grep -q "NoSchedule"; then
  echo "⚠️ Node already tainted. Skipping..."
else
  kubectl taint nodes "$CONTROL_PLANE_NODE" node-role.kubernetes.io/control-plane=true:NoSchedule
  echo "✅ Taint applied successfully!"
fi

# Verify taint
echo "🔍 Verifying taint..."
kubectl describe node "$CONTROL_PLANE_NODE" | grep Taint || echo "⚠️ No taint found"

echo "🎉 k3d cluster is fully ready (with control-plane isolation)!"
