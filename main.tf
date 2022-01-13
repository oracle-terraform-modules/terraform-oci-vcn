# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl


#! Calling module/drg from vcn module for backward compatibility with feature related to `var.create_drg`
#! deprecation notice: this internal module call will be removed at next major release

module "drg_from_vcn_module" {
  source = "./modules/drg/"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_display_name = var.label_prefix == "none" ? "${var.drg_display_name}_created_from_${var.vcn_name}" : "${var.drg_display_name}"

  #rpc parameters    
  create_rpc          = var.create_rpc
  rpc_acceptor_id     = var.drg_rpc_acceptor_id
  rpc_acceptor_region = var.drg_rpc_acceptor_region


  count = var.create_drg == true || var.create_rpc == true ? 1 : 0
}



