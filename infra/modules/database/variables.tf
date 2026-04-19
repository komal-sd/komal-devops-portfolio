variable "vpc_id" {
  description = "VPC ID"
  type = string
}
variable "database_subnet_ids" {
  description = "Database subnet Ids"
  type = list(string)
}
variable "rds_security_group_id" {
  description = "RDS security group ID from security_groups module"
  type        = string
}
variable "db_name" {
  description = "Database name"
  type = string
}
variable "db_username" {
  description = "Database master username"
  type = string
}
variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}
variable "db_port" {
  description = "Database port"
  type = number
  default = 5432
}
variable "instance_class" {
  description = "RDS instance class"
  type = string
  default = "db.t3.micro"
}
variable "allocated_storage" {
  description = "Storage in GB"
  type = number
  default = 20
}
variable "environment" {
  description = "Environment name"
  type = string
}
variable "project_name" {
  description = "Project name"
  type = string
}

