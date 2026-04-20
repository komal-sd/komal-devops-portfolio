output "secret_arn" {
  description = "ARN of the database secret"
  value       = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  description = "Name of the database secret"
  value       = aws_secretsmanager_secret.db.name
}