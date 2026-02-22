# Data sources to find VPC resources by Project tag
data "aws_vpc" "main" {
  tags = {
    Project = var.name_prefix
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Project = var.name_prefix
    Type    = "Public"
  }
}

# ACM Certificate
data "aws_acm_certificate" "main" {
  count  = var.ssl_certificate_arn == null ? 1 : 0
  domain = "*.example.com"
  
  tags = {
    Project = var.name_prefix
  }
}