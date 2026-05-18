# ============================================================
# Outputs for Management Environment
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
  description = "First private subnet ID"
  value       = module.vpc.private_subnet_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "route_table_ids" {
  description = "Route table IDs associated with the management VPC"
  value       = module.vpc.route_table_ids
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

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_id}"
}

output "prometheus_remote_write_host" {
  description = "Prometheus host used by remote_write agents"
  value       = module.monitoring.remote_write_host
}

output "prometheus_remote_write_url" {
  description = "Prometheus remote_write URL that dev agents should export"
  value       = module.monitoring.remote_write_url
}

output "prometheus_agent_environment_variables" {
  description = "Environment variables required before rendering the Prometheus agent ConfigMap"
  value       = module.monitoring.agent_environment_variables
}

output "prometheus_agent_environment_file" {
  description = "Shell-compatible export file for Prometheus agent remote_write configuration"
  value       = module.monitoring.agent_environment_file
}

output "dev_management_peering_connection_id" {
  description = "VPC peering connection ID between the dev and management VPCs"
  value       = try(module.dev_management_peering[0].connection_id, null)
}

output "dev_management_peering_status" {
  description = "Status of the dev/management VPC peering connection"
  value       = try(module.dev_management_peering[0].connection_status, null)
}
