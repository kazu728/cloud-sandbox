terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.0"
}

variable "project_id" {
  type        = string
  description = "The project ID to use for the resources"

}

module "computing" {
  source        = "../../computing"
  project_id    = var.project_id
  instance_name = "example-instance"
}
