output "vpc_id" {
  value =  module.vpc.vpc_id
}

output "subnet_configs" {
  value = local.subnets_configuration
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "public_nat_subnet_id" {
  value = module.vpc.public_nat_subnet_id
}

output "private_nat_subnet_id" {
  value = module.vpc.private_nat_subnet_id
}