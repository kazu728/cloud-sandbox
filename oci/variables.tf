variable "availability_domain" {
  type        = string
  description = "Availability domain name for the instance. Defaults to the first AD; change it when Arm capacity is unavailable."
  default     = null
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy. Its root compartment holds every resource."
}
