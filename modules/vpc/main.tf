locals {
  vpc_name       = "NB-Production-vpc"
  vpc_cidr_block = "10.10.0.0/16"
}

module "vpc" {
  source         = "git::https://github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc.git"
  vpc_name       = local.vpc_name
  vpc_cidr_block = local.vpc_cidr_block

  subnets_configuration = [
      // Subnets with private only access for server clusters in each AZ
    {name="private-az1-1", cidr="10.10.0.0/24"},
    {name="private-az2-1", cidr="10.10.1.0/24"},
    {name="private-az3-1", cidr="10.10.2.0/24"},
    {name="private-az4-1", cidr="10.10.3.0/24"},
    {name="private-az1-2", cidr="10.10.4.0/24"},
    {name="private-az2-2", cidr="10.10.5.0/24"},
    {name="private-az3-2", cidr="10.10.6.0/24"},
    {name="private-az4-2", cidr="10.10.7.0/24"},

    {name="private-az1-3", cidr="10.10.10.0/24"},
    {name="private-az2-3", cidr="10.10.11.0/24"},
    {name="private-az3-3", cidr="10.10.12.0/24"},
    {name="private-az4-3", cidr="10.10.13.0/24"},
  
      // Subnets with public NAT gateway access for server clusters in each AZ
    {name="public-az1", cidr="10.10.20.0/24"},
    {name="public-az2", cidr="10.10.21.0/24"},
    {name="public-az3", cidr="10.10.22.0/24"},
    {name="public-az4", cidr="10.10.23.0/24"},
  
      // Subnets for database clusters in each AZ
    {name="database-az1", cidr="10.10.100.0/24"},
    {name="database-az2", cidr="10.10.101.0/24"},
    {name="database-az3", cidr="10.10.102.0/24"},
    {name="database-az3", cidr="10.10.103.0/24"},
    

      // Additional subnets for NAT gateways
    {name="public-nat-default", cidr="10.10.200.0/24"},
    {name="private-nat-default", cidr="10.10.201.0/24"}
  ]
  
  is_security_group_create = false
}

  /**
  For the missing supported flags,

  - enable_nat_gateway = true
  - single_nat_gateway = true

  This feature enables the user to create a single NAT gateway + IP address for multiple subnets.

  For public subnets,

    - https: //github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/nat_gateway.md
    - https: //github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/nat_snat_rule.md

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

    - https: //github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/dns_zone.md
    - https: //github.com/huaweicloud/terraform-provider-huaweicloud/blob/master/docs/resources/dns_recordset.md

    1. Create the private DNS zone and assign to the VPC.
    2. Create the DNS records to tie to the relevant IP addresses.

  Configuration of the private and public ELB is done on the manifest levels.
*/