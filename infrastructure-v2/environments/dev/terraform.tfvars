# ============================================================
# DEV Environment: Terraform Variables
# ============================================================

aws_region     = "ap-southeast-1"
aws_account_id = "123456789012"  # Replace with your AWS account ID
environment    = "dev"

# VPC Configuration
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.10.0/24"
availability_zone   = "ap-southeast-1a"

# Kubernetes Configuration
kubernetes_version = "1.28"

# Node Group Configuration (Minimal for Dev)
node_desired_size = 1
node_min_size     = 1
node_max_size     = 3
node_instance_types = ["t3.small"]  # Cheap instance type for dev

# Features
deploy_argocd          = true
deploy_alb_controller  = true
