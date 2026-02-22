variable "environment" {}
variable "project_name" {}
variable "node_type" {}
variable "num_cache_nodes" {}
variable "redis_version" {}
variable "auth_token" {}
variable "maintenance_window" {}
variable "snapshot_retention_limit" {}
variable "snapshot_window" {}
variable "multi_az" {}
variable "aws_region" {}

# Redis Module
module "redis" {
  source = "../../modules/3-redis"

  name_prefix = var.project_name
  
  node_type               = var.node_type
  num_cache_nodes         = var.num_cache_nodes
  redis_version           = var.redis_version
  auth_token              = var.auth_token
  
  maintenance_window      = var.maintenance_window
  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window         = var.snapshot_window
  multi_az                = var.multi_az

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}