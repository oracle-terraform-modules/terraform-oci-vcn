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
  # this module use the generic vcn module and configure it to act as vcn for RPC acceptor
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.2.0"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags
  defined_tags = var.defined_tags

  # vcn parameters
  create_drg               = false #! deprecated inner drg, use drg-module instead     
  create_internet_gateway  = false
  lockdown_default_seclist = false
  create_nat_gateway       = true
  create_service_gateway   = false
  vcn_cidrs                = var.vcn_cidrs_acceptor
  vcn_dns_label            = "vcnacceptor"
  vcn_name                 = "vcn-rpc-acceptor"

  nat_gateway_route_rules = [for cidr in var.vcn_cidrs_requestor :
    {
      destination       = cidr # set requestor vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.drg_acceptor.drg_id
      description       = "Terraformed - User added Routing Rule to requestor VCN through DRG"
    }
  ]

  providers = {
    oci = oci.acceptor
  }

}


resource "oci_core_subnet" "subnet_acceptor" {
  provider = oci.acceptor
  count    = length(var.vcn_cidrs_acceptor)

  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_acceptor.vcn_id
  #in this example each subnet will use the entire vcn address space
  cidr_block = var.vcn_cidrs_acceptor[count.index]

  #Optional
  display_name               = "sub-rpc-acceptor-${count.index}"
  dns_label                  = "subacceptor${count.index}"
  prohibit_public_ip_on_vnic = true
  route_table_id             = module.vcn_acceptor.nat_route_id
  freeform_tags              = var.freeform_tags
}


module "drg_acceptor" {
  source  = "oracle-terraform-modules/vcn/oci//modules/drg"
  version = "3.2.0"

  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_vcn_attachments = {
    "vcn_acceptor" = {
      vcn_id                    = module.vcn_acceptor.vcn_id
      vcn_transit_routing_rt_id = null
      drg_route_table_id        = null
    }
  }
  drg_display_name = "drg-rpc-acceptor"

  # rpc parameters
  create_rpc = true

  providers = {
    oci = oci.acceptor
  }
}


module "vcn_requestor" {
  # this module use the generic vcn module and configure it to act as rpc requestor vcn
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.2.0"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = false #! deprecated inner drg, use drg-module instead
  create_internet_gateway  = true
  lockdown_default_seclist = false
  create_nat_gateway       = false
  create_service_gateway   = false
  vcn_cidrs                = var.vcn_cidrs_requestor
  vcn_dns_label            = "vcnrequestor"
  vcn_name                 = "vcn-rpc-requestor"

  internet_gateway_route_rules = [for cidr in var.vcn_cidrs_acceptor :
    {
      destination       = cidr # set acceptor vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.drg_requestor.drg_id
      description       = "Terraformed - User added Routing Rule to acceptor VCN through DRG"
    }
  ]

  providers = {
    oci = oci.requestor
  }

}

resource "oci_core_subnet" "subnet_requestor" {
  provider = oci.requestor
  count    = length(var.vcn_cidrs_requestor)

  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn_requestor.vcn_id
  #in this example each subnet will use the entire vcn address space
  cidr_block = var.vcn_cidrs_requestor[count.index]

  #Optional
  display_name               = "sub-rpc-requestor-${count.index}"
  dns_label                  = "subrequestor${count.index}"
  prohibit_public_ip_on_vnic = false
  route_table_id             = module.vcn_requestor.ig_route_id
  freeform_tags              = var.freeform_tags
}

module "drg_requestor" {
  source  = "oracle-terraform-modules/vcn/oci//modules/drg"
  version = "3.2.0"

  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_vcn_attachments = { "vcn_requestor" = {
    vcn_id                    = module.vcn_requestor.vcn_id
    vcn_transit_routing_rt_id = null
    drg_route_table_id        = null
  } }
  drg_display_name = "drg-rpc-requestor"

  # rpc parameters
  create_rpc          = true
  rpc_acceptor_id     = module.drg_acceptor.rpc_id
  rpc_acceptor_region = var.region_acceptor

  providers = {
    oci = oci.requestor
  }
}
