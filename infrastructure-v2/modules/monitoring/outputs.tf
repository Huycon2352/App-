output "remote_write_host" {
  description = "Host used by Prometheus agents for remote_write"
  value       = local.resolved_remote_write_host
}

output "remote_write_url" {
  description = "Prometheus remote_write URL for agents"
  value       = local.remote_write_url
}

output "agent_environment_variables" {
  description = "Environment variables required to inject the remote_write endpoint into the Prometheus agent ConfigMap"
  value       = local.agent_environment
}

output "agent_environment_file" {
  description = "Shell-compatible environment file that can be sourced before applying the Prometheus agent ConfigMap"
  value       = join("\n", [for key, value in local.agent_environment : "${key}=${value}"])
}
