resource "helm_release" "metrics_server" {
  count      = var.on == true ? 1 : 0
  name       = "metrics-server"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  atomic     = true
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "replicas"
    value = var.replica_count
  }

  set {
    name  = "hostNetwork"
    value = var.hostNetwork
  }
}
