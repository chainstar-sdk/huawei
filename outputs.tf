output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs
}

output "subnet_configs" {
  value = module.vpc.subnet_configs
}

output "availability_zones" {
  value = data.huaweicloud_availability_zones.this.names
}

output "rds_passwords" {
  value = { for k, v in module.rds : 
  k => {
    "password" = v.password,
    "flavor"   = v.flavor
  }}
  sensitive = true
}