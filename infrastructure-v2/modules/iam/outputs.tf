output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "EKS node role ARN"
  value       = aws_iam_role.eks_node_role.arn
}

######################## addd-newwwwwwwwwwwww
output "eks_node_role_name" {
  value       = aws_iam_role.node.name # Thay "node" bằng tên resource aws_iam_role tạo node group role của bạn
  description = "Tên của IAM Role dành cho Node Group"
}
########################


# output "alb_controller_role_arn" {
#   description = "ALB controller role ARN"
#   value       = aws_iam_role.alb_controller_role.arn
# }
