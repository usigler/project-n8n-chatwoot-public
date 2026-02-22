variable "environment" {}
variable "project_name" {}
variable "postgres_version" {}
variable "parameter_group_family" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "database_name" {}
variable "master_username" {}
variable "backup_retention_period" {}
variable "skip_final_snapshot" {}
variable "deletion_protection" {}
variable "multi_az" {}
variable "aws_region" {}

# RDS Module
module "rds" {
  source = "../../modules/2-rds"

  name_prefix = var.project_name
  
  postgres_version         = var.postgres_version
  parameter_group_family   = var.parameter_group_family
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  
  database_name           = var.database_name
  master_username         = var.master_username
  
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  multi_az                = var.multi_az

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}