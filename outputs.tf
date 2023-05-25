output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_configs" {
  value = module.vpc.subnet_configs
}