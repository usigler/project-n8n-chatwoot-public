output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.main.arn
}

output "n8n_service_id" {
  description = "N8N ECS service ID"
  value       = aws_ecs_service.n8n.id
}

output "chatwoot_service_id" {
  description = "Chatwoot ECS service ID"
  value       = aws_ecs_service.chatwoot.id
}

output "n8n_task_definition_arn" {
  description = "N8N task definition ARN"
  value       = aws_ecs_task_definition.n8n.arn
}

output "chatwoot_task_definition_arn" {
  description = "Chatwoot task definition ARN"
  value       = aws_ecs_task_definition.chatwoot.arn
}

output "security_group_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs_tasks.id
}

output "chatwoot_ecr_repository_url" {
  description = "Chatwoot ECR repository URL"
  value       = data.aws_ecr_repository.chatwoot.repository_url
}

output "chatwoot_ecr_image" {
  description = "Chatwoot ECR image with tag"
  value       = "${data.aws_ecr_repository.chatwoot.repository_url}:latest"
}