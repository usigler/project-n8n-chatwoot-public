# Local variables
locals {
  name_prefix = var.project_name
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "acm" {
  source = "../../modules/0-acm"

  name_prefix            = local.name_prefix
  private_key_path       = var.private_key_path
  certificate_path       = var.certificate_path
  certificate_chain_path = var.certificate_chain_path
  tags                   = local.tags
}