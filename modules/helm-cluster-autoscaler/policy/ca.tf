# https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "autoscaler_service_policy" {
  #checkov:skip=CKV_AWS_107: Needed
  #checkov:skip=CKV_AWS_111: Needed
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "sts:AssumeRoleWithWebIdentity",
      "eks:DescribeNodegroup",
    ]

    resources = [
      "*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "autoscaler" {
  description = "EKS Cluster Autoscaler Policy"
  name        = "${var.role_name}-policy"
  policy      = data.aws_iam_policy_document.autoscaler_service_policy.json
}

resource "aws_iam_role_policy_attachment" "autoscaler_service_role_policy" {
  role       = var.role_name # module.oidc_role["cluster-autoscaler"].name
  policy_arn = aws_iam_policy.autoscaler.arn
}

output "service_account_annotations" {
  value = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_name}"
  }
}

output "deployment_annotations" {
  value = {
    "cluster-autoscaler.kubernetes.io/safe-to-evict" = "false"
  }
}
