module "ebs_role" {
  source         = "./irsa-role"
  oidc_eks_url   = var.oidc_eks_url
  oidc_eks_arn   = var.oidc_eks_arn
  serviceaccount = var.service_account_name
  cluster_name   = var.cluster_name

  namespace     = var.namespace
  aws_role_name = "ebs-driver"

  tags = var.tags
}

module "ebs_policy" {
  source    = "./policy"
  role_name = module.ebs_role.name
}

resource "helm_release" "ebs_csi_driver" {
  count      = var.on == true ? 1 : 0
  name       = "aws-ebs-csi-driver"
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  atomic     = true
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.replicaCount"
    value = var.replica_count
  }
  set {
    name  = "controller.serviceAccount.create"
    value = true
  }
  set {
    name  = "controller.serviceAccount.name"
    value = var.service_account_name
  }

  dynamic "set" {
    for_each = module.ebs_policy.service_account_annotations
    content {
      name  = "controller.serviceAccount.annotations.${replace(set.key, ".", "\\.")}" # https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e
      value = set.value
    }
  }
}
