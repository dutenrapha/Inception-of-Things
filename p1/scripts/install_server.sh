#!/bin/bash

echo "[+] Installing K3s Server on rdutenkeS..."
curl -sfL https://get.k3s.io | sh -

echo "[+] Exporting kubeconfig for vagrant user..."
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc
chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

echo "[+] Saving K3s token to shared folder..."
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant_shared/node-token
