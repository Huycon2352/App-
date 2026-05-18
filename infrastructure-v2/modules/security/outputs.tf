output "eks_cluster_security_group_id" {
  description = "EKS cluster control plane security group ID"
  value       = module.security_group.eks_cluster_security_group_id
}

output "eks_nodes_security_group_id" {
  description = "EKS nodes security group ID"
  value       = module.security_group.eks_nodes_security_group_id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = module.security_group.alb_security_group_id
}
