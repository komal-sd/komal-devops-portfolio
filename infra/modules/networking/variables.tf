variable "vpc_name" {
  description = "Name of the VPC"
  type = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}
variable "availability_zones" {
  description = "List of availability_zones"
  type = list(string)
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}
variable "enable_nat_gateway" {
  description = "Whether to create NAT gateway"
  type = bool
  default = false
}
variable "single_nat_gateway" {
  description = "Use single NAT gateway for all AZs"
  type = bool
  default = true
}
variable "environment" {
  description = "Environment name e.g dev, prod"
  type        = string
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}
variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}