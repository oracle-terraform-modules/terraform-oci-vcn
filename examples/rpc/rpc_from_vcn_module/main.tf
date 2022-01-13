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

module "vcn_acceptor" {
  # this module use the generic vcn module and configure it to act as rpc acceptor vcn
  source = "oracle-terraform-modules/vcn/oci"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = true
  create_rpc               = true
  create_internet_gateway  = false
  lockdown_default_seclist = false
  create_nat_gateway       = true
  create_service_gateway   = false
  vcn_cidrs                = tolist([var.vcn_cidr_acceptor])
  vcn_dns_label            = "vcnacceptor"
  vcn_name                 = "vcn-rpc-acceptor"
  nat_gateway_route_rules = [
    {
      destination       = var.vcn_cidr_requestor # set rpc requestor vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "drg"
      description       = "Terraformed - User added Routing Rule to RPC requestor vcn through DRG"
    },
  ]

  providers = {
    oci = oci.acceptor
  }

}

resource "oci_core_subnet" "subnet_acceptor" {
  provider = oci.acceptor
  #Required
  cidr_block     = var.vcn_cidr_acceptor
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_acceptor.vcn_id

  #Optional
  display_name               = "sub-rpc-acceptor"
  dns_label                  = "subacceptor"
  prohibit_public_ip_on_vnic = true
  route_table_id             = module.vcn_acceptor.nat_route_id
  freeform_tags              = var.freeform_tags
}


module "vcn_requestor" {
  # this module use the generic vcn module and configure it to act as rpc requestor vcn
  source = "oracle-terraform-modules/vcn/oci"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = true
  create_rpc               = true
  create_internet_gateway  = true
  lockdown_default_seclist = false
  create_nat_gateway       = false
  create_service_gateway   = false
  vcn_cidrs                = tolist([var.vcn_cidr_requestor]) # VCN CIDR
  vcn_dns_label            = "vcnrequestor"
  vcn_name                 = "vcn-rpc-requestor"
  internet_gateway_route_rules = [
    {
      destination       = var.vcn_cidr_acceptor # set rpc acceptor vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "drg"
      description       = "Terraformed - User added Routing Rule to rpc acceptor vcn through DRG"
    },
  ]
  drg_rpc_acceptor_id     = module.vcn_acceptor.rpc_id
  drg_rpc_acceptor_region = var.region_acceptor

  providers = {
    oci = oci.requestor
  }

}

resource "oci_core_subnet" "subnet_requestor" {
  provider = oci.requestor
  #Required
  cidr_block     = var.vcn_cidr_requestor
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_requestor.vcn_id

  #Optional
  display_name               = "sub-rpc-requestor"
  dns_label                  = "subrequestor"
  prohibit_public_ip_on_vnic = false
  route_table_id             = module.vcn_requestor.ig_route_id
  freeform_tags              = var.freeform_tags
}
