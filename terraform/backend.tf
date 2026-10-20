# Backend remoto para estado de Terraform
# NOTA: Cambiar esto según tu configuración

terraform {
  # Descomenta y configura si quieres usar S3 remoto
  # backend "s3" {
  #   bucket         = "tu-bucket-terraform"
  #   key            = "innovatech-eks/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock"
  # }
}
