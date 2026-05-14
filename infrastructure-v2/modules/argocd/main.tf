# ============================================================
# ArgoCD: GitOps Continuous Deployment
# ============================================================

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  version          = var.argocd_version
  create_namespace = false

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }
      server = {
        service = {
          type = "LoadBalancer"
        }
        insecure = true
      }
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}
