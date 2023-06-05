output "flavor" {
  value = data.huaweicloud_rds_flavors.this
}

output "password" {
  value = resource.random_password.default.result
  sensitive = true
}