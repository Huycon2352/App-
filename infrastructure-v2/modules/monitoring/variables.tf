variable "environment" {
  description = "Environment that owns the monitoring endpoint"
  type        = string
}

variable "remote_write_host" {
  description = "Resolvable host name for the Prometheus remote_write endpoint. Leave empty to use the in-cluster service DNS name."
  type        = string
  default     = ""
}

variable "remote_write_scheme" {
  description = "Protocol used by the Prometheus remote_write endpoint"
  type        = string
  default     = "http"
}

variable "remote_write_port" {
  description = "Port exposed by the Prometheus remote_write endpoint"
  type        = number
  default     = 9090
}

variable "remote_write_path" {
  description = "HTTP path used for Prometheus remote_write"
  type        = string
  default     = "/api/v1/write"
}

variable "remote_write_namespace" {
  description = "Namespace of the Prometheus service"
  type        = string
  default     = "monitoring"
}

variable "remote_write_service_name" {
  description = "Kubernetes service name that exposes Prometheus"
  type        = string
  default     = "kube-prometheus-stack-prometheus"
}
