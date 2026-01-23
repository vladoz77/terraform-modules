# disk.tf
resource "yandex_compute_disk" "additional_disks" {
  count = length(var.additional_disks)

  name = lower("${var.name}-disk-${count.index}") 
  type = var.additional_disks[count.index].type
  size = var.additional_disks[count.index].size
  zone = var.zone
}