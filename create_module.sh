#!/bin/bash
echo "Please enter the directory name"
read dir_name

echo "creating module in ./modules/$dir_name"
cd "./modules"
mkdir $dir_name
cd $dir_name


touch main.tf
touch variables.tf
touch version.tf
touch outputs.tf

cat << EOT >> version.tf 
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.47.0"
    }
  }
}
EOT





