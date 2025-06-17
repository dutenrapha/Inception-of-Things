#!/bin/bash
set -e

echo "Deploying Argo CD into the 'argo-cd' namespace..."
kubectl apply -n argo-cd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for the Argo CD server to be ready..."
kubectl rollout status deployment/argocd-server -n argo-cd

echo "Argo CD deployed successfully."

kubectl port-forward svc/argocd-server -n argo-cd 8080:443 > /dev/null 2>&1 &
PORT_FORWARD_PID=$!

# Save the PID to a file for later use
echo $PORT_FORWARD_PID > /tmp/argocd_port_forward.pid

# Retrieve the Argo CD initial admin password
PASSWORD=$(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Print a user-friendly message
echo "Argo CD server is now accessible at http://localhost:8080"
echo "Your initial admin password is: $PASSWORD"
echo "To stop the port-forwarding, use: kill $(cat /tmp/argocd_port_forward.pid)"
