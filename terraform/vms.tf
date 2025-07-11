resource "yandex_iam_service_account" "groupvm-sa" {
  name        = "groupvm-sa"
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "group-editor" {
  folder_id  = var.folder_id
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.groupvm-sa.id}"
  depends_on = [
    yandex_iam_service_account.groupvm-sa,
  ]
}

resource "yandex_compute_instance_group" "group-vms" {
  name                = var.yandex_compute_instance_groupvms[0].name
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.groupvm-sa.id}"
  deletion_protection = "false"
  depends_on          = [yandex_resourcemanager_folder_iam_member.group-editor]
  instance_template {
    platform_id = var.yandex_compute_instance_groupvms[0].platform_id
    resources {
      memory = var.yandex_compute_instance_groupvms[0].memory
      cores  = var.yandex_compute_instance_groupvms[0].cores
      core_fraction = var.yandex_compute_instance_groupvms[0].core_fraction
    }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk[0].image_id
      type     = var.boot_disk[0].type
      size     = var.boot_disk[0].size
    }
  }

    network_interface {
      network_id         = "${yandex_vpc_network.HW_Netology.id}"
      subnet_ids         = ["${yandex_vpc_subnet.public.id}"]
      nat = true
    }

  scheduling_policy {
    preemptible = true
  }

    metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
    user-data  = <<EOF
#!/bin/bash
cd /var/www/html
echo '<html><head><title>Picture</title></head> <body><h1>Look</h1><img src="http://${yandex_storage_bucket.markinai.bucket_domain_name}/image.jpg"/></body></html>' > index.html
EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }

    load_balancer {
        target_group_name = "lamp-group"
    }
}