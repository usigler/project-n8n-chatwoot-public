# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = data.aws_subnets.private_db.ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-subnet-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.name_prefix}-rds-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = []
    description = "PostgreSQL access managed by ECS module"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-rds-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "main" {
  family = var.parameter_group_family
  name   = "${var.name_prefix}-postgres-params"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  parameter {
    name  = "search_path"
    value = "n8n,public"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-postgres-params"
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.name_prefix}-postgres"

  engine         = "postgres"
  engine_version = var.postgres_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.master_username
  password = random_password.db_password.result

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name_prefix}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  deletion_protection = var.deletion_protection

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-postgres"
  })
}