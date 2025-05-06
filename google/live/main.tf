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

module "tfstate" {
  source = "../modules/storage"

  project_id = var.project_id
  region     = var.region
}
