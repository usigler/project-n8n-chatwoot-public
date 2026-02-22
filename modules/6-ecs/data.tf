# Data sources to find resources by Project tag
data "aws_vpc" "main" {
  tags = {
    Project = var.name_prefix
  }
}

data "aws_subnets" "private_app" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Project = var.name_prefix
    Type    = "Private"
    Tier    = "Application"
  }
}

data "aws_db_instance" "main" {
  db_instance_identifier = "${var.name_prefix}-postgres"
}

data "aws_efs_file_system" "main" {
  tags = {
    Project = var.name_prefix
  }
}

data "aws_efs_access_points" "n8n" {
  file_system_id = data.aws_efs_file_system.main.id
}

data "aws_efs_access_point" "n8n" {
  access_point_id = data.aws_efs_access_points.n8n.ids[0]
}

data "aws_efs_access_points" "chatwoot" {
  file_system_id = data.aws_efs_file_system.main.id
}

data "aws_efs_access_point" "chatwoot" {
  access_point_id = data.aws_efs_access_points.chatwoot.ids[1]
}

data "aws_lb" "main" {
  tags = {
    Project = var.name_prefix
  }
}

data "aws_lb_target_group" "n8n" {
  tags = {
    Project     = var.name_prefix
    Application = "n8n"
  }
}

data "aws_lb_target_group" "chatwoot" {
  tags = {
    Project     = var.name_prefix
    Application = "chatwoot"
  }
}

data "aws_security_group" "rds" {
  tags = {
    Project = var.name_prefix
    Name    = "${var.name_prefix}-rds-sg"
  }
}

data "aws_security_group" "redis" {
  tags = {
    Project = var.name_prefix
    Name    = "${var.name_prefix}-redis-sg"
  }
}

data "aws_security_group" "efs" {
  tags = {
    Project = var.name_prefix
    Name    = "${var.name_prefix}-efs-sg"
  }
}

data "aws_security_group" "alb" {
  tags = {
    Project = var.name_prefix
    Name    = "${var.name_prefix}-alb-sg"
  }
}

data "aws_secretsmanager_secrets" "db_password_list" {
  filter {
    name   = "tag-key"
    values = ["Project"]
  }
  filter {
    name   = "tag-value"
    values = [var.name_prefix]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
  filter {
    name   = "tag-value"
    values = ["${var.name_prefix}-rds-password"]
  }
}

data "aws_secretsmanager_secret" "db_password" {
  arn = tolist(data.aws_secretsmanager_secrets.db_password_list.arns)[0]
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

data "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.name_prefix}-redis"
}

data "aws_ecr_repository" "chatwoot" {
  name = "${var.name_prefix}-chatwoot"
}

data "aws_region" "current" {}

# Get correct Redis endpoint
locals {
  redis_endpoint = data.aws_elasticache_replication_group.redis.configuration_endpoint_address != null ? data.aws_elasticache_replication_group.redis.configuration_endpoint_address : data.aws_elasticache_replication_group.redis.primary_endpoint_address
}