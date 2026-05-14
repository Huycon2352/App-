variable "argocd_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.46.0"
}

variable "argocd_domain" {
  description = "ArgoCD domain name"
  type        = string
  default     = "argocd.example.com"
}
