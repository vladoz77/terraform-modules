# main.tf
resource "local_file" "inventory" {
  filename = var.inventory_path

  content = templatefile("${path.module}/inventory.tftpl", {
    groups = var.groups
  })
}
