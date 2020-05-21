# Copyright 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-${var.vcn_name}"
  dns_label      = var.vcn_dns_label

  freeform_tags = var.freeform_tags
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-ig-gw"
  vcn_id         = oci_core_vcn.vcn.id

  freeform_tags = var.freeform_tags

  count = var.internet_gateway_enabled == true ? 1 : 0
}

resource "oci_core_route_table" "ig" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-ig"

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig[0].id
  }

  dynamic "route_rules" {
    for_each = (var.service_gateway_enabled == true && var.nat_gateway_enabled == false) ? list(1) : []

    content {
      destination       = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gateway[0].id
    }
  }

  vcn_id = oci_core_vcn.vcn.id

  freeform_tags = var.freeform_tags

  count = var.internet_gateway_enabled == true ? 1 : 0
}
