# -------------------------------------------
# ECS SERVICES MAP
# -------------------------------------------
locals {
  ecs_services = {
    frontend = {
      port           = var.frontend_port
      cpu            = var.frontend_cpu
      memory         = var.frontend_memory
      desired_count  = 1
      security_group = module.security_groups.ecs_frontend_security_group_id
    }
    backend = {
      port           = var.backend_port
      cpu            = var.backend_cpu
      memory         = var.backend_memory
      desired_count  = 1
      security_group = module.security_groups.ecs_backend_security_group_id
    }
  }
}