output "internal_load_balancer_ip" {
  value = google_compute_forwarding_rule.hana-ilb-forwarding-rule.ip_address
}
