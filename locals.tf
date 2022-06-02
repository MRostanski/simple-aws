locals {
  name            = var.name
  region          = var.region
  cluster_version = var.eks_cluster_version
  azs             = data.aws_availability_zones.available.names

  tags = {
    Example    = local.name
  }

  security_groups = [
    "eks-additional",
    "remote-access",
    "db",
    "cache",
  ]
}