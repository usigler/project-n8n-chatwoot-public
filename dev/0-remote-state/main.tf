variable "environment" {}
variable "project_name" {}
variable "aws_region" {}

# Remote State Module
module "remote_state" {
  source = "../../modules/0-remote-state"

  name_prefix  = var.project_name
  project_name = var.project_name
  environment  = var.environment

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}