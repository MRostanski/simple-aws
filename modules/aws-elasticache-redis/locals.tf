locals {
  cluster_id   = "${var.name}-redis"
  param_group  = "${var.name}-redis-pg"
  subnet_group = "${var.name}-redis-sg"
}