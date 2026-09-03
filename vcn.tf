# Copyright (c) 2019, 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_vcn" "vcn" {
  # We still allow module users to declare a cidr using `vcn_cidr` instead of the now recommended `vcn_cidrs`, but internally we map both to `cidr_blocks`
  # The module always use the new list of string structure and let the customer update his module definition block at his own pace.
  cidr_blocks                      = var.vcn_cidrs[*]
  compartment_id                   = var.compartment_id
  display_name                     = var.label_prefix == "none" ? var.vcn_name : "${var.label_prefix}-${var.vcn_name}"
  dns_label                        = var.vcn_dns_label
  is_ipv6enabled                   = var.enable_ipv6
  is_oracle_gua_allocation_enabled = var.enable_ipv6 ? var.vcn_is_oracle_gua_allocation_enabled : null
  ipv6private_cidr_blocks          = var.enable_ipv6 ? var.vcn_ipv6private_cidr_blocks : null

  dynamic "byoipv6cidr_details" {
    for_each = var.enable_ipv6 ? var.vcn_byoipv6cidr_details : []
    content {
      byoipv6range_id = byoipv6cidr_details.value.byoipv6range_id
      ipv6cidr_block  = byoipv6cidr_details.value.ipv6cidr_block
    }
  }

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  lifecycle {
    ignore_changes = [defined_tags, dns_label, freeform_tags, is_ipv6enabled, is_oracle_gua_allocation_enabled]
  }
}

#Module for Subnet
module "subnet" {
  source = "./modules/subnet"

  compartment_id             = var.compartment_id
  tenancy_id                 = var.tenancy_id
  subnets                    = local.enriched_subnets
  enable_ipv6                = var.enable_ipv6
  vcn_id                     = oci_core_vcn.vcn.id
  ig_route_id                = var.create_internet_gateway ? oci_core_route_table.ig[0].id : null
  nat_route_id               = var.create_nat_gateway ? oci_core_route_table.nat[0].id : null
  nat_ipv4_igw_ipv6_route_id = local.has_public_ipv6 && var.create_internet_gateway && var.create_nat_gateway ? oci_core_route_table.nat_ipv4_igw_ipv6[0].id : null

  freeform_tags = var.freeform_tags

  count = length(var.subnets) > 0 ? 1 : 0

}

locals {
  vcn_id = oci_core_vcn.vcn.id
  subnet = {
    for key, value in var.subnets : key => contains(keys(value), "name") ? value.name : key
  }

  subnet_ipv6_cidr_blocks = var.enable_ipv6 ? {
    for key, value in var.subnets : key => contains(keys(value), "ipv6cidr_blocks") ?
    { "ipv6cidr_blocks" : [for entry in value["ipv6cidr_blocks"] : length(regexall("^\\d+,[ ]?\\d+$", entry)) > 0 ? cidrsubnet(local.vcn_ipv6_cidr_blocks[0], tonumber(split(",", entry)[0]), tonumber(trim(split(",", entry)[1], " "))) : entry] } :
    { "ipv6cidr_blocks" : [] }
  } : {}

  vcn_ipv6_cidr_blocks = concat(oci_core_vcn.vcn.ipv6cidr_blocks, var.vcn_ipv6private_cidr_blocks)

  enriched_subnets = { for k, v in var.subnets :
    k => merge(v, lookup(local.subnet_ipv6_cidr_blocks, k, null))
  }

  service_logdef = { for k in local.subnet : format("%s_%s", k, "log") => { loggroup = "loggrp", service = "flowlogs", resource = k } }
}

#Module for Logging
module "logging" {

  count  = var.enable_vcn_logging ? 1 : 0
  source = "github.com/oracle-terraform-modules/terraform-oci-logging?ref=v0.4.0"

  compartment_id         = var.compartment_id
  log_retention_duration = var.log_retention_duration
  service_logdef         = local.service_logdef
  vcn_id                 = local.vcn_id
  tenancy_id             = var.tenancy_id

  depends_on = [
    oci_core_vcn.vcn,
    module.subnet
  ]
}
