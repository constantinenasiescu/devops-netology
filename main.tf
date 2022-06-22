terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-object-storage"
    region     = "ru-central1-a"
    key        = ".terraform/terraform.tfstate"
    access_key = ""
    secret_key = ""
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone
}

data "yandex_compute_image" "ubuntu-2004" {
    family = "ubuntu-2004-lts"
}

data "yandex_compute_image" "ubuntu-1804" {
    family = "ubuntu-2004-lts"
}

locals {
    image_id_map = {
        stage = data.yandex_compute_image.ubuntu-1804.id
        prod = data.yandex_compute_image.ubuntu-2004.id
    }
    instance_count_map = {
        stage = 1
        prod = 2
    }
}

resource "yandex_compute_instance" "vm-1" {
  name       = "vm-1"
  zone       = var.zone
  hostname   = "vm-1.netology.cloud"
  count      = local.instance_count_map[terraform.workspace]

  resources {
    cores    = 2
    memory   = 2
  }

  boot_disk {
    initialize_params {
      image_id    = local.image_id_map[terraform.workspace]
      name        = "root-node01"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

locals {
    instances = {
        1 = data.yandex_compute_image.ubuntu-1804.id
        2 = data.yandex_compute_image.ubuntu-2004.id
    }
}

resource "yandex_compute_instance" "vm-2" {
  for_each = local.instances

  name       = "vm-2"
  zone       = var.zone
  hostname   = "vm-2.netology.cloud"

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = each.value
      name        = "root-node${each.key}"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}