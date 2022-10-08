# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  dhcp_default_options = data.oci_core_dhcp_options.dhcp_options.options.0.id
}

resource "oci_core_subnet" "vcn_subnet" {
  for_each       = var.subnets
  cidr_block     = each.value.cidr_block
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id


  defined_tags    = var.defined_tags
  dhcp_options_id = local.dhcp_default_options
  display_name    = lookup(each.value, "name", each.key)
  dns_label       = lookup(each.value, "dns_label", null)
  freeform_tags   = var.freeform_tags
  #commented for IPV6 support
  #ipv6cidr_block             = var.enable_ipv6 == false ? null : each.value.ipv6cidr_block
  #ipv6cidr_blocks            = var.enable_ipv6 == false ? null : [each.value.ipv6cidr_block]
  #prohibit_internet_ingress  = var.enable_ipv6 && lookup(each.value,"type","public") == "public" ? each.value.prohibit_internet_ingress : false
  prohibit_public_ip_on_vnic = lookup(each.value, "type", "public") == "public" ? false : true
  route_table_id             = lookup(each.value, "type", "public") == "public" ? var.ig_route_id : var.nat_route_id
  security_list_ids          = null

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

data "oci_core_dhcp_options" "dhcp_options" {

  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
}
