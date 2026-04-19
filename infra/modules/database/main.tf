#subnet group
resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

#RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"
  engine = "postgres"
  engine_version = "15.4"
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage

  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  port = var.db_port

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
  }

}