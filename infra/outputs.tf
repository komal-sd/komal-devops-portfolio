output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.alb.alb_dns_name
}

output "ecr_backend_url" {
  description = "Backend ECR repository URL"
  value       = module.ecs.ecr_repository_urls["backend"]
}

output "ecr_frontend_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecs.ecr_repository_urls["frontend"]
}