resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# A dedicated VPC without firewall rules keeps ingress denied by default.
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

  boot_disk {
    initialize_params {
      # Keep the family reference so image releases don't replace the VM.
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.sandbox.id

    access_config {}
  }
}
