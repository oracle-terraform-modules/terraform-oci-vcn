# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider identity parameters
variable "api_fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "api_private_key_path" {
  description = "path to oci api private key used"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "region" {
  description = "the oci region where resources will be created"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
}

variable "tenancy_id" {
  description = "tenancy id where to create the sources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "user_id" {
  description = "id of user that terraform will use to create the resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
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
  default     = "terraform-oci"
}

# drg parameters

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = "drg_hub"
}

variable "internet_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to Internet Gateway Route Table"
  type        = list(map(string))
  default     = null
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}

# vcn parameters

variable "vcn_spokes" {
  type = map(any)
  default = {
    vcn_spoke1 = {
      cidrs                    = ["10.0.1.0/24", "10.0.2.0/24"]
      dns_label                = "spoke1"
      create_internet_gateway  = true
      create_nat_gateway       = true
      create_service_gateway   = true
      enable_ipv6              = true
      lockdown_default_seclist = true
    }
    vcn_spoke2 = {
      cidrs                    = ["10.0.3.0/24"]
      dns_label                = "spoke2"
      create_internet_gateway  = true
      create_nat_gateway       = false
      create_service_gateway   = true
      enable_ipv6              = false
      lockdown_default_seclist = true
    }
  }
}


