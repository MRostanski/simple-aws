variable "on" {
  type    = bool
  default = true
}

variable "chart_version" {
  type    = string
  default = "6.0.3"
}

variable "replica_count" {
  type        = number
  description = "Replicas for metrics-server"
  default     = 2
}

variable "hostNetwork" {
  type    = bool
  default = false
}

variable "namespace" {
  type    = string
  default = "kube-system"
}