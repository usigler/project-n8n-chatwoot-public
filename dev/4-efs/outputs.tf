output "file_system_id" {
  description = "EFS file system ID"
  value       = module.efs.file_system_id
}

output "n8n_access_point_id" {
  description = "N8N EFS access point ID"
  value       = module.efs.n8n_access_point_id
}

output "chatwoot_access_point_id" {
  description = "Chatwoot EFS access point ID"
  value       = module.efs.chatwoot_access_point_id
}
