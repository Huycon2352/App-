# ============================================================
# PROD Environment: Main Terraform Configuration
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

module "security_groups" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
}

module "iam" {
  source = "../../modules/iam"

  environment    = var.environment
  aws_account_id = var.aws_account_id
}

module "eks" {
  source = "../../modules/eks"

  environment               = var.environment
  cluster_role_arn          = module.iam.eks_cluster_role_arn
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = module.vpc.private_subnet_ids
  cluster_security_group_id = module.security_groups.eks_cluster_security_group_id
}

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
