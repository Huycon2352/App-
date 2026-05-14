aws_region     = "ap-southeast-1"
aws_account_id = "123456789012"  # Replace with your AWS account ID
environment    = "staging"

vpc_cidr            = "10.1.0.0/16"
public_subnet_cidr  = "10.1.1.0/24"
private_subnet_cidr = "10.1.10.0/24"
availability_zone   = "ap-southeast-1a"

kubernetes_version = "1.28"

node_desired_size = 2
node_min_size     = 2
node_max_size     = 4
node_instance_types = ["t3.small"]

deploy_argocd         = true
deploy_alb_controller = true
