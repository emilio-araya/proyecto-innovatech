# Outputs principales del clúster EKS

output "eks_cluster_name" {
  description = "Nombre del clúster EKS"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del clúster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_version" {
  description = "Versión de Kubernetes"
  value       = aws_eks_cluster.main.version
}

output "eks_cluster_ca" {
  description = "Certificado de autoridad del clúster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "node_group_id" {
  description = "ID del node group"
  value       = aws_eks_node_group.main.id
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de subredes públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs de subredes privadas"
  value       = aws_subnet.private[*].id
}

output "cluster_security_group" {
  description = "Security group del clúster"
  value       = aws_security_group.cluster.id
}

output "node_security_group" {
  description = "Security group de los nodos"
  value       = aws_security_group.node.id
}

output "oidc_provider_arn" {
  description = "ARN del OIDC Provider (para IRSA)"
  value       = aws_iam_openid_connect_provider.main.arn
}

output "configure_kubectl" {
  description = "Comando para configurar kubectl"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}"
}
