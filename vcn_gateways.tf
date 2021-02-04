# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource oci_core_internet_gateway "ig" {
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


data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = var.service_gateway_enabled == true ? 1 : 0
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "service-gateway" : "${var.label_prefix}-service-gateway"

  freeform_tags = var.tags
  services {
    service_id = lookup(data.oci_core_services.all_oci_services[0].services[0], "id")
  }

  vcn_id = oci_core_vcn.vcn.id

  count = var.service_gateway_enabled == true ? 1 : 0
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "nat-gateway" : "${var.label_prefix}-nat-gateway"

  freeform_tags = var.tags

  vcn_id = oci_core_vcn.vcn.id

  count = var.nat_gateway_enabled == true ? 1 : 0
}

resource "oci_core_route_table" "nat" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "nat-route" : "${var.label_prefix}-nat-route"

  freeform_tags = var.tags

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway[0].id
  }

  dynamic "route_rules" {
    for_each = var.service_gateway_enabled == true ? list(1) : []

    content {
      destination       = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gateway[0].id
    }
  }

  vcn_id = oci_core_vcn.vcn.id

  count = var.nat_gateway_enabled == true ? 1 : 0
}
