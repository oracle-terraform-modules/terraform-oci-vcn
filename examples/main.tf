# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

module "vcn" {
  source = "../"

  region = "us-phoenix-1"

  # general oci parameters

  compartment_id = ""

  label_prefix = "dev"

  # vcn parameters
  internet_gateway_enabled = false

  lockdown_default_seclist = true

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
