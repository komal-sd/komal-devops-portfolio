# -------------------------------------------
# PROJECT
# -------------------------------------------
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# -------------------------------------------
# NETWORKING
# -------------------------------------------
variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# -------------------------------------------
# SECURITY GROUPS
# -------------------------------------------
variable "frontend_security_group_id" {
  description = "ECS frontend security group ID"
  type        = string
}

variable "backend_security_group_id" {
  description = "ECS backend security group ID"
  type        = string
}

# -------------------------------------------
# ALB
# -------------------------------------------
variable "target_group_arn" {
  description = "ALB target group ARN for frontend"
  type        = string
}

# -------------------------------------------
# DATABASE
# -------------------------------------------
variable "db_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# -------------------------------------------
# ECS SERVICES CONFIG
# -------------------------------------------
variable "backend_port" {
  description = "Backend container port"
  type        = number
}

variable "frontend_port" {
  description = "Frontend container port"
  type        = number
}

variable "backend_cpu" {
  description = "Backend CPU units"
  type        = number
}

variable "backend_memory" {
  description = "Backend memory MB"
  type        = number
}

variable "frontend_cpu" {
  description = "Frontend CPU units"
  type        = number
}

variable "frontend_memory" {
  description = "Frontend memory MB"
  type        = number
}

# -------------------------------------------
# IMAGES
# -------------------------------------------
variable "backend_image" {
  description = "Backend Docker image URI"
  type        = string
}

variable "frontend_image" {
  description = "Frontend Docker image URI"
  type        = string
}
variable "ecs_services" {
  description = "Map of ECS services config"
  type = map(object({
    port          = number
    cpu           = number
    memory        = number
    desired_count = number
    security_group = string
  }))
}