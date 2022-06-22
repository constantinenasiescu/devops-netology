output "internal_ip_address_vm1_yandex_cloud" {
  value = [for item in yandex_compute_instance.vm-1 : item.network_interface.0.ip_address]
}

output "external_ip_address_vm1_yandex_cloud" {
  value = [for item in yandex_compute_instance.vm-1 : item.network_interface.0.nat_ip_address]
}

output "internal_ip_address_vm2_yandex_cloud" {
  value = [for item in yandex_compute_instance.vm-2 : item.network_interface.0.ip_address]
}

output "external_ip_address_vm2_yandex_cloud" {
  value = [for item in yandex_compute_instance.vm-2 : item.network_interface.0.nat_ip_address]
}