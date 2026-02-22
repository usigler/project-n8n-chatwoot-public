# Data sources to find VPC resources by Project tag
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

# Security Group for Redis
resource "aws_security_group" "redis" {
  name_prefix = "${var.name_prefix}-redis-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = []
    description = "Redis access managed by ECS module"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name_prefix}-redis-subnet-group"
  subnet_ids = data.aws_subnets.private_app.ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-subnet-group"
  })
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  family = "redis7"
  name   = "${var.name_prefix}-redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-params"
  })
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "main" {
  replication_group_id         = "${var.name_prefix}-redis"
  description                  = "Redis cluster for ${var.name_prefix}"
  
  node_type                    = var.node_type
  port                         = 6379
  parameter_group_name         = aws_elasticache_parameter_group.main.name
  
  num_cache_clusters           = var.num_cache_nodes
  engine_version               = var.redis_version
  
  subnet_group_name            = aws_elasticache_subnet_group.main.name
  security_group_ids           = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled   = true
  transit_encryption_enabled   = true
  auth_token                   = var.auth_token
  
  maintenance_window           = var.maintenance_window
  snapshot_retention_limit     = var.snapshot_retention_limit
  snapshot_window              = var.snapshot_window
  
  automatic_failover_enabled   = var.multi_az
  multi_az_enabled            = var.multi_az

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_slow_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_engine_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis"
  })
}

# CloudWatch Log Groups for Redis
resource "aws_cloudwatch_log_group" "redis_slow_log" {
  name              = "/aws/elasticache/${var.name_prefix}-redis/slow-log"
  retention_in_days = 1

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-slow-log"
  })
}

resource "aws_cloudwatch_log_group" "redis_engine_log" {
  name              = "/aws/elasticache/${var.name_prefix}-redis/engine-log"
  retention_in_days = 1

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-redis-engine-log"
  })
}