# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# special fix due to bug introduced in #101 which causes destruction and recreation of subnets
resource "oci_core_route_table" "nat_table_changes_ignored" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "nat-route" : "${var.label_prefix}-nat-route"

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  route_rules {
    # * With this route table, NAT Gateway is always declared as the default gateway
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway[0].id
    description       = "Terraformed - Auto-generated at NAT Gateway creation: NAT Gateway as default gateway"
  }

  # bring this block back to fix #101
  dynamic "route_rules" {
    # * If Service Gateway is created with the module, automatically creates a rule to handle traffic for "all services" through Service Gateway
    for_each = var.create_service_gateway == true ? [1] : []

    content {
      destination       = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gateway[0].id
      description       = "Terraformed - Auto-generated at Service Gateway creation: All Services in region to Service Gateway"
    }
  }

  dynamic "route_rules" {
    # * filter var.nat_gateway_route_rules for routes with "drg" as destination
    # * and steer traffic to the attached DRG if available
    for_each = var.nat_gateway_route_rules != null ? { for k, v in var.nat_gateway_route_rules : k => v
    if v.network_entity_id == "drg" && var.attached_drg_id != null } : {}

    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = var.attached_drg_id
      description       = route_rules.value.description
    }
  }

  dynamic "route_rules" {
    # * filter var.nat_gateway_route_rules for routes with "nat_gateway" as destination
    # * and steer traffic to the module created NAT Gateway
    for_each = var.nat_gateway_route_rules != null ? { for k, v in var.nat_gateway_route_rules : k => v
    if v.network_entity_id == "nat_gateway" } : {}

    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = oci_core_nat_gateway.nat_gateway[0].id
      description       = route_rules.value.description
    }
  }

  dynamic "route_rules" {
    # * filter var.nat_gateway_route_rules for generic routes
    # * can take any Named Value : String, Input Variable, Local Value, Data Source, Resource, Module Output ...
    # * useful for gateways that are not managed by the module
    for_each = var.nat_gateway_route_rules != null ? { for k, v in var.nat_gateway_route_rules : k => v
    if contains(["drg", "nat_gateway"], v.network_entity_id) == false } : {}

    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = route_rules.value.network_entity_id
      description       = route_rules.value.description
    }
  }

  vcn_id = oci_core_vcn.vcn.id

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags, route_rules]
  }

  count = var.create_nat_gateway && !var.update_nat_route_table ? 1 : 0
}