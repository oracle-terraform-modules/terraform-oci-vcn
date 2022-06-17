# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl
output "subnet_id" {
  value = { for v in oci_core_subnet.vcn_subnet : v.display_name => v.id }
}
output "all_attributes" {
  value = { for k, v in oci_core_subnet.vcn_subnet : k => v }
}
