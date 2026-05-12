resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd
  ]

  timeout         = 1200
  wait            = true
  force_update    = true
  recreate_pods   = true
  cleanup_on_fail = true
}

# Wait ArgoCD server ready
resource "time_sleep" "wait_argocd" {
  depends_on = [
    helm_release.argocd
  ]

  create_duration = "180s"
}

# Bootstrap App Of Apps
resource "null_resource" "root_app" {
  depends_on = [
    time_sleep.wait_argocd
  ]

  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig \
  --name management-cluster \
  --region ap-southeast-1

kubectl apply -f ${path.module}/app-of-apps.yaml
EOT
  }
}