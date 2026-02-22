# Data sources to find VPC resources by Project tag
data "aws_vpc" "main" {
  tags = {
    Project = var.name_prefix
  }
}

data "aws_subnets" "private_db" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Project = var.name_prefix
    Type    = "Private"
    Tier    = "Database"
  }
}