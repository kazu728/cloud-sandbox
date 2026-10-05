resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "sandbox" {
  name                    = "sandbox"
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "sandbox" {
  name             = "sandbox"
  region           = "us-west1"
  network          = google_compute_network.sandbox.id
  ip_cidr_range    = "10.0.0.0/24"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}

resource "google_compute_instance" "sandbox" {
  name         = "sandbox"
  machine_type = "e2-micro"
  zone         = "us-west1-a"

  metadata = {
    serial-port-enable = "TRUE"
  }

  boot_disk {
    initialize_params {
      image = "projects/${var.project_id}/global/images/${var.nixos_image}"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.sandbox.id
    stack_type = "IPV4_IPV6"

    ipv6_access_config {
      network_tier = "PREMIUM"
    }
  }
}
