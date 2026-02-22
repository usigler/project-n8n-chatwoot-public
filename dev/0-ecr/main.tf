module "ecr" {
  source = "../../modules/0-ecr"

  name_prefix = local.name_prefix
  tags        = local.tags
}