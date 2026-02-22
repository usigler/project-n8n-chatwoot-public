variable "aws_region" {}
variable "environment" {}
variable "project_name" {}
variable "n8n_domain" {}
variable "chatwoot_domain" {}
variable "n8n_port" {}
variable "chatwoot_port" {}
variable "n8n_image" {}
variable "n8n_cpu" {}
variable "n8n_memory" {}
variable "chatwoot_cpu" {}
variable "chatwoot_memory" {}
variable "n8n_desired_count" {}
variable "chatwoot_desired_count" {}
variable "log_retention_days" {}

# ECS Module
module "ecs" {
  source = "../../modules/6-ecs"

  name_prefix  = var.project_name
  project_name = var.project_name
  environment  = var.environment
  
  n8n_efs_access_point_id      = data.terraform_remote_state.efs.outputs.n8n_access_point_id
  chatwoot_efs_access_point_id = data.terraform_remote_state.efs.outputs.chatwoot_access_point_id
  
  n8n_domain      = var.n8n_domain
  chatwoot_domain = var.chatwoot_domain
  
  n8n_port      = var.n8n_port
  chatwoot_port = var.chatwoot_port
  
  n8n_image      = var.n8n_image
  
  n8n_cpu      = var.n8n_cpu
  n8n_memory   = var.n8n_memory
  chatwoot_cpu = var.chatwoot_cpu
  chatwoot_memory = var.chatwoot_memory
  
  n8n_desired_count      = var.n8n_desired_count
  chatwoot_desired_count = var.chatwoot_desired_count
  
  log_retention_days = var.log_retention_days

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}