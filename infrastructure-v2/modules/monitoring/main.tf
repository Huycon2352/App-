locals {
  resolved_remote_write_host = trimspace(var.remote_write_host) != "" ? var.remote_write_host : format(
    "%s.%s.svc.cluster.local",
    var.remote_write_service_name,
    var.remote_write_namespace,
  )

  remote_write_url = format(
    "%s://%s:%d%s",
    var.remote_write_scheme,
    local.resolved_remote_write_host,
    var.remote_write_port,
    var.remote_write_path,
  )

  agent_environment = {
    PROMETHEUS_REMOTE_WRITE_URL       = local.remote_write_url
    PROMETHEUS_REMOTE_WRITE_HOST      = local.resolved_remote_write_host
    PROMETHEUS_REMOTE_WRITE_PORT      = tostring(var.remote_write_port)
    PROMETHEUS_REMOTE_WRITE_PATH      = var.remote_write_path
    PROMETHEUS_REMOTE_WRITE_SCHEME    = var.remote_write_scheme
    PROMETHEUS_REMOTE_WRITE_NAMESPACE = var.remote_write_namespace
    PROMETHEUS_REMOTE_WRITE_SERVICE   = var.remote_write_service_name
    PROMETHEUS_REMOTE_WRITE_STACK     = var.environment
  }
}
