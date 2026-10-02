resource "google_project_service" "storage" {
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "nixos" {
  name                        = "${var.project_id}-nixos-images"
  location                    = "US-WEST1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  depends_on = [google_project_service.storage]
}

resource "google_storage_bucket_object" "nixos" {
  name   = "${var.nixos_image.name}.raw.tar.gz"
  bucket = google_storage_bucket.nixos.name
  source = var.nixos_image.source
}

resource "google_compute_image" "nixos" {
  name = var.nixos_image.name

  raw_disk {
    source = "https://storage.googleapis.com/${google_storage_bucket.nixos.name}/${google_storage_bucket_object.nixos.name}"
  }

  depends_on = [google_project_service.compute]
}
