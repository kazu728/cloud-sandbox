data "oci_objectstorage_namespace" "this" {}

data "oci_core_compute_global_image_capability_schemas" "this" {}

resource "oci_objectstorage_bucket" "nixos" {
  compartment_id = local.compartment_id
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "nixos-images"
}

resource "oci_objectstorage_object" "nixos" {
  namespace = oci_objectstorage_bucket.nixos.namespace
  bucket    = oci_objectstorage_bucket.nixos.name
  object    = "${var.nixos_image.name}.qcow2"
  source    = var.nixos_image.source
}

resource "oci_core_image" "nixos" {
  compartment_id = local.compartment_id
  display_name   = var.nixos_image.name
  launch_mode    = "PARAVIRTUALIZED"

  image_source_details {
    source_type              = "objectStorageTuple"
    namespace_name           = oci_objectstorage_object.nixos.namespace
    bucket_name              = oci_objectstorage_object.nixos.bucket
    object_name              = oci_objectstorage_object.nixos.object
    source_image_type        = "QCOW2"
    operating_system         = "NixOS"
    operating_system_version = "26.05"
  }
}

resource "oci_core_compute_image_capability_schema" "nixos" {
  compartment_id                                      = local.compartment_id
  image_id                                            = oci_core_image.nixos.id
  compute_global_image_capability_schema_version_name = data.oci_core_compute_global_image_capability_schemas.this.compute_global_image_capability_schemas[0].current_version_name

  schema_data = {
    "Compute.Firmware" = jsonencode({
      descriptorType = "enumstring"
      source         = "IMAGE"
      values         = ["UEFI_64"]
      defaultValue   = "UEFI_64"
    })
  }
}

resource "oci_core_shape_management" "nixos" {
  compartment_id = local.compartment_id
  image_id       = oci_core_image.nixos.id
  shape_name     = "VM.Standard.A1.Flex"

  depends_on = [oci_core_compute_image_capability_schema.nixos]
}
