# Data sources to find ALB resources by Project tag
data "aws_lb" "main" {
  tags = {
    Project = var.name_prefix
  }
}