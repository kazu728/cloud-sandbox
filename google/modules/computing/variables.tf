variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "instance_name" {
  description = "The name of the GCP instance"
  type        = string
}

variable "machine_type" {
  description = "The type of the GCP instance"
  type        = string
  default     = "e2-micro" # Free tier
}

variable "zone" {
  description = "The zone where the GCP instance will be created"
  type        = string
  default     = "us-west1-a" # Free tier
}