variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "workload_identity_pool_id" {
  description = "The ID of the workload identity pool"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "asia-northeast1"
}
