## Rocketmq, with 2 ECS instances

# Flavor for rocketmq instances

data "huaweicloud_compute_flavors" "rocketmq_flavor" {
  availability_zone = var.availability_zone
  performance_type  = "normal"
  cpu_core_count    = 16
  memory_size       = 32
}

# Image for rocketmq instances

data "huaweicloud_images_image" "rocketmq_image" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

# Separate Volumes for rocketmq ECS instances

resource "huaweicloud_evs_volume" "rocketmq_volume_1" {
  name              = "rocketmq_volume_1"
  availability_zone = var.availability_zone
  volume_type       = "SAS"
  size              = 500
}

resource "huaweicloud_evs_volume" "rocketmq_volume_2" {
  name              = "rocketmq_volume_2"
  availability_zone = var.availability_zone
  volume_type       = "SAS"
  size              = 500
}

# ECS's (called huaweicloud_compute_instance) of rocketmq

resource "huaweicloud_compute_instance" "rocketmq_instance_1" {
  name               = "rocketmq_instance_1" #required
  image_id           = data.huaweicloud_images_image.rocketmq_image.id #required
  flavor_id          = data.huaweicloud_compute_flavors.rocketmq_flavor.ids[0] #required
  security_group_ids = [var.secgroup_id]
  availability_zone  = var.availability_zone

  network { #required
    uuid = var.subnet_id #required
  }
}

resource "huaweicloud_compute_instance" "rocketmq_instance_2" {
  name               = "rocketmq_instance_2" #required
  image_id           = data.huaweicloud_images_image.rocketmq_image.id #required
  flavor_id          = data.huaweicloud_compute_flavors.rocketmq_flavor.ids[0] #required
  security_group_ids = [var.secgroup_id]
  availability_zone  = var.availability_zone

  network { #required
    uuid = var.subnet_id #required
  }
}

# Attach separate volumes to each ECS instance

resource "huaweicloud_compute_volume_attach" "attached_1" {
  instance_id = huaweicloud_compute_instance.rocketmq_instance_1.id
  volume_id   = huaweicloud_evs_volume.rocketmq_volume_1.id
}

resource "huaweicloud_compute_volume_attach" "attached_2" {
  instance_id = huaweicloud_compute_instance.rocketmq_instance_2.id
  volume_id   = huaweicloud_evs_volume.rocketmq_volume_2.id
}
