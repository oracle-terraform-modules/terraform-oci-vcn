# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_vcn" "vcn" {
  # We still allow module users to declare a cidr using `vcn_cidr` instead of the now recommended `vcn_cidrs`, but internally we map both to `cidr_blocks`
  # The module always use the new list of string structure and let the customer update his module definition block at his own pace.
  cidr_blocks    = var.vcn_cidrs[*]
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? var.vcn_name : "${var.label_prefix}-${var.vcn_name}"
  dns_label      = var.vcn_dns_label
  is_ipv6enabled = var.enable_ipv6

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

#Module for Subnet
module "subnet" {
  source = "./modules/subnet"

  compartment_id = var.compartment_id
  subnets        = var.subnets
  enable_ipv6    = var.enable_ipv6
  vcn_id         = oci_core_vcn.vcn.id
  ig_route_id    = var.create_internet_gateway ? oci_core_route_table.ig[0].id : null
  nat_route_id   = var.create_nat_gateway ? oci_core_route_table.nat[0].id : null

  freeform_tags = var.freeform_tags

  count = length(var.subnets) > 0 ? 1 : 0

}
