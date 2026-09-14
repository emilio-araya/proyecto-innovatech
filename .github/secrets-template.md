# GitHub Actions secrets
# Configurar en: Settings > Secrets and variables > Actions

# AWS / EKS
AWS_ACCESS_KEY_ID=tu_access_key
AWS_SECRET_ACCESS_KEY=tu_secret_key
AWS_SESSION_TOKEN=tu_session_token_si_corresponde
EKS_CLUSTER_NAME=nombre-del-cluster

# El workflow actual usa ECR y EKS.
# No se requieren credenciales Docker Hub ni claves SSH/EC2 para el pipeline.
