#!/bin/bash
set -e

echo "Creating k3d cluster 'ci-cluster'..."
k3d cluster create ci-cluster --api-port 6550

echo "Creating namespaces..."
kubectl create namespace argo-cd || true
kubectl create namespace dev || true

echo "Applying ClusterRoleBinding for Argo CD controller..."
kubectl apply -f ../conf/cluster-role-binding.yaml

echo "Deploying Argo CD..."
kubectl apply -n argo-cd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD server to be ready..."
kubectl rollout status deployment/argocd-server -n argo-cd --timeout=180s

echo "Forwarding Argo CD server to localhost:8080..."
kubectl port-forward svc/argocd-server -n argo-cd 8080:443 > /dev/null 2>&1 &
echo $! > /tmp/argocd_port_forward.pid

PASSWORD=$(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "Argo CD is running at: http://localhost:8080"
echo "Initial admin password: $PASSWORD"
echo "To stop port-forward: kill $(cat /tmp/argocd_port_forward.pid)"

echo "Applying Argo CD Application for playground..."
kubectl apply -f ../conf/argocd.yaml -n argo-cd

echo "Waiting for playground deployment to be created by Argo CD..."
# Aguarda o objeto ser criado
until kubectl get deployment playground-deployment -n dev &> /dev/null; do
  echo "Waiting for playground-deployment resource..."
  sleep 5
done

echo "Waiting for playground-deployment rollout..."
kubectl rollout status deployment playground-deployment -n dev --timeout=180s

echo "Forwarding playground-service to localhost:8888..."
kubectl port-forward svc/playground-service 8888:8888 -n dev > /dev/null 2>&1 &

echo "Playground app is accessible at: http://localhost:8888"
