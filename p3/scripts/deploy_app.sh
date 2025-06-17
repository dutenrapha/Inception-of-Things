#!/bin/bash
set -e

echo "Deploying the Argo CD Application for the playground app..."
kubectl apply -f ../conf/argocd.yaml -n argo-cd

echo "Application deployed. Argo CD will now monitor the GitHub repository for changes."
