output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecr_repository_urls" {
  description = "ECR repository URLs for frontend and backend"
  value       = { for k, v in aws_ecr_repository.app : k => v.repository_url }
}

output "backend_security_group_id" {
  description = "ECS backend security group ID"
  value       = var.backend_security_group_id
}