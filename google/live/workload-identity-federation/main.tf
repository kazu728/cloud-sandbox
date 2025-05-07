terraform {
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

  default_labels = {
    "owner"      = "kazu728"
    "managed_by" = "terraform"
  }
}

module "workload-identity-federation" {
  source                    = "../../modules/workload-identity-federation"
  project_id                = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
}
