locals {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "arm" {
  compartment_id   = local.compartment_id
  operating_system = "Canonical Ubuntu"
  shape            = "VM.Standard.A1.Flex"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"

  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-24\\.04-aarch64"]
    regex  = true
  }
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

resource "random_password" "console" {
  length  = 20
  special = false
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
    source_id               = data.oci_core_images.arm.images[0].id
    boot_volume_size_in_gbs = 50
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.this.id
  }

  metadata = {
    user_data = base64encode(<<-EOT
#cloud-config
chpasswd:
  expire: false
  users:
    - name: ubuntu
      password: ${random_password.console.bcrypt_hash}
EOT
    )
  }

  lifecycle {
    # A newer image would replace the boot volume through an in-place update.
    ignore_changes = [source_details[0].source_id]
  }
}
