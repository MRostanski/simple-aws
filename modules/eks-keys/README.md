<!-- BEGIN_TF_DOCS -->



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | Cluster Role ARN, necessary for EBS policy | `string` | `null` | no |
| <a name="input_deletion_days"></a> [deletion\_days](#input\_deletion\_days) | KMS deletion window in days | `number` | `7` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"EKS"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_arn"></a> [ebs\_arn](#output\_ebs\_arn) | n/a |
| <a name="output_eks_arn"></a> [eks\_arn](#output\_eks\_arn) | n/a |

Disclaimer: this code is auto-generated by [tf-docs](https://terraform-docs.io)

[Return](../README.md)
<!-- END_TF_DOCS -->