#!/bin/bash
# deploy-database.sh - Desplegar MySQL en EC2 de base de datos

set -e

DB_NAME=${DB_NAME:-despacho_db}
DB_USERNAME=${DB_USERNAME:-despacho_user}
DB_PASSWORD=${DB_PASSWORD:-despacho_pass}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-root123}

echo "=== Desplegando MySQL ==="
docker run -d \
  --name mysql-db \
  --network app-network \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USERNAME \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0

echo "=== Esperando que MySQL esté listo ==="
sleep 15

echo "✓ MySQL desplegado exitosamente"
docker ps | grep mysql-db
