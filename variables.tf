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

variable "freeform_tags" {
  description = "simple key-value pairs to tag the resources created using freeform freeform_tags."
  type        = map(any)
  default = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-modules/vcn/oci"
  }
}

# vcn parameters

variable "create_drg" {
  description = "whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway and attach it to the vcn."
  type        = bool
  default     = false
}

variable "create_internet_gateway" {
  description = "whether to create the internet gateway in the vcn. If set to true, creates an Internet Gateway."
  default     = false
  type        = bool
}

variable "local_peering_gateways" {
  description = "Map of Local Peering Gateways to attach to the VCN."
  type        = map(any)
  default     = null
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}

variable "create_nat_gateway" {
  description = "whether to create a nat gateway in the vcn. If set to true, creates a nat gateway."
  default     = false
  type        = bool
}

variable "nat_gateway_public_ip_id" {
  description = "OCID of reserved IP address for NAT gateway. The reserved public IP address needs to be manually created."
  default     = "none"
  type        = string
}

variable "create_service_gateway" {
  description = "whether to create a service gateway. If set to true, creates a service gateway."
  default     = false
  type        = bool
}

variable "vcn_cidrs" {
  description = "The list of IPv4 CIDR blocks the VCN will use."
  default     = ["10.0.0.0/16"]
  type        = list(string)
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
  default     = "drg"
}

variable "internet_gateway_display_name" {
  description = "(Updatable) Name of Internet Gateway. Does not have to be unique."
  type        = string
  default     = "internet-gateway"
}

variable "nat_gateway_display_name" {
  description = "(Updatable) Name of NAT Gateway. Does not have to be unique."
  type        = string
  default     = "nat-gateway"
}

variable "service_gateway_display_name" {
  description = "(Updatable) Name of Service Gateway. Does not have to be unique."
  type        = string
  default     = "service-gateway"
}


# routing rules

variable "internet_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to Internet Gateway Route Table"
  type = list(object({
    destination       = string
    destination_type  = string
    network_entity_id = string
    description       = string
  }))
  default = null
}

variable "nat_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to NAT Gateway Route Table"
  type = list(object({
    destination       = string
    destination_type  = string
    network_entity_id = string
    description       = string
  }))
  default = null
}
