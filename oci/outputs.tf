output "instance_id" {
  description = "OCID of the instance."
  value       = oci_core_instance.this.id
}
