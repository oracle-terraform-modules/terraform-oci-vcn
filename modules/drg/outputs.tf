# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

output "drg_id" {
  description = "id of drg if it is created"
  value       = join(",", oci_core_drg.drg[*].id)
}

output "drg_display_name" {
  description = "display name of drg if it is created"
  value       = join(",", oci_core_drg.drg[*].display_name)
}

# Complete outputs for each resources with provider parity. Auto-updating.
# Usefull for module composition.

output "drg_all_attributes" {
  description = "all attributes of created drg"
  value       = { for k, v in oci_core_drg.drg : k => v }
}

output "drg_attachment_all_attributes" {
  description = "all attributes related to drg attachment"
  value       = { for k, v in oci_core_drg_attachment.vcns : k => v }
}

output "drg_summary" {
  description = "drg information summary"
  value = {
    (oci_core_drg.drg.display_name) = {
      drg_id          = oci_core_drg.drg.id
      vcn_attachments = { for k, v in oci_core_drg_attachment.vcns : k => v.network_details[0].id }
    }
  }
}
