variable "secret_key" {}
variable "access_key" {}

terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.47.0"
    }
  }

  backend "s3" {
    bucket                      = "terraform-bucket"
    key                         = "terraform.tfstate"
    region                      = "ap-southeast-3"
    endpoint                    = "https://obs.ap-southeast-3.myhuaweicloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

provider "huaweicloud" {
  region     = "ap-southeast-3"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "huaweicloud_availability_zones" "this" {}

module "vpc" {
  source = "./modules/vpc"
}

module "nat-public-gateway" {
  source     = "./modules/NAT-gateway/nat-public-gateway"
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.nat_subnet_ids[0]
  depends_on = [
    module.vpc
  ]
}

module "snat_rules" {
  source     = "./modules/NAT-gateway/snat"
  subnet_ids = concat(
    module.vpc.public_subnet_ids,
    module.vpc.private_subnet_ids,
  )
  nat_gateway_id = module.nat-public-gateway.nat_gateway_id
  nat_eip_id     = module.nat-public-gateway.nat_eip_id
  depends_on     = [
    module.nat-public-gateway
  ]
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  availability_zones = data.huaweicloud_availability_zones.this.names
  subnet_id          = module.vpc.database_subnet_ids[0]
}

module "cce" {
  source            = "./modules/cce/cluster"
  vpc_id            = module.vpc.vpc_id
  default_subnet_id = module.vpc.private_subnet_ids[0]
  key_pair          = "placeholder_text" # Add own SSH Key
  availability_zone = data.huaweicloud_availability_zones.this.names[0]
}

module "cce_node_pool" {
  source             = "./modules/cce/cce-node-pool"
  cce_id             = module.cce.id
  availability_zones = slice(data.huaweicloud_availability_zones.this.names, 0, 3)
}

module "gaussdb" {
  source    = "./modules/gaussdb"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.database_subnet_ids[0]
}

# Using DCS service to built a Redis cluster
module "redis_cluster" {
  source = "./modules/redis/cluster"
  vpc_id = module.vpc.vpc_id
  # Which private subnets should the the redis_be_in
  subnet_ids         = module.vpc.private_subnet_ids
  availability_zones = data.huaweicloud_availability_zones.this.names
}

# Self-Built Redis ECS instances
module "redis_ecs" {
  source            = "./modules/redis/ecs"
  availability_zone = data.huaweicloud_availability_zones.this.names[0]
  # Which subnet should the Redis be in?
  subnet_id = module.vpc.private_subnet_ids[0]
}

module "dds" {
  source            = "./modules/dds"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.database_subnet_ids[0]
  availability_zone = data.huaweicloud_availability_zones.this.names[0]
}

# Self-Built ECS for RocketMQ
module "rocketmq" {
  source             = "./modules/rocketmq"
  availability_zones = slice(data.huaweicloud_availability_zones.this.names, 0, 3)
  subnet_id          = module.vpc.private_subnet_ids[0]
}
