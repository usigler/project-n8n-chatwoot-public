# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-cluster"
  })
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.name_prefix}-ecs-tasks-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = var.n8n_port
    to_port         = var.n8n_port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  ingress {
    from_port       = var.chatwoot_port
    to_port         = var.chatwoot_port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-tasks-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name_prefix}-ecs-task-execution-role"

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

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task" {
  name = "${var.name_prefix}-ecs-task-role"

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

  tags = var.tags
}

# N8N Task Definition
resource "aws_ecs_task_definition" "n8n" {
  family                   = "${var.name_prefix}-n8n"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.n8n_cpu
  memory                   = var.n8n_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn           = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "n8n"
      image = var.n8n_image
      
      portMappings = [
        {
          containerPort = var.n8n_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_TYPE"
          value = "postgresdb"
        },
        {
          name  = "DB_POSTGRESDB_HOST"
          value = data.aws_db_instance.main.address
        },
        {
          name  = "DB_POSTGRESDB_PORT"
          value = tostring(data.aws_db_instance.main.port)
        },
        {
          name  = "DB_POSTGRESDB_DATABASE"
          value = data.aws_db_instance.main.db_name
        },
        {
          name  = "DB_POSTGRESDB_USER"
          value = data.aws_db_instance.main.master_username
        },
        {
          name  = "DB_POSTGRESDB_PASSWORD"
          value = data.aws_secretsmanager_secret_version.db_password.secret_string
        },
        {
          name  = "DB_POSTGRESDB_SCHEMA"
          value = "n8n"
        },
        {
          name  = "N8N_HOST"
          value = var.n8n_domain
        },
        {
          name  = "N8N_PROTOCOL"
          value = "https"
        },
        {
          name  = "WEBHOOK_URL"
          value = "https://${var.n8n_domain}/"
        },
        {
          name  = "GENERIC_TIMEZONE"
          value = "America/Sao_Paulo"
        },
        {
          name  = "N8N_SECURE_COOKIE"
          value = "false"
        },
        {
          name  = "N8N_EDITOR_BASE_URL"
          value = "https://${var.n8n_domain}"
        },
        {
          name  = "N8N_HIDE_USAGE_PAGE"
          value = "false"
        },
        {
          name  = "N8N_PROXY_HOPS"
          value = "1"
        },
        {
          name  = "N8N_TRUST_PROXY"
          value = "true"
        },
        {
          name  = "N8N_LOG_LEVEL"
          value = "debug"
        },
        {
          name  = "N8N_LOG_OUTPUT"
          value = "console"
        },
        {
          name  = "EXECUTIONS_MODE"
          value = "regular"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "n8n-data"
          containerPath = "/home/node/.n8n"
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.n8n.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true
    }
  ])

  volume {
    name = "n8n-data"

    efs_volume_configuration {
      file_system_id          = data.aws_efs_file_system.main.file_system_id
      root_directory          = "/"
      authorization_config {
        access_point_id = data.aws_efs_access_point.n8n.id
      }
      transit_encryption      = "ENABLED"
    }
  }

  tags = merge(var.tags, {
    Application = "n8n"
  })
}

# Chatwoot Task Definition
resource "aws_ecs_task_definition" "chatwoot" {
  family                   = "${var.name_prefix}-chatwoot"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.chatwoot_cpu
  memory                   = var.chatwoot_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn           = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "chatwoot"
      image = "${data.aws_ecr_repository.chatwoot.repository_url}:latest"
      
      portMappings = [
        {
          containerPort = var.chatwoot_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "INSTALLATION_ENV"
          value = "aws"
        },
        {
          name  = "DEFAULT_LOCALE"
          value = "pt_BR"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "true"
        },
        {
          name  = "POSTGRES_HOST"
          value = data.aws_db_instance.main.address
        },
        {
          name  = "POSTGRES_PORT"
          value = tostring(data.aws_db_instance.main.port)
        },
        {
          name  = "POSTGRES_DATABASE"
          value = data.aws_db_instance.main.db_name
        },
        {
          name  = "POSTGRES_USERNAME"
          value = data.aws_db_instance.main.master_username
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = data.aws_secretsmanager_secret_version.db_password.secret_string
        },
        {
          name  = "SECRET_KEY_BASE"
          value = aws_secretsmanager_secret_version.chatwoot_secret_key_base.secret_string
        },
        {
          name  = "REDIS_URL"
          value = "rediss://${data.aws_elasticache_replication_group.redis.primary_endpoint_address}:6379"
        },
        {
          name  = "REDIS_TIMEOUT"
          value = "10"
        },
        {
          name  = "REDIS_POOL_SIZE"
          value = "10"
        },
        {
          name  = "FRONTEND_URL"
          value = "https://${var.chatwoot_domain}"
        },
        {
          name  = "FORCE_SSL"
          value = "true"
        },
        {
          name  = "TRUSTED_PROXIES"
          value = "10.0.0.0/8"
        }
      ]

      entryPoint = ["docker/entrypoints/rails.sh"]
      
      command = ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]

      mountPoints = [
        {
          sourceVolume  = "chatwoot-data"
          containerPath = "/app/storage"
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/api/v1/accounts || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 120
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.chatwoot.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true
    }
  ])

  volume {
    name = "chatwoot-data"

    efs_volume_configuration {
      file_system_id          = data.aws_efs_file_system.main.file_system_id
      root_directory          = "/"
      authorization_config {
        access_point_id = data.aws_efs_access_point.chatwoot.id
      }
      transit_encryption      = "ENABLED"
    }
  }

  tags = merge(var.tags, {
    Application = "chatwoot"
  })
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "n8n" {
  name              = "/ecs/${var.name_prefix}-n8n"
  retention_in_days = 1

  tags = merge(var.tags, {
    Application = "n8n"
  })
}

resource "aws_cloudwatch_log_group" "chatwoot" {
  name              = "/ecs/${var.name_prefix}-chatwoot"
  retention_in_days = 1

  tags = merge(var.tags, {
    Application = "chatwoot"
  })
}

# ECS Services
resource "aws_ecs_service" "n8n" {
  name            = "${var.name_prefix}-n8n"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.n8n.arn
  desired_count   = var.n8n_desired_count
  launch_type     = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = data.aws_subnets.private_app.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.n8n.arn
    container_name   = "n8n"
    container_port   = var.n8n_port
  }

  depends_on = [data.aws_lb_target_group.n8n]

  tags = merge(var.tags, {
    Application = "n8n"
  })
}

resource "aws_ecs_service" "chatwoot" {
  name            = "${var.name_prefix}-chatwoot"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.chatwoot.arn
  desired_count   = var.chatwoot_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private_app.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.chatwoot.arn
    container_name   = "chatwoot"
    container_port   = var.chatwoot_port
  }

  depends_on = [data.aws_lb_target_group.chatwoot]

  tags = merge(var.tags, {
    Application = "chatwoot"
  })
}

# Security Group Rules for ECS to access other services

# Sidekiq Task Definition
resource "aws_ecs_task_definition" "sidekiq" {
  family                   = "${var.name_prefix}-sidekiq"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn           = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "sidekiq"
      image = "${data.aws_ecr_repository.chatwoot.repository_url}:latest"

      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "INSTALLATION_ENV"
          value = "aws"
        },
        {
          name  = "DEFAULT_LOCALE"
          value = "pt_BR"
        },
        {
          name  = "POSTGRES_HOST"
          value = data.aws_db_instance.main.address
        },
        {
          name  = "POSTGRES_PORT"
          value = tostring(data.aws_db_instance.main.port)
        },
        {
          name  = "POSTGRES_DATABASE"
          value = data.aws_db_instance.main.db_name
        },
        {
          name  = "POSTGRES_USERNAME"
          value = data.aws_db_instance.main.master_username
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = data.aws_secretsmanager_secret_version.db_password.secret_string
        },
        {
          name  = "SECRET_KEY_BASE"
          value = aws_secretsmanager_secret_version.chatwoot_secret_key_base.secret_string
        },
        {
          name  = "REDIS_URL"
          value = "rediss://${local.redis_endpoint}:6379"
        },
        {
          name  = "REDIS_TIMEOUT"
          value = "10"
        },
        {
          name  = "REDIS_POOL_SIZE"
          value = "10"
        },
        {
          name  = "FRONTEND_URL"
          value = "https://${var.chatwoot_domain}"
        },
        {
          name  = "FORCE_SSL"
          value = "true"
        },
        {
          name  = "TRUSTED_PROXIES"
          value = "10.0.0.0/8"
        }
      ]

      command = ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]

      mountPoints = [
        {
          sourceVolume  = "chatwoot-data"
          containerPath = "/app/storage"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.sidekiq.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true
    }
  ])

  volume {
    name = "chatwoot-data"

    efs_volume_configuration {
      file_system_id          = data.aws_efs_file_system.main.file_system_id
      root_directory          = "/"
      authorization_config {
        access_point_id = data.aws_efs_access_point.chatwoot.id
      }
      transit_encryption      = "ENABLED"
    }
  }

  tags = merge(var.tags, {
    Application = "sidekiq"
  })
}

resource "aws_cloudwatch_log_group" "sidekiq" {
  name              = "/ecs/${var.name_prefix}-sidekiq"
  retention_in_days = 1

  tags = merge(var.tags, {
    Application = "sidekiq"
  })
}

resource "aws_ecs_service" "sidekiq" {
  name            = "${var.name_prefix}-sidekiq"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sidekiq.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private_app.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  tags = merge(var.tags, {
    Application = "sidekiq"
  })
}
