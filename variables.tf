variable "name" {
  type = string
  description = "Project name"
}

variable "region" {
  type = string
  description = "AWS region"
}

variable "vpc_flowlogs" {
  type        = bool
  description = "Set to true to keep VPC flowlogs"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "vpc_public_subnet_cidrs_list" {
  type        = list(any)
  description = "The list of three CIDRs"
}

variable "vpc_private_subnet_cidrs_list" {
  type        = list(any)
  description = "The list of three CIDRs"
}

variable "vpc_enable_nat" {
  type        = bool
  description = "Set to true to use NAT"
}

variable "vpc_single_nat" {
  type        = bool
  description = "Set to true to configure single NAT for all AZs"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes version"
}

variable "eks_public_access" {
  type        = bool
  description = "Set to true to open EKS control plane"
}

variable "eks_ami_type" {
  type        = string
  description = "AMI type, e.g AL2_x86_64"
}

variable "eks_instance_types_list" {
  type        = list(any)
  description = "List of instance types for managed node group"
}

variable "eks_ebs_type" {
  type        = string
  description = "EKS EBS type (e.g. gp2 or gp3)"
}

variable "eks_ebs_size" {
  type        = number
  description = "EKS EBS Disk size"
}

variable "eks_ebs_iops" {
  type        = number
  description = "EKS EBS IOPS"
}

variable "eks_ebs_throughput" {
  type        = number
  description = "EKS IOPS throughput"
}

variable "eks_primary_group_min" {
  type        = number
  description = "Minimum instances number"
}

variable "eks_primary_group_max" {
  type        = number
  description = "Maximum instances number"
}

variable "eks_primary_group_desired" {
  type        = number
  description = "Desired instances number"
}

variable "redis_node_type" {
  type        = string
  description = "Redis instances type"
}

variable "redis_nodes_num" {
  type        = number
  description = "Redis instances number"
}

variable "helm_aws_alb_version" {
  type        = string
  description = "Chart version for aws-load-balancer-controller"
}

variable "helm_aws_alb_namespace" {
  type        = string
  description = "Namespace for aws-load-balancer-controller"
}

variable "helm_aws_alb_replicas" {
  type        = number
  description = "Replicas of aws-load-balancer-controller"
}

variable "helm_metrics_server_version" {
  type        = string
  description = "Chart version for metrics-server"
}

variable "helm_metrics_server_replicas" {
  type        = number
  description = "Replicas of metrics-server"
}
