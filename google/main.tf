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
  name          = "sandbox"
  region        = "us-west1"
  network       = google_compute_network.sandbox.id
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_instance" "sandbox" {
  name         = "sandbox"
  machine_type = "e2-micro"
  zone         = "us-west1-a"
  tags         = var.migration_ssh_cidr == null ? [] : ["migration-ssh"]

  metadata = {
    enable-oslogin     = "TRUE"
    serial-port-enable = "TRUE"
  }

  boot_disk {
    initialize_params {
      image = google_compute_image.nixos.self_link
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.sandbox.id

    access_config {}
  }
}

resource "google_compute_firewall" "migration_ssh" {
  count = var.migration_ssh_cidr == null ? 0 : 1

  name          = "migration-ssh"
  network       = google_compute_network.sandbox.id
  source_ranges = [var.migration_ssh_cidr]
  target_tags   = ["migration-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
