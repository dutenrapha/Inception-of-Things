#!/bin/bash

echo "[+] Installing K3s Server on rdutenkeS..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --tls-san 192.168.56.110" sh -

echo "[+] Exporting kubeconfig for vagrant user..."
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc
chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

echo "[+] Saving K3s token to shared folder..."
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant_shared/node-token
