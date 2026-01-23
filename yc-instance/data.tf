# data.tf
data "yandex_dns_zone" "zone" {
  folder_id = var.folder_id
  name      = var.dns_zone_name
}

data "yandex_compute_image" "image" {
  family = var.os_name
}