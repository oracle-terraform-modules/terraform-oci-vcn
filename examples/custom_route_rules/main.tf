# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Version requirements

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=4.67.3"
    }
  }
  required_version = ">= 1.0.0"
}

# Resources

module "vcn" {
  
  source = "github.com/oracle-terraform-modules/terraform-oci-vcn"
  # to use the terraform registry version comment the previous line and uncomment the 2 lines below
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "specify_version_number"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags
  defined_tags = var.defined_tags

  # vcn parameters
  create_internet_gateway  = var.create_internet_gateway  # boolean: true or false
  lockdown_default_seclist = var.lockdown_default_seclist # boolean: true or false
  create_nat_gateway       = var.create_nat_gateway       # boolean: true or false
  create_service_gateway   = var.create_service_gateway   # boolean: true or false
  enable_ipv6              = var.enable_ipv6
  vcn_cidrs                = var.vcn_cidrs # List of IPv4 CIDRs
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  # gateways parameters
  internet_gateway_display_name = var.internet_gateway_display_name
  nat_gateway_display_name      = var.nat_gateway_display_name
  service_gateway_display_name  = var.service_gateway_display_name
  attached_drg_id               = var.attached_drg_id

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
