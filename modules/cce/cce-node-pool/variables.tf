variable "cce_id" {}
variable "availability_zones" {}

variable "name" {
    type = string
}

# variable "security_group_id" {
#     type = string
# }

variable "key_pair" {
    type = string
}

variable "os" {
    type = string
}

variable "node_count" {
    type = number
}

variable "min_node_count" {
    type = number
}

variable "max_node_count" {
    type = number
}

variable "flavor_id" {
    type = string
}

variable "taints" {
    type = list(object({
        key = string
        value = string
        effect = string
    }))
}

variable "root_volume" {
    type = object({
      size = number
      volume_type = string
    })
}

variable "data_volume" {
    type = object({
      size = number
      volume_type = string 
    })
}