# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
  anywhere      = "0.0.0.0/0"
  anywhere_ipv6 = "::/0"
  ig_rt_display_name = coalesce(
    var.label_prefix == "none" && var.ig_rt_display_name == "none" ? "internet-route" : null,
    var.label_prefix == "none" && var.ig_rt_display_name != "none" ? var.ig_rt_display_name : null,
    var.label_prefix != "none" && var.ig_rt_display_name == "none" ? "${var.label_prefix}-internet-route" : null,
    var.label_prefix != "none" && var.ig_rt_display_name != "none" ? "${var.label_prefix}-${var.ig_rt_display_name}" : null
  )
  sg_rt_display_name = coalesce(
    var.label_prefix == "none" && var.sg_rt_display_name == "none" ? "service-gw-route" : null,
    var.label_prefix == "none" && var.sg_rt_display_name != "none" ? var.sg_rt_display_name : null,
    var.label_prefix != "none" && var.sg_rt_display_name == "none" ? "${var.label_prefix}-service-gw-route" : null,
    var.label_prefix != "none" && var.sg_rt_display_name != "none" ? "${var.label_prefix}-${var.sg_rt_display_name}" : null
  )
  nat_rt_display_name = coalesce(
    var.label_prefix == "none" && var.nat_rt_display_name == "none" ? "nat-route" : null,
    var.label_prefix == "none" && var.nat_rt_display_name != "none" ? var.nat_rt_display_name : null,
    var.label_prefix != "none" && var.nat_rt_display_name == "none" ? "${var.label_prefix}-nat-route" : null,
    var.label_prefix != "none" && var.nat_rt_display_name != "none" ? "${var.label_prefix}-${var.nat_rt_display_name}" : null
  )
}