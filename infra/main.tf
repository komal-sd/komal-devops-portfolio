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