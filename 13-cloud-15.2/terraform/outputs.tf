output "pic-url" {
  value = "https://${yandex_storage_bucket.vp-bucket.bucket_domain_name}/${yandex_storage_object.thumbupcat.key}"
  description = "Bucket picture address"
}

output "nlb-address" {
  value = yandex_lb_network_load_balancer.lb-1.listener.*.external_address_spec[0].*.address
  description = "Network LB address"
}