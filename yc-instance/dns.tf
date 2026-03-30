# dns.tf
resource "yandex_dns_recordset" "instance_dns" {
  for_each = var.create_dns_record ? var.dns_records : {}

  zone_id = data.yandex_dns_zone.zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  data    = [yandex_compute_instance.instance.network_interface[0].nat_ip_address]

  depends_on = [yandex_compute_instance.instance]
}