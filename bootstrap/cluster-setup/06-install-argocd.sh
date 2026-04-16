#!/bin/bash

set -e

NAMESPACE="argocd"

echo "🚀 Installing ArgoCD..."

# Create namespace if not exists
if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
  echo "⚠️ Namespace '$NAMESPACE' already exists. Skipping creation."
else
  kubectl create namespace "$NAMESPACE"
  echo "✅ Namespace '$NAMESPACE' created."
fi

# Install ArgoCD (official manifest)
echo "📦 Applying ArgoCD official manifest..."
kubectl apply --server-side -n "$NAMESPACE" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD server to be ready
echo "⏳ Waiting for ArgoCD server to be ready..."
kubectl rollout status deployment/argocd-server -n "$NAMESPACE" --timeout=180s

# Wait for all pods (extra safety)
echo "⏳ Waiting for all ArgoCD pods..."
kubectl wait --for=condition=Ready pods --all -n "$NAMESPACE" --timeout=180s

# Get initial admin password
echo "🔑 Fetching ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n "$NAMESPACE" get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo ""
echo "🎉 ArgoCD installed successfully!"
echo ""
echo "🌐 Access ArgoCD using port-forward:"
echo "👉 Run this in a separate terminal:"
echo ""
echo "kubectl port-forward svc/argocd-server -n argocd 8081:443"
echo ""
echo "Then open:"
echo "👉 https://localhost:8081"
echo ""
echo "🔐 Login credentials:"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo ""
echo "⚠️ Note: Browser will show TLS warning (self-signed cert)"
