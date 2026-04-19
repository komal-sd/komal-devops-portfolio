variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "backend_port" {
  description = "Backend container port"
  type        = number
}

variable "frontend_port" {
  description = "Frontend container port"
  type        = number
}

variable "db_port" {
  description = "Database port"
  type        = number
}