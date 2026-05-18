variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "environment" {
  description = "Environment name for the management stack"
  type        = string
  default     = "management"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.3.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.3.1.0/24", "10.3.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.3.10.0/24", "10.3.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "deploy_argocd" {
  description = "Deploy ArgoCD"
  type        = bool
  default     = true
}

variable "deploy_alb_controller" {
  description = "Deploy ALB controller"
  type        = bool
  default     = true
}

variable "enable_dev_management_peering" {
  description = "Create VPC peering routes between the dev and management VPCs"
  type        = bool
  default     = true
}

variable "terraform_state_bucket" {
  description = "S3 bucket that stores Terraform remote state for environment stacks"
  type        = string
  default     = "voting-app-terraform-state-248195880649"
}

variable "terraform_state_region" {
  description = "Region of the Terraform remote-state bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "dev_state_key" {
  description = "S3 object key for the dev environment Terraform state"
  type        = string
  default     = "environments/dev/terraform.tfstate"
}

variable "monitoring_namespace" {
  description = "Namespace that exposes the Prometheus service"
  type        = string
  default     = "monitoring"
}

variable "prometheus_service_name" {
  description = "Service name used by the Prometheus stack"
  type        = string
  default     = "kube-prometheus-stack-prometheus"
}

variable "prometheus_remote_write_host" {
  description = "Optional override for the Prometheus remote_write host (for example an internal NLB DNS name)."
  type        = string
  default     = ""
}

variable "prometheus_remote_write_scheme" {
  description = "Protocol used for Prometheus remote_write"
  type        = string
  default     = "http"
}

variable "prometheus_remote_write_port" {
  description = "Port used for Prometheus remote_write"
  type        = number
  default     = 9090
}

variable "prometheus_remote_write_path" {
  description = "HTTP path used for Prometheus remote_write"
  type        = string
  default     = "/api/v1/write"
}
