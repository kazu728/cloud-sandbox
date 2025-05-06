variable "org_id" {
  description = "The ID of the GCP organization"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "creation_project_name" {
  description = "The name of the GCP project"
  type        = string

}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "The zone where resources will be created"
  type        = string
  default     = "asia-northeast1-a"
}

variable "billing_account" {
  description = "The billing account ID for the GCP project"
  type        = string
}
