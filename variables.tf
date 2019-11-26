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
