# ============================================================
# DEV Environment: Terraform Variables
# ============================================================

aws_region  = "ap-southeast-1"
environment = "dev"
vpc_cidr    = "10.0.0.0/16"

# Multi-AZ configuration
availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

aws_account_id       = "248195880649"
kubernetes_version   = "1.28"

# Node Group
node_desired_size   = 2
node_min_size       = 2
node_max_size       = 3
node_instance_types = ["t3.medium"]
