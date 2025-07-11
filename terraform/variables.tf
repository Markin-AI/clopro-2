###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "HW_Netology"
  description = "VPC network"
}

variable "public_subnet" {
  type        = string
  default     = "public"
  description = "subnet name"
}

# variable "vm_metadata" {
#   type        = map(string)
#   description = "Metadata map for VMs"
#   default = {
#     serial-port-enable = "1"
#     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
#   }
# }

variable "yandex_compute_instance_groupvms" {
  type        = list(object({
    name = string
    cores = number
    memory = number
    core_fraction = number
    platform_id = string
  }))

  default = [{
      name = "lamp-group"
      cores         = 2
      memory        = 2
      core_fraction = 5
      platform_id = "standard-v1"
    }]
}

variable "boot_disk" {
  type        = list(object({
    size = number
    type = string
    image_id = string
    }))
    default = [ {
    size = 10
    type = "network-hdd"
    image_id = "fd827b91d99psvq5fjit"
  }]
}