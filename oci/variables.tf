variable "availability_domain" {
  type        = string
  description = "Availability domain name for the instance. Defaults to the first AD; change it when Arm capacity is unavailable."
  default     = null
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy. Its root compartment holds every resource."
}

variable "nixos_image" {
  type = object({
    name   = string
    source = string
  })
  description = "Immutable image name and local path to the built OCI qcow2 artifact."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key supplied to the NixOS root user through OCI instance metadata."
}

variable "migration_ssh_cidr" {
  type        = string
  description = "Temporary IPv4 /32 allowed to SSH during the NixOS migration. Null disables the rule."
  default     = null

  validation {
    condition = var.migration_ssh_cidr == null ? true : (
      can(cidrnetmask(var.migration_ssh_cidr)) && can(regex("/32$", var.migration_ssh_cidr))
    )
    error_message = "migration_ssh_cidr must be a single IPv4 address with a /32 prefix."
  }
}
