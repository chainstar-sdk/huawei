module "vpc" {
  source = "git::https://github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc.git"

  vpc_name       = "NB-Production-vpc"
  vpc_cidr_block = "10.0.0.0/16"

  subnets_configuration = [
    // Subnets with private only access for server clusters in each AZ
    {name="private-az-1", cidr="10.0.0.0/24"},
    {name="private-az-2", cidr="10.0.1.0/24"},
    {name="private-az-3", cidr="10.0.2.0/24"},
  
    // Subnets with public NAT gateway access for server clusters in each AZ
    {name="public-az-1", cidr="10.0.10.0/24"},
    {name="public-az-2", cidr="10.0.11.0/24"},
    {name="public-az-3", cidr="10.0.12.0/24"},
  
    // Subnets for database clusters in each AZ
    {name="database-az-1", cidr="10.0.100.0/24"},
    {name="database-az-2", cidr="10.0.101.0/24"},
    {name="database-az-3", cidr="10.0.102.0/24"},

    // Additional subnets for NAT gateways
    {name="public-nat-default", cidr="10.0.200.0/24"},
    {name="private-nat-default", cidr="10.0.201.0/24"}
  ]
  
  is_security_group_create = false
}

/**
  For the missing supported flags,

  - enable_nat_gateway   = true
  - single_nat_gateway   = true 

  This feature enables the user to create a single NAT gateway + IP address for multiple subnets.

  For public subnets,

    - https://github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/nat_gateway.md
    - https://github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/nat_snat_rule.md

    1. Create an extra default subnet for the gateway in the same VPC.
    2. Create the public NAT gateway and assign the default subnet to it with the same VPC.
    3. Create an EIP to bind to the NAT gateway.
    4. For each public subnet, create the SNAT rule to it with the same EIP created as floating_ip.

  Not caring about private NAT gateway for now unless asked. Public NAT gateway seemed obvious because of public subnets.

  Some constraints,

    1. EIP not been bound
    2. EIP has been bound to a DNAT rule with Port Type set to Specific port of the current public NAT gateway
    3. EIP has been bound to an SNAT rule of the current public NAT gateway.

  - enable_dns_hostnames = true

  This feature means to resolve DNS hostnames to the IP addresses in the VPC.

  To do so, create a DNS private zone.

    - https://github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/dns_zone.md
    - https://github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/dns_recordset.md

    1. Create the private DNS zone and assign to the VPC.
    2. Create the DNS records to tie to the relevant IP addresses.

  Configuration of the private and public ELB is done on the manifest levels.
*/