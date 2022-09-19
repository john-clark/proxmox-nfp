#!/bin/bash
if [ "${container}" = "lxc" ]; then
  apt update && apt upgrade -y
  apt-get install ca-certificates curl gnupg lsb-release -y
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
  systemctl start docker; systemctl enable docker
  docker --version
else
  echo Do not run this on the proxmox server
fi
