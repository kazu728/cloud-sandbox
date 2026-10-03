variable "availability_domain" {
  type        = string
  description = "Availability domain name for the instance. Defaults to the first AD; change it when Arm capacity is unavailable."
  default     = null
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy. Its root compartment holds every resource."
}

variable "nixos_image_id" {
  type        = string
  description = "OCID of the NixOS image registered for VM creation. Delete the image after the VM boots."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key supplied to the NixOS root user through OCI instance metadata."
}
