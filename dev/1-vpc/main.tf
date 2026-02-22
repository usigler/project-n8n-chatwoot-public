variable "environment" {}
variable "project_name" {}
variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "private_app_subnet_cidrs" {}
variable "private_db_subnet_cidrs" {}

# VPC Module
module "vpc" {
  source = "../../modules/1-vpc"

  name_prefix = var.project_name
  aws_region  = var.aws_region
  vpc_cidr    = var.vpc_cidr

  public_subnet_cidrs     = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}