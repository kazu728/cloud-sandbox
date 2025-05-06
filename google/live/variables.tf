variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "region" {
  description = "The name of the bucket to create."
  type        = string
  default     = "asia-northeast1"
}
