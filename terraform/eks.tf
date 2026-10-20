# Configuración del clúster EKS

# Extrae el OIDC Provider
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# OIDC Provider
resource "aws_iam_openid_connect_provider" "main" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = {
    Name = "${var.cluster_name}-oidc-provider"
  }
}

# Clúster EKS
resource "aws_eks_cluster" "main" {
  name            = var.cluster_name
  version         = var.kubernetes_version
  role_arn        = aws_iam_role.cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids              = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.cluster_encryption
  ]
}

# Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.private[*].id

  scaling_config {
    min_size       = var.node_group_min_size
    max_size       = var.node_group_max_size
    desired_size   = var.node_group_desired_size
  }

  instance_types = [var.node_instance_type]

  disk_size = 50

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_registry
  ]

  # Evita reemplazar el node group cuando cambia el desired_size
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Outputs del clúster
output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "Nombre del clúster EKS"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
  description = "Endpoint del clúster EKS"
}

output "cluster_security_group_id" {
  value       = aws_security_group.cluster.id
  description = "ID del security group del clúster"
}

output "node_group_id" {
  value       = aws_eks_node_group.main.id
  description = "ID del node group"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.main.arn
  description = "ARN del OIDC Provider"
}
