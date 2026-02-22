# Configure Terraform and Backend
terraform {
  required_version = ">= 1.3.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key = "ecs/terraform.tfstate"
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}
