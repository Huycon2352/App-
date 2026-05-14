variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable "alb_controller_role_arn" {
  description = "IAM role ARN for ALB controller"
  type        = string
}

variable "alb_controller_version" {
  description = "ALB controller Helm chart version"
  type        = string
  default     = "2.6.2"
}
