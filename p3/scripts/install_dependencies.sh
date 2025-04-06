#!/bin/bash
set -e

# Install k3d if not installed
if ! command -v k3d &> /dev/null; then
  echo "k3d not found; installing..."
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
  echo "k3d is already installed."
fi

# Install kubectl if not installed
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found; installing..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
else
  echo "kubectl is already installed."
fi

# Install Argo CD CLI if not installed
if ! command -v argocd &> /dev/null; then
  echo "Argo CD CLI not found; installing..."
  VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
  chmod +x argocd
  sudo mv argocd /usr/local/bin/
else
  echo "Argo CD CLI is already installed."
fi

echo "All dependencies are installed."
