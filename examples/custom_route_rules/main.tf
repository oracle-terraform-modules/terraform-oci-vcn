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

  internet_gateway_route_rules = local.internet_gateway_route_rules # this module input shows how to pass routing information to the vcn module through Local Values.
  nat_gateway_route_rules = [                                       # this module input shows how to pass routing information to the vcn module inline, directly on the vcn module block
    {
      destination       = "192.168.0.0/16" # Route Rule Destination CIDR
      destination_type  = "CIDR_BLOCK"     # only CIDR_BLOCK is supported at the moment
      network_entity_id = "drg"            # for nat_gateway_route_rules input variable, you can use special strings "drg", "nat_gateway" or pass a valid OCID using string or any Named Values
      description       = "Terraformed - User added Routing Rule: To drg created by this module. drg_id is automatically retrieved with keyword drg"
    },
    {
      destination       = "172.16.0.0/16"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.vcn.drg_id
      description       = "Terraformed - User added Routing Rule: To drg with drg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
    {
      destination       = "203.0.113.0/24" # rfc5737 (TEST-NET-3)
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "nat_gateway"
      description       = "Terraformed - User added Routing Rule: To NAT Gateway created by this module. nat_gateway_id is automatically retrieved with keyword nat_gateway"
    },
    {
      destination       = "192.168.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_local_peering_gateway.lpg.id
      description       = "Terraformed - User added Routing Rule: To lpg with lpg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
  ]
}

resource "oci_core_local_peering_gateway" "lpg" {
  # this is a Local Peering Gateway created to demonstrate how to use a gateway generated outside of the module as a target for a routing rule
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "terraform-oci-lpg"
}

# Locals

locals {
  internet_gateway_route_rules = [ # this is a local that can be used to pass routing information to vcn module for either route tables
    {
      destination       = "192.168.0.0/16" # Route Rule Destination CIDR
      destination_type  = "CIDR_BLOCK"     # only CIDR_BLOCK is supported at the moment
      network_entity_id = "drg"            # for internet_gateway_route_rules input variable, you can use special strings "drg", "internet_gateway" or pass a valid OCID using string or any Named Values
      description       = "Terraformed - User added Routing Rule: To drg created by this module. drg_id is automatically retrieved with keyword drg"
    },
    {
      destination       = "172.16.0.0/16"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.vcn.drg_id
      description       = "Terraformed - User added Routing Rule: To drg with drg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
    {
      destination       = "203.0.113.0/24" # rfc5737 (TEST-NET-3)
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "internet_gateway"
      description       = "Terraformed - User added Routing Rule: To Internet Gateway created by this module. internet_gateway_id is automatically retrieved with keyword internet_gateway"
    },
    {
      destination       = "192.168.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_local_peering_gateway.lpg.id
      description       = "Terraformed - User added Routing Rule: To lpg with lpg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
  ]
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
