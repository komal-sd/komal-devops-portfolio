# ═══════════════════════════════════════════
# DATABASE
# ═══════════════════════════════════════════
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_port" {
  description = "Database port number"
  type        = number
}