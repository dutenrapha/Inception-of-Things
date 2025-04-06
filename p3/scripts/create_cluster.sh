#!/bin/bash
set -e

# Create a k3d cluster (you can customize API and load balancer port mappings as needed)
echo "Creating k3d cluster 'ci-cluster'..."
k3d cluster create ci-cluster --api-port 6550 -p "8888:80@loadbalancer"

# Set kubectl context to the new cluster (k3d sets this automatically)
echo "Creating namespaces..."
kubectl create namespace argo-cd
kubectl create namespace dev

echo "Cluster and namespaces created successfully."
