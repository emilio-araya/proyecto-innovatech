#!/bin/bash
# setup-ec2.sh - Script de configuración inicial para EC2

set -e

echo "=== Actualizando sistema ==="
sudo yum update -y
sudo yum install -y docker git curl

echo "=== Iniciando Docker ==="
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "=== Instalando Docker Compose ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Creando red Docker ==="
docker network create app-network || true

echo "=== Configuración completada ==="
echo "Reinicia la sesión SSH para que los cambios de grupo Docker se apliquen"
docker --version
docker-compose --version
