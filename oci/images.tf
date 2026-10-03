data "oci_objectstorage_namespace" "this" {}

resource "oci_objectstorage_bucket" "nixos" {
  compartment_id = local.compartment_id
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "nixos-images"
}
