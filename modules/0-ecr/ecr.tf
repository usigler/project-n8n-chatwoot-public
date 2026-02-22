# ECR Repository for Chatwoot
resource "aws_ecr_repository" "chatwoot" {
  name                 = "${var.name_prefix}-chatwoot"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-chatwoot-ecr"
    Application = "chatwoot"
  })
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "chatwoot" {
  repository = aws_ecr_repository.chatwoot.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["latest"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}