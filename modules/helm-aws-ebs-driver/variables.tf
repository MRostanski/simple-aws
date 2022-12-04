variable "on" {
  type    = bool
  default = true
}

variable "service_account_annotations" {
  type    = map(any)
  default = {}
}

variable "replica_count" {
  type    = number
  default = 2
}

variable "chart_version" {
  type    = string
  default = "2.6.3"
}

variable "service_account_name" {
  type    = string
  default = "ebs-csi-controller-sa"
}

variable "namespace" {
  type    = string
  default = "kube-system"
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

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}