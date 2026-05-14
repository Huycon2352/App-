# ============================================================
# Outputs for Dev Environment
# ============================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.vpc.private_subnet_id
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster version"
  value       = module.eks.cluster_version
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = module.node_group.node_group_id
}

output "node_group_status" {
  description = "EKS node group status"
  value       = module.node_group.node_group_status
}

output "ecr_vote_repository_url" {
  description = "ECR vote app repository URL"
  value       = module.ecr.vote_repository_url
}

output "ecr_result_repository_url" {
  description = "ECR result app repository URL"
  value       = module.ecr.result_repository_url
}

output "ecr_worker_repository_url" {
  description = "ECR worker app repository URL"
  value       = module.ecr.worker_repository_url
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_id}"
}
