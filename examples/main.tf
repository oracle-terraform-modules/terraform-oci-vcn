# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Versions

terraform {
  required_version = ">= 0.13"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.0.0"
    }
  }
}

# Resources

module "vcn" {
  source = "../"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = var.create_drg
  internet_gateway_enabled = var.internet_gateway_enabled
  lockdown_default_seclist = var.lockdown_default_seclist
  nat_gateway_enabled      = var.nat_gateway_enabled
  service_gateway_enabled  = var.service_gateway_enabled
  vcn_cidr                 = var.vcn_cidr
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  # gateways parameters
  drg_display_name = var.drg_display_name
}

# Outputs

output "module_vcn" {
  description = "vcn and gateways information"
  value = {
    vcn_id = module.vcn.vcn_id
  }
}
