variable "name" {
  type    = string
  default = "EKS"
}

variable "deletion_days" {
  type        = number
  default     = 7
  description = "KMS deletion window in days"
}

variable "cluster_role_arn" {
  type        = string
  default     = null
  description = "Cluster Role ARN, necessary for EBS policy"
}

variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_kms_key" "eks" {
  description             = "${var.name} cluster Secret Encryption Key"
  deletion_window_in_days = var.deletion_days
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_key" "ebs" {
  description             = "Customer managed key to encrypt ${var.name} cluster managed node group volumes"
  deletion_window_in_days = var.deletion_days
  policy                  = data.aws_iam_policy_document.ebs.json
}

output "eks_arn" {
  value = aws_kms_key.eks.arn
}

output "ebs_arn" {
  value = aws_kms_key.ebs.arn
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ebs" {
  # Copy of default KMS policy that lets you manage it
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  # Required for EKS
  statement {
    sid = "Allow service-linked role use of the CMK"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", # required for the ASG to manage encrypted volumes for nodes
        var.cluster_role_arn,                                                                                                                       # required for the cluster / persistentvolume-controller to create encrypted PVCs
      ]
    }
  }

  statement {
    sid       = "Allow attachment of persistent resources"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", # required for the ASG to manage encrypted volumes for nodes
        var.cluster_role_arn,                                                                                                                       # required for the cluster / persistentvolume-controller to create encrypted PVCs
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}