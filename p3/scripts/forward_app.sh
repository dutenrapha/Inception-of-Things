#!/bin/bash
set -e

echo "Deploying the Argo CD Application for the playground app..."
kubectl rollout status deployment.apps/playground-deployment -n dev

kubectl port-forward svc/playground-service 8888:8888 -n dev &

echo "Application is accessible at: http://localhost:8888"
