data "aws_availability_zones" "current" {}

resource "aws_elasticache_parameter_group" "redis" {
  name   = local.param_group
  family = "redis${var.engine_family}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_elasticache_subnet_group" "sg" {
  name       = local.subnet_group
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled = true
  # multi_az_enabled = true
  engine                        = "redis"
  engine_version                = var.engine_version
  availability_zones            = slice(data.aws_availability_zones.current.names, 0, var.nodes_num)
  replication_group_id          = local.cluster_id
  replication_group_description = "Redis cluster"
  node_type                     = var.node_type
  number_cache_clusters         = var.nodes_num
  parameter_group_name          = aws_elasticache_parameter_group.redis.name
  port                          = var.port
  subnet_group_name             = aws_elasticache_subnet_group.sg.name
  security_group_ids            = var.security_group_ids
  maintenance_window            = var.maintenance_window

  tags = var.tags

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}