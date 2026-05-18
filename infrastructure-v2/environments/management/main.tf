# ============================================================
# MANAGEMENT Environment: Main Terraform Configuration
# ============================================================

data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = var.dev_state_key
    region = var.terraform_state_region
  }
}

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

module "monitoring" {
  source = "../../modules/monitoring"

  environment               = var.environment
  remote_write_host         = var.prometheus_remote_write_host
  remote_write_scheme       = var.prometheus_remote_write_scheme
  remote_write_port         = var.prometheus_remote_write_port
  remote_write_path         = var.prometheus_remote_write_path
  remote_write_namespace    = var.monitoring_namespace
  remote_write_service_name = var.prometheus_service_name
}

module "dev_management_peering" {
  count  = var.enable_dev_management_peering ? 1 : 0
  source = "../../modules/vpc-peering"

  name                    = "dev-management-peering"
  requester_vpc_id        = data.terraform_remote_state.dev.outputs.vpc_id
  requester_vpc_cidr      = data.terraform_remote_state.dev.outputs.vpc_cidr
  requester_route_table_ids = data.terraform_remote_state.dev.outputs.route_table_ids
  accepter_vpc_id         = module.vpc.vpc_id
  accepter_vpc_cidr       = module.vpc.vpc_cidr
  accepter_route_table_ids = module.vpc.route_table_ids
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "dev-management-peering"
  }
}
