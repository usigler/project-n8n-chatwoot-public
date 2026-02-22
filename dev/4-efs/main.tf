variable "aws_region" {}
variable "environment" {}
variable "project_name" {}
variable "performance_mode" {}
variable "throughput_mode" {}
variable "transition_to_ia" {}

# EFS Module
module "efs" {
  source = "../../modules/4-efs"

  name_prefix = var.project_name
  
  performance_mode   = var.performance_mode
  throughput_mode    = var.throughput_mode
  transition_to_ia   = var.transition_to_ia

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}