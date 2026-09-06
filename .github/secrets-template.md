# .github/secrets-template.md
# Plantilla de Secrets para GitHub Actions
# Copia estos valores en GitHub: Settings > Secrets and variables > Actions

DOCKER_USERNAME=tu_usuario_dockerhub
DOCKER_PASSWORD=tu_token_dockerhub

# EC2 Credentials
EC2_PRIVATE_KEY=tu_private_key_ssh
EC2_FRONTEND_HOST=ip-frontend.compute.amazonaws.com
EC2_BACKENDS_HOST=ip-backends.compute.amazonaws.com

# Database Credentials
DB_ENDPOINT=mysql-db-rds.amazonaws.com
DB_PORT=3306
DB_NAME=despacho_db
DB_USERNAME=despacho_user
DB_PASSWORD=tu_password_segura.
