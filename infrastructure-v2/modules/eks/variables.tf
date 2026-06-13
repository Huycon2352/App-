variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group ID for EKS cluster"
  type        = string
}

###################addd -on newwwwwwwwwwwww

variable "ebs_csi_addon_version" {
  type        = string
  default     = "v1.51.0-eksbuild.1"
  description = "Phiên bản EBS CSI Driver"
}

variable "node_role_name" {
  type        = string
  description = "Tên (Name) của IAM Role đang dùng cho Node Group"
}
