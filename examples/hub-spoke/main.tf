# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/


# Resources

module "vcn_hub" {
  # this module use the generic vcn module and configure it to act as a hub in a hub-and-spoke topology

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

  # routing rules
  internet_gateway_route_rules = var.internet_gateway_route_rules # this module input shows how to pass routing information to the vcn module through  Variable Input. Can be initialized in a *.tfvars or *.auto.tfvars file
}

resource "oci_core_route_table" "VTR_spokes" {
  # this is a route table created to demonstrate how to attach a route table an LPG for Transit Routing use cases.
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_hub.vcn_id

  display_name = "RT_VTR_spokes"
}

module "vcn_spoke1" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology
  
  source = "github.com/oracle-terraform-modules/terraform-oci-vcn"
  # to use the terraform registry version comment the previous line and uncomment the 2 lines below
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "specify_version_number"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_internet_gateway  = false           # boolean: true or false
  lockdown_default_seclist = true            # boolean: true or false
  create_nat_gateway       = false           # boolean: true or false
  create_service_gateway   = false           # boolean: true or false
  vcn_cidrs                = ["10.0.1.0/24"] # VCN CIDR
  vcn_dns_label            = "fraspoke1"
  vcn_name                 = "spoke1"

  # gateways parameters
  attached_drg_id = var.attached_drg_id

  local_peering_gateways = {
    to_hub = {
      peer_id = module.vcn_hub.lpg_all_attributes["to_spoke1"]["id"] # LPG will be in requestor mode with no route table attached
    }
  }
}

module "vcn_spoke2" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology
  
  source = "github.com/oracle-terraform-modules/terraform-oci-vcn"
  # to use the terraform registry version comment the previous line and uncomment the 2 lines below
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "specify_version_number"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_internet_gateway  = false           # boolean: true or false
  lockdown_default_seclist = true            # boolean: true or false
  create_nat_gateway       = false           # boolean: true or false
  create_service_gateway   = false           # boolean: true or false
  vcn_cidrs                = ["10.0.2.0/24"] # VCN CIDR
  vcn_dns_label            = "fraspoke2"
  vcn_name                 = "spoke2"

  # gateways parameters
  attached_drg_id = var.attached_drg_id

  local_peering_gateways = {
    to_hub = {} # LPG will be in acceptor mode with no route table attached
  }
}

module "vcn_spoke3" {
  # this module use the generic vcn module and configure it to act as a spoke in a hub-and-spoke topology
  
  source = "github.com/oracle-terraform-modules/terraform-oci-vcn"
  # to use the terraform registry version comment the previous line and uncomment the 2 lines below
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "specify_version_number"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_internet_gateway  = false           # boolean: true or false
  lockdown_default_seclist = true            # boolean: true or false
  create_nat_gateway       = false           # boolean: true or false
  create_service_gateway   = false           # boolean: true or false
  vcn_cidrs                = ["10.0.3.0/24"] # VCN CIDR
  vcn_dns_label            = "fraspoke3"
  vcn_name                 = "spoke3"

  # gateways parameters
  attached_drg_id = var.attached_drg_id
  local_peering_gateways = {
    to_hub = {} # LPG will be in acceptor mode with no route table attached
  }
}