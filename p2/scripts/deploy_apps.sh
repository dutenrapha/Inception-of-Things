#!/bin/bash

echo "[+] Installing K3s Server on rdutenkeS..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --tls-san 192.168.56.110" sh -

echo "[+] Exporting kubeconfig for vagrant user..."
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc
chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

echo "[+] Waiting for K3s to be ready..."
until kubectl get nodes >/dev/null 2>&1; do
  echo "K3s is not available yet. Waiting 5 seconds..."
  sleep 5
done

echo "[+] K3s is ready. Applying the cluster configuration..."
kubectl apply -f /conf/apps.yaml
kubectl apply -f /conf/ingress.yaml

if [ $? -eq 0 ]; then
  echo "[+] Manifests applied successfully!"
else
  echo "[-] There was a problem applying the manifests."
fi

