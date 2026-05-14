# ============================================================
# ALB Controller: AWS Load Balancer Controller Helm Chart
# ============================================================

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.alb_controller_version

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.alb_controller_role_arn
  }

  # Avoid IP conflicts
  set {
    name  = "enableShield"
    value = false
  }

  set {
    name  = "enableWaf"
    value = false
  }

  set {
    name  = "enableWafv2"
    value = false
  }

  depends_on = [
    var.cluster_id
  ]
}
