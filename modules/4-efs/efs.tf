# Security Group for EFS
resource "aws_security_group" "efs" {
  name_prefix = "${var.name_prefix}-efs-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = []
    description = "EFS access managed by ECS module"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# EFS File System
resource "aws_efs_file_system" "main" {
  creation_token = "${var.name_prefix}-efs"
  
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = true

  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs"
  })
}

# EFS Mount Targets
resource "aws_efs_mount_target" "main" {
  count = length(data.aws_subnets.private_app.ids)

  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = data.aws_subnets.private_app.ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

# EFS Access Points
resource "aws_efs_access_point" "n8n" {
  file_system_id = aws_efs_file_system.main.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/n8n"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-n8n-access-point"
    Application = "n8n"
  })
}

resource "aws_efs_access_point" "chatwoot" {
  file_system_id = aws_efs_file_system.main.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/chatwoot"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-chatwoot-access-point"
    Application = "chatwoot"
  })
}