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


########################### Add on - newwwwwwwwwwwwwww

# ============================================================
# BỔ SUNG: IRSA & EBS CSI Add-on cho K8s 1.34
# ============================================================

# 1. Định nghĩa Trust Policy cho EBS CSI dựa trên OIDC ngay trong module
data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

# 2. Tạo IAM Role cho EBS CSI Driver
resource "aws_iam_role" "ebs_csi" {
  name               = "${var.environment}-eks-ebs-csi-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy.json

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 3. Gắn AWS Managed Policy cho Role
resource "aws_iam_role_policy_attachment" "ebs_csi" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi.name
}

# 4. Kích hoạt EKS Add-on AWS EBS CSI Driver
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_addon_version
  service_account_role_arn = aws_iam_role.ebs_csi.arn

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi
  ]
}

# ============================================================
# BỔ SUNG: Các Policy sửa lỗi Node Group bị giới hạn quyền
# ============================================================
resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = var.node_role_name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = var.node_role_name
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = var.node_role_name
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = var.node_role_name
}
