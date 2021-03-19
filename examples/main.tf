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
  source = "../"

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
}

# Outputs

output "module_vcn_ids" {
  description = "vcn and gateways information"
  value = {
    drg_id                       = module.vcn.drg_id
    internet_gateway_id          = module.vcn.internet_gateway_id
    internet_gateway_route_id    = module.vcn.ig_route_id
    nat_gateway_id               = module.vcn.nat_gateway_id
    nat_gateway_route_id         = module.vcn.nat_route_id
    service_gateway_id           = module.vcn.service_gateway_id
    vcn_dns_label                = module.vcn.vcn_all_attributes.dns_label
    vcn_default_security_list_id = module.vcn.vcn_all_attributes.default_security_list_id
    vcn_default_route_table_id   = module.vcn.vcn_all_attributes.default_route_table_id
    vcn_default_dhcp_options_id  = module.vcn.vcn_all_attributes.default_dhcp_options_id
    vcn_id                       = module.vcn.vcn_id  
  }
}

# output "module_vcn_all_attributes" {
#   description = "all attributes for each resources created by this example"
#   value = {
#     drg              = module.vcn.drg_all_attributes
#     drg_attachment   = module.vcn.drg_attachment_all_attributes
#     internet_gateway = module.vcn.internet_gateway_all_attributes
#     ig_route_table   = module.vcn.ig_route_all_attributes
#     nat_gateway      = module.vcn.nat_gateway_all_attributes
#     nat_route_table  = module.vcn.nat_route_all_attributes
#     service_gateway  = module.vcn.service_gateway_all_attributes
#     vcn              = module.vcn.vcn_all_attributes
#   }
# }
