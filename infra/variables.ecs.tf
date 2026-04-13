variable "backend_port" {
  description = "Backend container port"
  type = number
}
variable "frontend_port" {
  description = "Frontend container port"
  type = number
}
 variable "backend_cpu" {
  description = "Backend task CPU units"
  type        = number
}

variable "backend_memory" {
  description = "Backend task memory in MB"
  type        = number
}

variable "frontend_cpu" {
  description = "Frontend task CPU units"
  type        = number
}

variable "frontend_memory" {
  description = "Frontend task memory in MB"
  type        = number
}