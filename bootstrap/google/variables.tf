variable "billing_account" {
  type        = string
  description = "Billing account ID linked to the project."
}

variable "org_id" {
  type        = string
  description = "Organization ID to create the project under. Leave null to create a project without an organization."
  default     = null
}

variable "project_id" {
  type        = string
  description = "ID of the Google Cloud project to create. Also used as its display name."
}
