# Copyright (c) 2019, 2020 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

module "vcn" {
  source = "../"

  region = "us-phoenix-1"

  # general oci parameters

  compartment_id = ""

  label_prefix = "dev"

  # vcn parameters
  internet_gateway_enabled = false

  nat_gateway_enabled = false

  service_gateway_enabled = false

  vcn_cidr = "10.0.0.0/16"

  vcn_dns_label = "vcn"

  vcn_name = "vcn"

  tags = {
    environment = "dev"
    lob         = "finance"
  }
}
