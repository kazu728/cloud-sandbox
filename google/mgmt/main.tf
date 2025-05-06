terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = {
    "owner"      = "kazu728"
    "managed_by" = "terraform"
  }
}

resource "google_project" "cloud-sandbox" {
  org_id          = var.org_id
  project_id      = var.creation_project_name
  name            = var.creation_project_name
  billing_account = var.billing_account

  deletion_policy = "DELETE"
}

module "tfstate" {
  source = "../modules/storage"

  project_id = var.project_id
  region     = var.region
}
