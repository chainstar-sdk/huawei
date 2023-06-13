module "security_group" {
  source      = "./default"
  name        = var.security_group_name
  description = var.description
}

module "security_group_rules" {
  source            = "./rules"
  security_group_id = module.security_group.id
  rules             = var.rules
}