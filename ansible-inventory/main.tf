resource "local_file" "inventory" {
  filename = "${var.ansible_path}/${var.environment}/inventory.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    groups = var.groups
  })
}
