# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Version requirements

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">=4.41.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Resources

module "drg_hub" {
  source = "../../modules/drg/"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_display_name            = var.drg_display_name
  drg_attachment_resource_ids = { for k, v in module.vcn_spokes : k => v.vcn_id }
}

module "vcn_spokes" {
  source = "../.."
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "3.1.0"
  for_each = var.vcn_spokes

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # vcn parameters
  create_internet_gateway  = each.value["create_internet_gateway"]  # boolean: true or false
  lockdown_default_seclist = each.value["lockdown_default_seclist"] # boolean: true or false
  create_nat_gateway       = each.value["create_nat_gateway"]       # boolean: true or false
  create_service_gateway   = each.value["create_service_gateway"]   # boolean: true or false
  enable_ipv6              = each.value["enable_ipv6"]              # boolean: true or false
  vcn_cidrs                = each.value["cidrs"]                    # List of IPv4 CIDRs
  vcn_dns_label            = each.value["dns_label"]                # string
  vcn_name                 = each.key                               # string
}

# resource "oci_core_remote_peering_connection" "test_rpc" {
# * boilerplate to start RPC support development
#     #Required
#     compartment_id = var.compartment_id
#     drg_id = module.drg_hub.drg_id

#     #Optional
#     # defined_tags = {"Operations.CostCenter"= "42"}
#     display_name = "test_rpc"
#     # freeform_tags = {"Department"= "Finance"}
#     # peer_id = oci_core_remote_peering_connection.test_remote_peering_connection2.id
#     # peer_region_name = var.remote_peering_connection_peer_region_name
# }

# module "vcn_spoke3_with_drg" {
# ! Module Examples should not show deprecated code. Temporarly kept to test backward compatibility during development
# ! To be removed before PR.
#   source = "../.."
#   # source  = "oracle-terraform-modules/vcn/oci"
#   # version = "3.1.0"

#   # general oci parameters
#   compartment_id = var.compartment_id
#   label_prefix   = var.label_prefix

#   # vcn parameters
#   create_drg               = true           # boolean: true or false
#   create_internet_gateway  = true            # boolean: true or false
#   lockdown_default_seclist = true            # boolean: true or false
#   create_nat_gateway       = true            # boolean: true or false
#   create_service_gateway   = true            # boolean: true or false
#   enable_ipv6              = true            # boolean: true or false
#   vcn_cidrs                = ["10.0.4.0/24"] # List of IPv4 CIDRs
#   vcn_dns_label            = "spoke3"        # string
#   vcn_name                 = "spoke3"        # string
# }