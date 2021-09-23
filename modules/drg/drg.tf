# Copyright (c) 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? var.drg_display_name : "${var.label_prefix}-${var.drg_display_name}"

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}

resource "oci_core_drg_attachment" "drg" {
  for_each     = var.drg_attachment_resource_ids != null ? var.drg_attachment_resource_ids : {}
  display_name = var.label_prefix == "none" ? "${var.drg_display_name}-to-${each.key}" : "${var.label_prefix}-${var.drg_display_name}-to-${each.key}"

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  drg_id = oci_core_drg.drg.id

  network_details {
    id = each.value # required
    # route_table_id = "" # optional. Needed for VTR
    type = "VCN" # Required, Updatable: IPSEC_TUNNEL, REMOTE_PEERING_CONNECTION, VCN, VIRTUAL_CIRCUIT
  }

  # TODO: args to implement
  # drg_route_table_id = (Optional) (Updatable) string
  # export_drg_route_distribution_id = (Optional) (Updatable) string
  # remove_export_drg_route_distribution_trigger = (Optional) (Updatable) boolean
}

# boilerplate from doc
# resource "oci_core_drg_attachment" "test_drg_attachment" {
#     #Required
#     drg_id = oci_core_drg.test_drg.id

#     #Optional
#     defined_tags = {"Operations.CostCenter"= "42"}
#     display_name = var.drg_attachment_display_name
#     drg_route_table_id = oci_core_drg_route_table.test_drg_route_table.id
#     freeform_tags = {"Department"= "Finance"}
#     network_details {
#         #Required
#         id = var.drg_attachment_network_details_id
#         type = var.drg_attachment_network_details_type

#         #Optional
#         route_table_id = oci_core_route_table.test_route_table.id
#     }
#     route_table_id = oci_core_route_table.test_route_table.id
#     vcn_id = oci_core_vcn.test_vcn.id
# }