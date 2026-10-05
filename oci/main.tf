locals {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "this" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_vcn" "this" {
  compartment_id = local.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "homelab-vcn"
  dns_label      = "homelab"
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "homelab-igw"
}

resource "oci_core_route_table" "this" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "homelab-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_security_list" "this" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "homelab-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    description = "Path MTU discovery"
    source      = "0.0.0.0/0"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    description = "All traffic inside the VCN"
    source      = "10.0.0.0/16"
    protocol    = "all"
  }
}

resource "oci_core_subnet" "this" {
  compartment_id    = local.compartment_id
  vcn_id            = oci_core_vcn.this.id
  cidr_block        = "10.0.0.0/24"
  display_name      = "homelab-subnet"
  dns_label         = "subnet"
  route_table_id    = oci_core_route_table.this.id
  security_list_ids = [oci_core_security_list.this.id]
}

resource "oci_core_instance" "this" {
  compartment_id      = local.compartment_id
  availability_domain = coalesce(var.availability_domain, data.oci_identity_availability_domains.this.availability_domains[0].name)
  display_name        = "homelab"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  source_details {
    source_type             = "image"
    source_id               = var.nixos_image_id
    boot_volume_size_in_gbs = 50
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.this.id
  }

  lifecycle {
    # Cross-distribution boot volume replacement is unsupported by OCI.
    replace_triggered_by = [terraform_data.nixos_image]
  }
}

resource "terraform_data" "nixos_image" {
  input = var.nixos_image_id
}
