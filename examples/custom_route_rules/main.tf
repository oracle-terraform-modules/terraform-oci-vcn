# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Version requirements

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
  source = "../../"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = var.create_drg               # boolean: true or false
  internet_gateway_enabled = var.internet_gateway_enabled # boolean: true or false
  lockdown_default_seclist = var.lockdown_default_seclist # boolean: true or false
  nat_gateway_enabled      = var.nat_gateway_enabled      # boolean: true or false
  service_gateway_enabled  = var.service_gateway_enabled  # boolean: true or false
  vcn_cidr                 = var.vcn_cidr                 # VCN CIDR
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  # gateways parameters
  drg_display_name = var.drg_display_name

  # routing rules

  internet_gateway_route_rules = var.internet_gateway_route_rules # this module input shows how to pass routing information to the vcn module through  Variable Input. Can be initialized in a *.tfvars or *.auto.tfvars file
  nat_gateway_route_rules      = local.nat_gateway_route_rules    # this module input shows how to pass routing information to the vcn module through Local Values.
}

resource "oci_core_local_peering_gateway" "lpg" {
  # this is a Local Peering Gateway created to demonstrate how to use a gateway generated outside of the module as a target for a routing rule
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "terraform-oci-lpg"
}

# Outputs

output "module_vcn" {
  description = "vcn and gateways information"
  value = {
    drg_id              = module.vcn.drg_id
    internet_gateway_id = module.vcn.internet_gateway_id
    nat_gateway_id      = module.vcn.nat_gateway_id
    service_gateway_id  = module.vcn.service_gateway_id
    vcn_id              = module.vcn.vcn_id
  }
}

output "local_peering_gateway" {
  description = "local peering gateways information"
  value       = oci_core_local_peering_gateway.lpg.id
}
