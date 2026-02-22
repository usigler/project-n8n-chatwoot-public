output "chatwoot_repository_url" {
  description = "URL of the Chatwoot ECR repository"
  value       = aws_ecr_repository.chatwoot.repository_url
}

output "chatwoot_repository_arn" {
  description = "ARN of the Chatwoot ECR repository"
  value       = aws_ecr_repository.chatwoot.arn
}