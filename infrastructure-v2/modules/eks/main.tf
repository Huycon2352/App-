# ============================================================
# EKS Cluster Module
# ============================================================

resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-cluster"
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # Enable logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [
    var.cluster_role_arn
  ]

  tags = {
    Name        = "${var.environment}-cluster"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# OIDC Provider (để IRSA - IAM Roles for Service Accounts)
# ============================================================
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = {
    Name        = "${var.environment}-cluster-oidc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
