# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? var.vcn_name : "${var.label_prefix}-${var.vcn_name}"
  dns_label      = var.vcn_dns_label

  freeform_tags = var.tags
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "internet-gateway" : "${var.label_prefix}-internet-gateway"

  freeform_tags = var.tags

  vcn_id = oci_core_vcn.vcn.id

  count = var.internet_gateway_enabled == true ? 1 : 0
}

resource "oci_core_route_table" "ig" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "internet-route" : "${var.label_prefix}-internet-route"

  freeform_tags = var.tags

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig[0].id
  }

  vcn_id = oci_core_vcn.vcn.id

  count = var.internet_gateway_enabled == true ? 1 : 0
}
