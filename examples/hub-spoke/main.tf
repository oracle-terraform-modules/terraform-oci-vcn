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

module "vcn_hub" {
  # this module use the generic vcn module and configure it to act as a hub in a hub-and-spoke topology 
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.4.0" # this is the first version supporting the LPG feature. Feel free to adjust for a newer version or remove the `version` line to get the latest version each time. 

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

  local_peering_gateways = {
    to_spoke1 = { # LPG will be in acceptor mode with a route table attached
      route_table_id = oci_core_route_table.VTR_spokes.id
    }
    to_spoke2 = { # LPG will be in requestor mode with no route table attached
      route_table_id = oci_core_route_table.VTR_spokes.id
      peer_id        = module.vcn_spoke2.lpg_all_attributes["to_hub"]["id"]
    }
    to_spoke3 = {} # LPG will be in acceptor mode with no route table attached
  }
}

resource "oci_core_route_table" "VTR_spokes" {
  # this is a route table created to demonstrate how to attach a route table an LPG for Transit Routing use cases.
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_hub.vcn_id

  display_name = "RT_VTR_spokes"
}

module "vcn_spoke1" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology 
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.4.0" # this is the first version supporting the LPG feature. Feel free to adjust for a newer version or remove the `version` line to get the latest version each time. 

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = false         # boolean: true or false
  internet_gateway_enabled = false         # boolean: true or false
  lockdown_default_seclist = true          # boolean: true or false
  nat_gateway_enabled      = false         # boolean: true or false
  service_gateway_enabled  = false         # boolean: true or false
  vcn_cidr                 = "10.0.1.0/24" # VCN CIDR
  vcn_dns_label            = "fraspoke1"
  vcn_name                 = "spoke1"

  # gateways parameters

  local_peering_gateways = {
    to_hub = {
      peer_id = module.vcn_hub.lpg_all_attributes["to_spoke1"]["id"] # LPG will be in requestor mode with no route table attached
    }
  }
}

module "vcn_spoke2" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology 
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.4.0" # this is the first version supporting the LPG feature. Feel free to adjust for a newer version or remove the `version` line to get the latest version each time. 

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = false         # boolean: true or false
  internet_gateway_enabled = false         # boolean: true or false
  lockdown_default_seclist = true          # boolean: true or false
  nat_gateway_enabled      = false         # boolean: true or false
  service_gateway_enabled  = false         # boolean: true or false
  vcn_cidr                 = "10.0.2.0/24" # VCN CIDR
  vcn_dns_label            = "fraspoke2"
  vcn_name                 = "spoke2"

  # gateways parameters

  local_peering_gateways = {
    to_hub = {} # LPG will be in acceptor mode with no route table attached
  }
}

module "vcn_spoke3" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology 
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.4.0" # this is the first version supporting the LPG feature. Feel free to adjust for a newer version or remove the `version` line to get the latest version each time. 

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  tags           = var.tags

  # vcn parameters
  create_drg               = false         # boolean: true or false
  internet_gateway_enabled = false         # boolean: true or false
  lockdown_default_seclist = true          # boolean: true or false
  nat_gateway_enabled      = false         # boolean: true or false
  service_gateway_enabled  = false         # boolean: true or false
  vcn_cidr                 = "10.0.3.0/24" # VCN CIDR
  vcn_dns_label            = "fraspoke3"
  vcn_name                 = "spoke3"

  # gateways parameters

  local_peering_gateways = {
    to_hub = {} # LPG will be in acceptor mode with no route table attached
  }
}