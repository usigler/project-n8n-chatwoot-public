output "file_system_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.main.id
}

output "file_system_arn" {
  description = "EFS file system ARN"
  value       = aws_efs_file_system.main.arn
}

output "file_system_dns_name" {
  description = "EFS file system DNS name"
  value       = aws_efs_file_system.main.dns_name
}

output "n8n_access_point_id" {
  description = "N8N EFS access point ID"
  value       = aws_efs_access_point.n8n.id
}

output "n8n_access_point_arn" {
  description = "N8N EFS access point ARN"
  value       = aws_efs_access_point.n8n.arn
}

output "chatwoot_access_point_id" {
  description = "Chatwoot EFS access point ID"
  value       = aws_efs_access_point.chatwoot.id
}

output "chatwoot_access_point_arn" {
  description = "Chatwoot EFS access point ARN"
  value       = aws_efs_access_point.chatwoot.arn
}

output "security_group_id" {
  description = "Security group ID for EFS"
  value       = aws_security_group.efs.id
}