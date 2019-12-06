resource "google_compute_health_check" "hana-ilb-62503-health-check" {
  name = "${var.name}-hana-ilb-62503-health-check"

  tcp_health_check {
    port = "62503"
  }
}

resource "google_compute_instance_group" "hana-1plus1-ig1" {
  name = "${var.name}-hana-1plus1-ig1"

  instances = [
    var.instance1_self_link
  ]

  zone = var.zone
}

resource "google_compute_instance_group" "hana-1plus1-ig2" {
  name = "${var.name}-hana-1plus1-ig2"

  instances = [
    var.instance2_self_link
  ]

  zone = var.zone
}

resource "google_compute_region_backend_service" "hana-ilb-backend-service" {
  name          = "${var.name}-hana-ilb-backend-service"
  health_checks = [google_compute_health_check.hana-ilb-62503-health-check.self_link]
  region        = var.region

  backend {
    group = google_compute_instance_group.hana-1plus1-ig1.self_link
  }

  backend {
    group = google_compute_instance_group.hana-1plus1-ig2.self_link
  }
}

resource "google_compute_forwarding_rule" "hana-ilb-forwarding-rule" {
  name                  = "${var.name}-hana-ilb-forwarding-rule"
  load_balancing_scheme = "INTERNAL"
  ports                 = ["22", "1128", "1129", "30215"]
  network               = var.db_vpc_name
  subnetwork            = var.db_subnet_name
  backend_service       = google_compute_region_backend_service.hana-ilb-backend-service.self_link
}
