# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
}

variable "subnets" {
  description = "Subnets to be created"
  type        = any
  default     = {}
}

variable "enable_ipv6" {
  description = "Enable IPV6"
  type        = bool
  default     = false
}

variable "vcn_id" {
  description = "VCN ID"
  type        = string

}

variable "ig_route_id" {
  description = "Internet Gateway route table id"
  type        = string
}

variable "nat_route_id" {
  description = "NAT Gateway route table id"
  type        = string
}

variable "defined_tags" {
  description = "predefined and scoped to a namespace to tag the resources created using defined tags."
  type        = map(string)
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
