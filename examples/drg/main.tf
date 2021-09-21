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

module "drg_main" {
  source = "../../modules/drg/"

  # general parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags
}

output "module_drg_main_ids" {
  description = "vcn and gateways information"
  value = {
    drg_id = module.drg_main.drg_id
  }
}

output "module_drg_main_all_attributes" {
  description = "all attributes for each resources created by this example"
  value = {
    drg = module.drg_main.drg_all_attributes
  }
}