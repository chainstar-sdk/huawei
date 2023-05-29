## That Redis which uses self-built ECS
module "security_group" {
  source = "../../security-groups/default"
}
# Flavor for redis instance

# Used 8vcpu 32gb-mem as 4vcpu 32gb-mem not applicable
data "huaweicloud_compute_flavors" "redis_flavor" {
  availability_zone = var.availability_zone
  performance_type  = "normal"
  cpu_core_count    = 8
  memory_size       = 32
}

# Image for redis instances

data "huaweicloud_images_image" "redis_image" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

# Volume for redis instance

resource "huaweicloud_evs_volume" "redis_volume" {
  name              = "redis_volume"
  availability_zone = var.availability_zone
  volume_type       = "SAS"
  size              = 100
}

# ECS's (called huaweicloud_compute_instance) of redis

resource "huaweicloud_compute_instance" "redis_instance" {
  name               = "redis_instance"
  image_id           = data.huaweicloud_images_image.redis_image.id #required
  flavor_id          = data.huaweicloud_compute_flavors.redis_flavor.ids[0] #required
  security_group_ids = [module.security_group.id]
  availability_zone  = var.availability_zone

  network { #required
    uuid = var.subnet_id #required
  }
}

# Attach volume to redis instance

resource "huaweicloud_compute_volume_attach" "attached" {
  instance_id = huaweicloud_compute_instance.redis_instance.id
  volume_id   = huaweicloud_evs_volume.redis_volume.id
}