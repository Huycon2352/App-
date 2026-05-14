output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "EKS node role ARN"
  value       = aws_iam_role.eks_node_role.arn
}

output "alb_controller_role_arn" {
  description = "ALB controller role ARN"
  value       = aws_iam_role.alb_controller_role.arn
}
