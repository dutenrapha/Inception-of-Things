#!/bin/bash
set -e

echo "Deploying Argo CD into the 'argo-cd' namespace..."
kubectl apply -n argo-cd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for the Argo CD server to be ready..."
kubectl rollout status deployment/argocd-server -n argo-cd

echo "Argo CD deployed successfully."
