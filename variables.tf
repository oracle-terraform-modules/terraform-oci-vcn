# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
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

variable "tags" {
  #! Deprecation notice: will be renamed to freeform_tags at next major release
  description = "simple key-value pairs to tag the resources created using freeform tags."
  type        = map(any)
  default = {
    terraformed = "yes"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}

# vcn parameters

variable "create_drg" {
  description = "whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway and attach it to the vcn."
  type        = bool
  default     = false
}

variable "internet_gateway_enabled" {
  #! Deprecation notice: will be renamed to create_internet_gateway at next major release
  description = "whether to create the internet gateway in the vcn. If set to true, creates an Internet Gateway."
  default     = false
  type        = bool
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}

variable "nat_gateway_enabled" {
  #! Deprecation notice: will be renamed to create_nat_gateway at next major release
  description = "whether to create a nat gateway in the vcn. If set to true, creates a nat gateway."
  default     = false
  type        = bool
}

variable "service_gateway_enabled" {
  #! Deprecation notice: will be renamed to create_service_gateway at next major release
  description = "whether to create a service gateway. If set to true, creates a service gateway."
  default     = false
  type        = bool
}

variable "vcn_cidr" {
  description = "cidr block of VCN"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
}

variable "vcn_name" {
  description = "user-friendly name of to use for the vcn to be appended to the label_prefix"
  type        = string
}

# gateways parameters

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = null
}
