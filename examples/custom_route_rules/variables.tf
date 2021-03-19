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
  default     = true
}

variable "internet_gateway_enabled" {
  description = "whether to create the internet gateway"
  type        = bool
  default     = true
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  type        = bool
  default     = true
}

variable "nat_gateway_enabled" {
  description = "whether to create a nat gateway in the vcn"
  type        = bool
  default     = true
}

variable "service_gateway_enabled" {
  description = "whether to create a service gateway"
  type        = bool
  default     = true
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

locals {
  nat_gateway_route_rules = [ # this is a local that can be used to pass routing information to vcn module for either route tables
    {
      destination       = "192.168.0.0/16" # Route Rule Destination CIDR
      destination_type  = "CIDR_BLOCK"     # only CIDR_BLOCK is supported at the moment
      network_entity_id = "drg"            # for nat_gateway_route_rules input variable, you can use special strings "drg", "nat_gateway" or pass a valid OCID using string or any Named Values
      description       = "Terraformed - User added Routing Rule: To drg created by this module. drg_id is automatically retrieved with keyword drg"
    },
    {
      destination       = "172.16.0.0/16"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.vcn.drg_id
      description       = "Terraformed - User added Routing Rule: To drg with drg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
    {
      destination       = "203.0.113.0/24" # rfc5737 (TEST-NET-3)
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "nat_gateway"
      description       = "Terraformed - User added Routing Rule: To NAT Gateway created by this module. nat_gateway_id is automatically retrieved with keyword nat_gateway"
    },
    {
      destination       = "192.168.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_local_peering_gateway.lpg.id
      description       = "Terraformed - User added Routing Rule: To lpg with lpg_id directly passed by user. Useful for gateways created outside of vcn module"
    },
  ]
}
