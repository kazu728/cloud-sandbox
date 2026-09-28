terraform {
  required_version = ">= 1.16.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
  }
}
