# -------------------------------------------
# ECR REPOSITORIES
# -------------------------------------------
resource "aws_ecr_repository" "app" {
  for_each = var.ecs_services

  name         = "${var.project_name}-${var.environment}-${each.key}"
  force_delete = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
  }
}
# -------------------------------------------
# CLOUDWATCH LOG GROUPS
# -------------------------------------------
resource "aws_cloudwatch_log_group" "app" {
  for_each = var.ecs_services

  name              = "/ecs/${var.project_name}-${var.environment}-${each.key}"
  retention_in_days = 7

  tags = {
    Name        = "/ecs/${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
  }
}
# -------------------------------------------
# IAM EXECUTION ROLE
# -------------------------------------------
resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-execution-role"
    Environment = var.environment
  }
}

# -------------------------------------------
# IAM POLICY
# -------------------------------------------
resource "aws_iam_role_policy" "ecs_execution" {
  name = "${var.project_name}-${var.environment}-ecs-execution-policy"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}
# -------------------------------------------
# ECS CLUSTER
# -------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Environment = var.environment
  }
}

# -------------------------------------------
# SERVICE CONNECT NAMESPACE
# -------------------------------------------
resource "aws_service_discovery_http_namespace" "main" {
  name        = "${var.project_name}-${var.environment}"
  description = "Service Connect namespace for ECS services"

  tags = {
    Name        = "${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}
# -------------------------------------------
# TASK DEFINITIONS
# -------------------------------------------
resource "aws_ecs_task_definition" "app" {
  for_each = var.ecs_services

  family                   = "${var.project_name}-${var.environment}-${each.key}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.key == "frontend" ? var.frontend_image : var.backend_image
      essential = true

      portMappings = [
        {
          containerPort = each.value.port
          hostPort      = each.value.port
          protocol      = "tcp"
          name          = each.key
        }
      ]

      environment = each.key == "backend" ? [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "FLASK_ENV"
          value = var.environment
        }
      ] : [
        {
          name  = "REACT_APP_API_URL"
          value = "http://backend:${var.backend_port}"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-${var.environment}-${each.key}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
  }
}
# -------------------------------------------
# ECS SERVICES
# -------------------------------------------
resource "aws_ecs_service" "app" {
  for_each = var.ecs_services

  name = "${var.project_name}-${var.environment}-${each.key}"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app[each.key].arn
  desired_count = each.value.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [each.value.security_group]
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = each.key == "frontend" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name = each.key
      container_port = each.value.port
    }
  }
 
 service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.main.arn

    dynamic "service" {
      for_each = [1]
      content {
        port_name = each.key
        client_alias {
          port     = each.value.port
          dns_name = each.key
        }
      }
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy.ecs_execution]
}
