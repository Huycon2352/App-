# ============================================================
# DEV Environment: Main Terraform Configuration
# ============================================================

# ============================================================
# VPC Module
# ============================================================
module "vpc" {
  source = "../../modules/vpc"

  aws_region           = var.aws_region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ============================================================
# Security Groups Module
# ============================================================
module "security_groups" {
  source = "../../modules/security-group"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
}

# ============================================================
# IAM Module
# ============================================================
module "iam" {
  source = "../../modules/iam"

  environment    = var.environment
  aws_account_id = var.aws_account_id
}

# ============================================================
# EKS Cluster Module
# ============================================================
module "eks" {
  source = "../../modules/eks"

  environment               = var.environment
  cluster_role_arn          = module.iam.eks_cluster_role_arn
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = module.vpc.private_subnet_ids
  cluster_security_group_id = module.security_groups.eks_cluster_security_group_id
}

# ============================================================
# Node Group Module
# ============================================================
module "node_group" {
  source = "../../modules/node-group"

  environment        = var.environment
  cluster_name       = module.eks.cluster_id
  node_role_arn      = module.iam.eks_node_role_arn
  subnet_ids         = module.vpc.private_subnet_ids
  kubernetes_version = var.kubernetes_version
  desired_size       = var.node_desired_size
  min_size           = var.node_min_size
  max_size           = var.node_max_size
  instance_types     = var.node_instance_types
  capacity_type      = "ON_DEMAND"
  disk_size          = 30
  ec2_ssh_key        = null
}

/*
# ============================================================
# ECR Module
# ============================================================
module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
}


# ============================================================
# ALB Controller (optional)
# ============================================================
module "alb_controller" {
  count = var.deploy_alb_controller ? 1 : 0
  source = "../../modules/alb-controller"

  cluster_name              = module.eks.cluster_id
  cluster_id                = module.eks.cluster_id
  alb_controller_role_arn   = module.iam.alb_controller_role_arn
  alb_controller_version    = "2.6.2"

  depends_on = [
    module.node_group
  ]
}

# ============================================================
# ArgoCD (optional)
# ============================================================
module "argocd" {
  count = var.deploy_argocd ? 1 : 0
  source = "../../modules/argocd"

  argocd_version = "5.46.0"
  argocd_domain  = "argocd.${var.environment}.example.com"

  depends_on = [
    module.alb_controller
  ]
}
*/
