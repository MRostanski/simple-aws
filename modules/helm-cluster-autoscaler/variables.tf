variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_region" {
  type        = string
  description = "EKS cluster region"
}

variable "on" {
  type    = bool
  default = true
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "chart_version" {
  default = "9.13.1"
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "oidc_eks_url" {
  type = string
}

variable "oidc_eks_arn" {
  type = string
}