#!/bin/bash

K3S_URL="https://192.168.56.110:6443"
TOKEN_FILE="/vagrant_shared/node-token"

echo "[+] Waiting for token to be available..."

while [ ! -f "$TOKEN_FILE" ]; do
  echo "[-] Token not found. Retrying in 5 seconds..."
  sleep 5
done

K3S_TOKEN=$(cat $TOKEN_FILE)

echo "[+] Installing K3s Agent on rdutenkeSW..."
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -

echo "[+] K3s Agent installed and connected to the server!"
