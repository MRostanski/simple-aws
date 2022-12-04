# https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.9.0/docs/example-iam-policy.json

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ebs_controller_service_policy" {
  #checkov:skip=CKV_AWS_111: Needed
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
    ]

    resources = [
      "*"
    ]

    effect = "Allow"
  }
  statement {
    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
    effect = "Allow"
  }
  statement {
    actions = [
      "ec2:DeleteTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values = [
        "true",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values = [
        "*",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values = [
        "owned",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values = [
        "true",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values = [
        "*",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
      values = [
        "owned",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values = [
        "*",
      ]
    }
    effect = "Allow"
  }

  statement {
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values = [
        "true",
      ]
    }
    effect = "Allow"
  }

}

resource "aws_iam_policy" "ebs_controller" {
  description = "EKS Cluster EBS CSI Controller Policy"
  name        = "${var.role_name}-policy"
  policy      = data.aws_iam_policy_document.ebs_controller_service_policy.json
}

resource "aws_iam_role_policy_attachment" "ebs_controller_service_role_policy" {
  role       = var.role_name # module.oidc_role["ebs-controller"].name
  policy_arn = aws_iam_policy.ebs_controller.arn
}

output "service_account_annotations" {
  value = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.role_name}"
  }
}
