module "ca_role" {
  source         = "./irsa-role"
  oidc_eks_url   = var.oidc_eks_url
  oidc_eks_arn   = var.oidc_eks_arn
  serviceaccount = "cluster-autoscaler"
  cluster_name   = var.cluster_name

  namespace     = var.namespace
  aws_role_name = "ca"

  tags = var.tags
}

module "ca_policy" {
  source    = "./policy"
  role_name = module.ca_role.name
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.on == true ? 1 : 0
  name       = "cluster-autoscaler"
  namespace  = var.namespace
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  atomic     = true
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "awsRegion"
    value = var.cluster_region
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  dynamic "set" {
    for_each = module.ca_policy.service_account_annotations
    content {
      name  = "rbac.serviceAccount.annotations.${replace(set.key, ".", "\\.")}" # https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e
      value = set.value
    }
  }
}
