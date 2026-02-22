output "chatwoot_ecr_repository_url" {
  description = "Chatwoot ECR repository URL"
  value       = module.ecs.chatwoot_ecr_repository_url
}

output "chatwoot_ecr_image" {
  description = "Chatwoot ECR image with tag"
  value       = module.ecs.chatwoot_ecr_image
}
