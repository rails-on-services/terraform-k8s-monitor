variable "namespace" {
  type = string
  default = "monitor"
  description = "Namespace to deploy monitoring stack"
}

variable "grafana_user" {
  type        = string
  default     = "admin"
  description = "Grafana admin username"
}

variable "grafana_password" {
  type        = string
  description = "Grafana password"
}

variable "grafana_host" {
  type        = string
  description = "Internal Grafana host"
}

variable "grafana_endpoint" {
  type        = string
  description = "External Grafana DNS hostname"
}

variable "helm_configuration_overrides" {
  description = "JSON string of Helm configurationOverrides key: values"
}

variable "monitor_depends_on" {
  type        = any
  default     = null
  description = "Variable to pass dependancy on module" # https://discuss.hashicorp.com/t/tips-howto-implement-module-depends-on-emulation/2305/2
}

variable "vm_version" {
  type = string
  default = "1.30.0"
  description = "Victoria Metrics version to deploy"
}

variable "loki_version" {
  type        = string
  default     = "1.2.0"
  description = "Loki version to deploy"
}

variable "prometheus_version" {
  type        = string
  default     = "2.14.0"
  description = "Prometheus version to deploy"
}

variable "grafana_version" {
  type        = string
  default     = "6.5.0"
  description = "Grafana version to deploy"
}




