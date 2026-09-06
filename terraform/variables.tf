# Definición de variables para el clúster EKS

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
  default     = "innovatech-eks-cluster"
}

variable "environment" {
  description = "Ambiente del proyecto"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_group_min_size" {
  description = "Número mínimo de nodos"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Número máximo de nodos"
  type        = number
  default     = 4
}

variable "node_group_desired_size" {
  description = "Número deseado de nodos"
  type        = number
  default     = 3
}

variable "node_instance_type" {
  description = "Tipo de instancia EC2 para los nodos"
  type        = string
  default     = "t3.medium"
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes"
  type        = string
  default     = "1.28"
}

variable "enable_cluster_autoscaler" {
  description = "Habilitar Cluster Autoscaler"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Habilitar Metrics Server para HPA"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Project     = "Innovatech"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
