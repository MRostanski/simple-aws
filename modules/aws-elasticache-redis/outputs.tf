output "id" {
  value       = aws_elasticache_replication_group.redis.id
  description = "The ID of the created ElastiCache Redis Cluster"
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "member_clusters" {
  value = aws_elasticache_replication_group.redis.member_clusters
}