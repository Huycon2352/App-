# ============================================================
# IAM Module: Roles cho EKS + Node Groups
# ============================================================

# ============================================================
# EKS Cluster Role
# ============================================================
resource "aws_iam_role" "eks_cluster_role" {
  name_prefix = "${var.environment}-eks-cluster-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.environment}-eks-cluster-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Attach required policies to EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# ============================================================
# EKS Node Group Role
# ============================================================
resource "aws_iam_role" "eks_node_role" {
  name_prefix = "${var.environment}-eks-node-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.environment}-eks-node-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Attach required policies to node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ============================================================
# IAM Role for ALB Controller (IRSA)
# ============================================================
resource "aws_iam_role" "alb_controller_role" {
  name_prefix = "${var.environment}-alb-controller-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${replace(var.oidc_provider_arn, "/^.*provider\\//", "")}"
      }
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_arn, "/^.*provider\\//", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${replace(var.oidc_provider_arn, "/^.*provider\\//", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = {
    Name        = "${var.environment}-alb-controller-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ALB Controller policy
resource "aws_iam_policy" "alb_controller_policy" {
  name_prefix = "${var.environment}-alb-controller-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elbv2:CreateLoadBalancer",
          "elbv2:CreateTargetGroup",
          "elbv2:CreateListener",
          "elbv2:DeleteListener",
          "elbv2:DescribeListeners",
          "elbv2:DescribeLoadBalancers",
          "elbv2:DescribeTargetGroups",
          "elbv2:ModifyListener",
          "elbv2:ModifyLoadBalancerAttributes",
          "elbv2:ModifyTargetGroup",
          "elbv2:ModifyTargetGroupAttributes",
          "elbv2:DeleteLoadBalancer",
          "elbv2:DeleteTargetGroup",
          "elbv2:DescribeLoadBalancerAttributes",
          "elbv2:DescribeTargetGroupAttributes"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeNetworkInterfaces"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
