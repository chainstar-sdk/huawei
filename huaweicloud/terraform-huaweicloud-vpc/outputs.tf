output "vpc_id" {
    description = "The ID of the VPC resource"
    value       = try(huaweicloud_vpc.this[0].id, "")
}

output "vpc_cidr" {
    description = "The CIDR block of the VPC resource"
    value       = try(huaweicloud_vpc.this[0].cidr, "")
}

output "subnet_cidrs" {
    description = "The CIDR list of the subnet resources to which the VPC resource belongs"
    value       = try(huaweicloud_vpc_subnet.this[*].cidr, [])
}

output "subnet_ids" {
    description = "The ID list of the subnet resources to which the VPC resource belongs"
    value       = try(huaweicloud_vpc_subnet.this[*].id, [])
}

output "security_group_id" {
    description = "The ID of the security group resource"
    value       = try(huaweicloud_networking_secgroup.this[0].id, "")
}

output "security_group_rules" {
    description = "All rules to which the security group resource belongs"
    value       = try(huaweicloud_networking_secgroup.this[0].rules, null)
}


# Added
# Section for private, public, database and public/private NAT subnet ids
# No description was added as output names are self-explainatory

output "private_subnet_ids" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("private-.*", subnet.name)) > 0]
}

output "private_subnet_cidrs" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.cidr if length(regexall("private-.*", subnet.name)) > 0]
}

output "public_subnet_ids" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("public.*", subnet.name)) > 0]
}

output "public_subnet_cidrs" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.cidr if length(regexall("public.*", subnet.name)) > 0]
}

output "database_subnet_ids" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("database.*", subnet.name)) > 0]
}

output "nat_subnet_ids" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("nat-*", subnet.name)) > 0]
}

output "public_nat_subnet_id" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("public-nat-default", subnet.name)) > 0]
}

output "private_nat_subnet_id" {
  value = [for subnet in huaweicloud_vpc_subnet.this : subnet.id if length(regexall("private-nat-default", subnet.name)) > 0]
}
