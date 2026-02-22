variable "aws_region" {}
variable "environment" {}
variable "project_name" {}
variable "enable_deletion_protection" {}
variable "ssl_certificate_arn" {}
variable "ssl_policy" {}
variable "n8n_domain" {}
variable "chatwoot_domain" {}
variable "n8n_port" {}
variable "chatwoot_port" {}
variable "n8n_health_check_path" {}
variable "chatwoot_health_check_path" {}
variable "enable_http_listener" {}

# ALB Module
module "alb" {
  source = "../../modules/5-alb"

  name_prefix           = var.project_name
  
  enable_deletion_protection = var.enable_deletion_protection
  ssl_certificate_arn       = var.ssl_certificate_arn
  ssl_policy               = var.ssl_policy
  
  n8n_domain      = var.n8n_domain
  chatwoot_domain = var.chatwoot_domain
  
  n8n_port      = var.n8n_port
  chatwoot_port = var.chatwoot_port
  
  n8n_health_check_path      = var.n8n_health_check_path
  chatwoot_health_check_path = var.chatwoot_health_check_path
  enable_http_listener       = var.enable_http_listener

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}