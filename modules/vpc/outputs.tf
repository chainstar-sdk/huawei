output "vpc_id" {
  value =  module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "vpc_cidr_block" {
  value = local.vpc_cidr_block
}