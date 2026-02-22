variable "aws_region" {}
variable "environment" {}
variable "project_name" {}
variable "rate_limit" {}
variable "blocked_countries" {}
variable "log_retention_days" {}

# WAF Module
module "waf" {
  source = "../../modules/7-waf"

  name_prefix        = var.project_name
  
  rate_limit        = var.rate_limit
  blocked_countries = var.blocked_countries
  log_retention_days = var.log_retention_days

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}