output "alb_controller_status" {
  description = "ALB controller deployment status"
  value       = helm_release.aws_load_balancer_controller.status
}
