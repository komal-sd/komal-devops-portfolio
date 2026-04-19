# ---------------------------------------
# ALB Security Group
# ---------------------------------------
resource "aws_security_group" "alb" {
  name = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Applicaion Load Balancer"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from Internet"
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from Internet"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# -------------------------------------------
# ECS Frontend Security Group
# -------------------------------------------
resource "aws_security_group" "ecs_frontend" {
  name = "${var.project_name}-${var.environment}-ecs-frontend-sg"
  description = "Security group for ECS fronent tasks"
  vpc_id = var.vpc_id

 ingress {
    from_port = var.frontend_port
    to_port   = var.frontend_port
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "Allow trafic from ALB only"
 }

 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "${var.project_name}-${var.environment}-ecs-frontend-sg"
   Environment = var.environment
 }

}

# -----------------------------------------------------
# ECS Backend Security Group
# -----------------------------------------------------
resource "aws_security_group" "ecs_backend" {
  name = "${var.project_name}-${var.environment}-ecs-backend-sg"
  description = "Security group for ECS backend tasks"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.backend_port
    to_port = var.backend_port
    protocol = "tcp"
    security_groups = [aws_security_group.ecs_frontend.id]
    description = "Allow traffic from ECS frontend only"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-backend-sg"
    Environment = var.environment
  }
}

# -------------------------------------------
# RDS SECURITY GROUP
# -------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_backend.id]
    description     = "Allow ECS backend to connect to RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}