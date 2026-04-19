# ═══════════════════════════════════════════
# NETWORKING
# ═══════════════════════════════════════════
module "networking" {
  source = "./modules/networking"

  vpc_name              = var.project_name
  vpc_cidr              = var.vpc_cidr
  environment           = var.environment
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true
  enable_dns_support    = true
}
# ═══════════════════════════════════════════
# Database
# ═══════════════════════════════════════════
module "datbase" {
  source = "./modules/database"

  vpc_id = module.networking.vpc_id
  database_subnet_ids = module.networking.database_subnet_ids
  rds_security_group_id = module.security_groups.rds_security_group_id
  
  project_name = var.project_name
  environment = var.environment
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  instance_class = "db.t3.micro"
  allocated_storage = 20
}
# ═══════════════════════════════════════════
# Security Groups
# ═══════════════════════════════════════════
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id       = module.networking.vpc_id
  project_name = var.project_name
  environment  = var.environment
  backend_port = var.backend_port
  frontend_port = var.frontend_port
  db_port      = var.db_port
}