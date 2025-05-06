resource "google_storage_bucket" "tfstate" {
  project                     = var.project_id
  name                        = "${var.project_id}-tfstate"
  location                    = var.region
  uniform_bucket_level_access = true

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
