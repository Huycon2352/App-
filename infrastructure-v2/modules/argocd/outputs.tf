output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_status" {
  description = "ArgoCD deployment status"
  value       = helm_release.argocd.status
}
