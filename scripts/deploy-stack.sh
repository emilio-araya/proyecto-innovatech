#!/bin/bash
# deploy-stack.sh - Desplegar toda la stack en EC2

set -e

DOCKER_USER=${1:-your-docker-user}
IMAGE_TAG=${2:-latest}

echo "=== Desplegando stack en EC2 ==="
echo "Docker User: $DOCKER_USER"
echo "Image Tag: $IMAGE_TAG"

# Crear archivo docker-compose para EC2
cat > docker-compose.prod.yml <<EOF
version: '3.9'

services:
  mysql-db:
    image: mysql:8.0
    container_name: mysql-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: \${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: \${DB_NAME}
      MYSQL_USER: \${DB_USERNAME}
      MYSQL_PASSWORD: \${DB_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - app-network

  backend-despacho:
    image: ${DOCKER_USER}/backend-despacho:${IMAGE_TAG}
    container_name: backend-despacho
    restart: always
    environment:
      DB_ENDPOINT: \${DB_ENDPOINT}
      DB_PORT: \${DB_PORT}
      DB_NAME: \${DB_NAME}
      DB_USERNAME: \${DB_USERNAME}
      DB_PASSWORD: \${DB_PASSWORD}
    ports:
      - "8081:8081"
    networks:
      - app-network
    depends_on:
      - mysql-db

  backend-ventas:
    image: ${DOCKER_USER}/backend-ventas:${IMAGE_TAG}
    container_name: backend-ventas
    restart: always
    environment:
      DB_ENDPOINT: \${DB_ENDPOINT}
      DB_PORT: \${DB_PORT}
      DB_NAME: \${DB_NAME}
      DB_USERNAME: \${DB_USERNAME}
      DB_PASSWORD: \${DB_PASSWORD}
    ports:
      - "8080:8080"
    networks:
      - app-network
    depends_on:
      - mysql-db

  frontend:
    image: ${DOCKER_USER}/frontend-despacho:${IMAGE_TAG}
    container_name: frontend
    restart: always
    ports:
      - "80:80"
    networks:
      - app-network
    depends_on:
      - backend-despacho
      - backend-ventas

volumes:
  mysql-data:

networks:
  app-network:
    driver: bridge
EOF

echo "✓ docker-compose.prod.yml creado"

# Crear red Docker
docker network create app-network || true

# Descargar docker-compose
docker compose version

# Levantar stack
echo "=== Iniciando servicios ==="
docker compose -f docker-compose.prod.yml up -d

echo "✓ Stack desplegado exitosamente"
echo ""
echo "Servicios disponibles:"
echo "  Frontend: http://localhost"
echo "  API Ventas: http://localhost:8080"
echo "  API Despachos: http://localhost:8081"
echo "  MySQL: localhost:3306"
