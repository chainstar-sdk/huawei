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