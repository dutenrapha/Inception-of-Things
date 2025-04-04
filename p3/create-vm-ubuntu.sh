#!/bin/bash

VM_NAME="iot-k3d-vm"
ISO_NAME="ubuntu-22.04.4-live-server-amd64.iso"

ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"

VM_DISK="${VM_NAME}.vdi"
RAM_MB=2048
CPUS=2
DISK_SIZE_MB=20000


ISO_PATH="$(pwd)/$ISO_NAME"


if [ ! -f "$ISO_PATH" ]; then
  echo "⬇️  Baixando a ISO do Ubuntu Server..."
  curl -o "$ISO_PATH" "$ISO_URL"
else
  echo "✅ ISO já existe: $ISO_PATH"
fi


echo "🔍 Verificando o formato do arquivo ISO..."
ISO_TYPE=$(file "$ISO_PATH")
if [[ "$ISO_TYPE" != *"ISO 9660 CD-ROM filesystem data"* ]]; then
  echo "❌ ERRO: Formato de arquivo ISO inválido!"
  echo "Esperado ISO 9660, obtido: $ISO_TYPE"
  echo "👉 Por favor, baixe novamente a ISO de: $ISO_URL"
  exit 1
else
  echo "✅ Formato ISO é válido."
fi


echo "🖥️  Criando VM '$VM_NAME' no VirtualBox..."
VBoxManage createvm --name "$VM_NAME" --ostype Ubuntu_64 --register


VBoxManage modifyvm "$VM_NAME" \
  --memory $RAM_MB \
  --cpus $CPUS \
  --nic1 nat \
  --audio none \
  --boot1 dvd


VBoxManage createmedium disk --filename "$VM_DISK" --size $DISK_SIZE_MB


VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DISK"


VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"


echo "✅ VM '$VM_NAME' criada com sucesso!"
echo "💡 Abra o VirtualBox e inicie a VM para instalar o Ubuntu manualmente."
