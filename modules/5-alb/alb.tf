# S3 Bucket for ALB Access Logs
resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.name_prefix}-alb-logs-${random_string.bucket_suffix.result}"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-logs"
  })
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::033677994240:root"  # ELB service account for us-east-2
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs.arn}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs.arn}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::033677994240:root"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.alb_logs.arn
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name_prefix = "${var.name_prefix}-alb-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "alb"
    enabled = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb"
  })
}

# Target Groups
resource "aws_lb_target_group" "n8n" {
  name_prefix = "n8n-"
  port        = var.n8n_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  # WebSocket support
  protocol_version = "HTTP1"
  
  # Sticky sessions for WebSocket
  stickiness {
    enabled = true
    type    = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.n8n_health_check_path
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-n8n-tg"
    Application = "n8n"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "chatwoot" {
  name_prefix = "chat-"
  port        = var.chatwoot_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  # WebSocket support
  protocol_version = "HTTP1"
  
  # Sticky sessions for WebSocket
  stickiness {
    enabled = true
    type    = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.chatwoot_health_check_path
    matcher             = "200,301"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-chatwoot-tg"
    Application = "chatwoot"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# HTTP Listener (Redirect to HTTPS or Direct Routing)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate_arn != null ? var.ssl_certificate_arn : data.aws_acm_certificate.main[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.n8n.arn
  }

  tags = var.tags
}

# Listener Rules
resource "aws_lb_listener_rule" "chatwoot" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chatwoot.arn
  }

  condition {
    host_header {
      values = [var.chatwoot_domain]
    }
  }

  tags = merge(var.tags, {
    Application = "chatwoot"
  })
}