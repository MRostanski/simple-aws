# AWS-load-balancer controller

Uses Helm provider and EKS repository for helm chart.

## WARNING

If updating, install the TargetGroupBinding CRDs if upgrading the chart via `helm upgrade`.

```bash
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller
```

The `helm install` command automatically applies the CRDs, but `helm upgrade` doesn't.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | EKS cluster name | `string` | n/a | yes |

## Outputs

No output.

<!-- BEGIN_TF_DOCS -->



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | n/a | `string` | `"1.4.2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_createIngressClassResource"></a> [createIngressClassResource](#input\_createIngressClassResource) | Choose to create IngressClass resource | `string` | `false` | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | n/a | `map(any)` | `{}` | no |
| <a name="input_ingress_class"></a> [ingress\_class](#input\_ingress\_class) | Ingress class name for the controller | `string` | `"alb"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"kube-system"` | no |
| <a name="input_oidc_eks_arn"></a> [oidc\_eks\_arn](#input\_oidc\_eks\_arn) | n/a | `string` | n/a | yes |
| <a name="input_oidc_eks_url"></a> [oidc\_eks\_url](#input\_oidc\_eks\_url) | n/a | `string` | n/a | yes |
| <a name="input_on"></a> [on](#input\_on) | n/a | `bool` | `true` | no |
| <a name="input_priority_class"></a> [priority\_class](#input\_priority\_class) | ALB Priority Class | `string` | `"system-cluster-critical"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | n/a | `number` | `2` | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | n/a | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.

Disclaimer: this code is auto-generated by [tf-docs](https://terraform-docs.io)

[Return](../README.md)
<!-- END_TF_DOCS -->