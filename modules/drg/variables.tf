# Copyright (c) 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider identity parameters

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the OCI region where resources will be created"
  type        = string
  default     = null
}

# general oci parameters

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "label_prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-modules/vcn/oci//modules/drg"
  }
}

variable "defined_tags" {
  description = "predefined and scoped to a namespace to tag the created resources using OCI Defined tags."
  type        = map(any)
  default     = null
}

# drg parameters

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = "drg"

  validation {
    condition     = length(var.drg_display_name) > 0
    error_message = "The drg_display_name value cannot be an empty string."
  }
}

variable "drg_vcn_attachments" {
  description = "The OCID of the network resource attached to the DRG"
  type        = map(any)
  default     = null
}
