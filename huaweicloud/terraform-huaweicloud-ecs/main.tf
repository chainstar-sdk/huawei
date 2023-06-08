# Github Link: https: //github.com/terraform-huaweicloud-modules/terraform-huaweicloud-ecs

data "huaweicloud_availability_zones" "this" {
  count = var.availability_zone != null ? 0 : 1
}

data "huaweicloud_compute_flavors" "this" {
  count = var.is_instance_create ? (var.instance_flavor_id == null ? 1 : 0) : 0

  availability_zone = var.availability_zone == null ? try(data.huaweicloud_availability_zones.this[0].names[0], null) : var.availability_zone
  performance_type  = var.instance_flavor_performance
  cpu_core_count    = var.instance_flavor_cpu
  memory_size       = var.instance_flavor_memory
}

data "huaweicloud_images_image" "this" {
  count = var.is_instance_create ? (var.instance_image_id == null ? 1 : 0) : 0

  name        = var.instance_image_name
  most_recent = true
}

resource "huaweicloud_compute_instance" "this" {
  count = var.is_instance_create ? (var.instance_count > 0 ? var.instance_count : 1) : 0

  availability_zone = var.availability_zone  == null ? try(data.huaweicloud_availability_zones.this[0].names[0], null) : var.availability_zone
  flavor_id         = var.instance_flavor_id != null ? var.instance_flavor_id : data.huaweicloud_compute_flavors.this[0].ids[0]
  image_id          = var.instance_image_id  != null ? var.instance_image_id : data.huaweicloud_images_image.this[0].id

  name                        = var.name_suffix != null ? format("%s-%s", var.instance_name, var.name_suffix) : var.instance_name
  security_group_ids          = var.security_group_ids
  system_disk_type            = var.system_disk_type
  system_disk_size            = var.system_disk_size
  eip_id                      = var.eip_id
  stop_before_destroy         = var.stop_before_destroy
  delete_disks_on_termination = var.delete_disks_on_termination
  delete_eip_on_termination   = var.eip_id      != null ? var.delete_eip_on_termination : null

  dynamic "scheduler_hints" {
    for_each = var.scheduler_hints_configuration

    content {
      group   = scheduler_hints.value["group"]
      tenancy = scheduler_hints.value["tenancy"]
      deh_id  = scheduler_hints.value["deh_id"]
    }
  }

  dynamic "data_disks" {
    for_each = var.data_disks_configuration

    content {
      type        = data_disks.value["type"]
      size        = data_disks.value["size"]
      snapshot_id = data_disks.value["snapshot_id"]
    }
  }

  admin_pass = var.keypair_name == null ? var.admin_password : null
  key_pair   = var.keypair_name != null ? var.keypair_name : null
  user_id    = var.user_id      != null ? var.user_id : null
  user_data  = var.keypair_name != null ? var.user_data : null

  network {
    uuid              = var.subnet_id
    fixed_ip_v4       = var.fixed_ip_v4
    ipv6_enable       = var.ipv6_enable
    source_dest_check = var.source_dest_check
    access_network    = var.access_network
  }

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.is_auto_renew

  tags = merge(
    { "Name" = var.name_suffix != null ? format("%s-%s", var.instance_name, var.name_suffix) : var.instance_name },
  var.instance_tags)
}
