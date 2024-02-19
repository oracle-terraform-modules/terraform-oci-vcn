# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
  anywhere      = "0.0.0.0/0"
  anywhere_ipv6 = "::/0"
  internet_gateway_display_name = coalesce(
    var.label_prefix == "none" && var.internet_gateway_display_name == "none" ? "internet-route" : null,
    var.label_prefix == "none" && var.internet_gateway_display_name != "none" ? var.internet_gateway_display_name : null,
    var.label_prefix != "none" && var.internet_gateway_display_name == "none" ? "${var.label_prefix}-internet-route" : null,
    var.label_prefix != "none" && var.internet_gateway_display_name != "none" ? "${var.label_prefix}-${var.internet_gateway_display_name}" : null
  )
  service_gateway_display_name = coalesce(
    var.label_prefix == "none" && var.service_gateway_display_name == "none" ? "service-gw-route" : null,
    var.label_prefix == "none" && var.service_gateway_display_name != "none" ? var.service_gateway_display_name : null,
    var.label_prefix != "none" && var.service_gateway_display_name == "none" ? "${var.label_prefix}-service-gw-route" : null,
    var.label_prefix != "none" && var.service_gateway_display_name != "none" ? "${var.label_prefix}-${var.service_gateway_display_name}" : null
  )
  nat_gateway_display_name = coalesce(
    var.label_prefix == "none" && var.nat_gateway_display_name == "none" ? "nat-route" : null,
    var.label_prefix == "none" && var.nat_gateway_display_name != "none" ? var.nat_gateway_display_name : null,
    var.label_prefix != "none" && var.nat_gateway_display_name == "none" ? "${var.label_prefix}-nat-route" : null,
    var.label_prefix != "none" && var.nat_gateway_display_name != "none" ? "${var.label_prefix}-${var.nat_gateway_display_name}" : null
  )
}