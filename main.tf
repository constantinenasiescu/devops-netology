terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "${var.zone}"
}

resource "yandex_compute_instance" "vm-1" {
  name       = "vm-1"
  zone       = "${var.zone}"
  hostname   = "vm-1.netology.cloud"

  resources {
    cores    = 2
    memory   = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-image}"
      name        = "root-node01"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}