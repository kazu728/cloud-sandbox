variable "project_id" {
  type        = string
  description = "ID of the Google Cloud project created by bootstrap/google."
}

variable "nixos_image" {
  type        = string
  description = "NixOS image name. Register the image before creating a VM, then delete it after the VM boots."
}
