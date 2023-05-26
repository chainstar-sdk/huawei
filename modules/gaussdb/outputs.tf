output "flavors" {
    value = [ for flavor in data.huaweicloud_gaussdb_mysql_flavors.flavors.flavors: flavor ]
}

output "test" {
    value = 123
}