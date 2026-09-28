output "console_password" {
  description = "Password that cloud-init sets for the ubuntu user, for serial console login."
  value       = random_password.console.result
  sensitive   = true
}

output "instance_id" {
  description = "OCID of the instance."
  value       = oci_core_instance.this.id
}
