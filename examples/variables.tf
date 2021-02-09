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

# vcn parameters

variable "create_drg" {
  description = "whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway."
  type        = bool
  default     = false
}

variable "internet_gateway_enabled" {
  description = "whether to create the internet gateway"
  type        = bool
  default     = false
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  type        = bool
  default     = true
}

variable "nat_gateway_enabled" {
  description = "whether to create a nat gateway in the vcn"
  type        = bool
  default     = false
}

variable "service_gateway_enabled" {
  description = "whether to create a service gateway"
  type        = bool
  default     = false
}

variable "tags" {
  description = "simple key-value pairs to tag the resources created"
  type        = map(any)
  default = {
    terraformed = "yes"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}

variable "vcn_cidr" {
  description = "cidr block of VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
  default     = "vcnmodule"
}

variable "vcn_name" {
  description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
  type        = string
  default     = "vcn-module"
}

# gateways parameters

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = "drg"
}
