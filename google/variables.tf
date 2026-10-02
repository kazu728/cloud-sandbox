variable "project_id" {
  type        = string
  description = "ID of the Google Cloud project created by bootstrap/google."
}

variable "nixos_image" {
  type = object({
    name   = string
    source = string
  })
  description = "Immutable image name and local path to the built GCE raw.tar.gz artifact."
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
