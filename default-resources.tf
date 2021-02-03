# Copyright (c) 2021 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# VCN default Security List Lockdown
// See Issue #22 for 
resource "oci_core_default_security_list" "lockdown" {
  // If variable is true, removes all rules from default security list
  count                      = var.default_SL_lockdown == true ? 1 : 0
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id
}

resource "oci_core_default_security_list" "restore_default" {
  // If variable is false, restore all default rules to default security list
  count                      = var.default_SL_lockdown == false ? 1 : 0
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    // allow all egress traffic
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    // SSH for all
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    // ICMP for all type 3 code 4
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      type = "3"
      code = "4"
    }
  }

  ingress_security_rules {
    //ICMP for VCN
    protocol = "1"
    source   = var.vcn_cidr

    icmp_options {
      type = "3"
    }
  }
}
