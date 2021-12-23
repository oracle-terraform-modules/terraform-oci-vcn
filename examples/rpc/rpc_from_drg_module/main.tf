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




module "vcn_local" {
  # this module use the generic vcn module and configure it to act as local vcn
  source  = "../../../"
  
  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = "local"
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = false #! deprecated inner drg, use drg-module instead     
  create_internet_gateway  = false           
  lockdown_default_seclist = false           
  create_nat_gateway       = true           
  create_service_gateway   = false           
  vcn_cidrs                = tolist([var.local_vcn_cidr])
  vcn_dns_label            = "vcnlocal"
  vcn_name                 = "vcnlocal"
  nat_gateway_route_rules = [ 
    {
      destination       = var.remote_vcn_cidr # set remote vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"     
      network_entity_id = module.drg_local.drg_id          
      description       = "Terraformed - User added Routing Rule to remote vcn through DRG"
    },
  ]
  providers = {
    oci = oci
  }
  
}

module "subnet_local" {
  source          = "github.com/oracle-terraform-modules/terraform-oci-tdf-subnet"
  
  default_compartment_id  = var.compartment_id
  vcn_id                  = module.vcn_local.vcn_id
  vcn_cidr                = var.local_vcn_cidr
  
  subnets = {
    local_rpc_subnet               = {
      compartment_id    = null
      defined_tags      = null
      freeform_tags     = null
      dynamic_cidr      = false
      cidr              = var.local_vcn_cidr
      cidr_len          = null
      cidr_num          = null
      enable_dns        = true
      dns_label         = "localrpcsubnet"
      private           = true
      ad                = null
      dhcp_options_id   = null
      route_table_id    = module.vcn_local.nat_route_id
      security_list_ids = null
    },
  }
}

module "drg_local" {
  source = "../../../modules/drg"
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_vcn_attachments = {"vcn_local" = {
    vcn_id = module.vcn_local.vcn_id
    vcn_transit_routing_rt_id = null
    drg_route_table_id = null
  }}
  drg_display_name = "drg_local"

  # rpc parameters
  create_rpc = true
}


module "vcn_remote" {
  # this module use the generic vcn module and configure it to act as remote vcn
  source  = "../../../"
  
  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = "remote"
  freeform_tags  = var.freeform_tags

  # vcn parameters
  create_drg               = false  #! deprecated inner drg, use drg-module instead
  create_internet_gateway  = true           
  lockdown_default_seclist = false           
  create_nat_gateway       = false           
  create_service_gateway   = false           
  vcn_cidrs                = tolist([var.remote_vcn_cidr]) # VCN CIDR
  vcn_dns_label            = "vcnremote"
  vcn_name                 = "vcnremote"
  internet_gateway_route_rules = [ 
    {
      destination       = var.local_vcn_cidr # set local vcn cidr as destination cidr 
      destination_type  = "CIDR_BLOCK"     
      network_entity_id = module.drg_remote.drg_id           
      description       = "Terraformed - User added Routing Rule to local vcn through DRG"
    },
  ]
  

  providers = {
    oci = oci.remote
  }
  
}

module "subnet_remote" {
  source          = "github.com/oracle-terraform-modules/terraform-oci-tdf-subnet"
  
  default_compartment_id  = var.compartment_id
  vcn_id                  = module.vcn_remote.vcn_id
  vcn_cidr                = var.remote_vcn_cidr
  
  subnets = {
    local_rpc_subnet               = {
      compartment_id    = null
      defined_tags      = null
      freeform_tags     = var.freeform_tags
      dynamic_cidr      = false
      cidr              = var.remote_vcn_cidr
      cidr_len          = null
      cidr_num          = null
      enable_dns        = true
      dns_label         = "remote"
      private           = false
      ad                = null
      dhcp_options_id   = null
      route_table_id    = module.vcn_remote.ig_route_id
      security_list_ids = null
    },
  }
  providers = {
    oci = oci.remote
  }
}

module "drg_remote" {
  source = "../../../modules/drg"
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_vcn_attachments = {"vcn_remote" = {
    vcn_id = module.vcn_remote.vcn_id
    vcn_transit_routing_rt_id = null
    drg_route_table_id = null
  }}
  drg_display_name = "drg_remote"

  # rpc parameters
  create_rpc = true
  remote_rpc_id = module.drg_local.rpc_id
  remote_rpc_region = var.region

  providers = {
    oci = oci.remote
  }
}
