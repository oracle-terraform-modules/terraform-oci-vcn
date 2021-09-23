# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# display names and ids of a module not using for_each or count and shows how to use the *_all_attributes output to select a specific field
output "module_drg_hub" {
  description = "drg name and OCID"
  value       = { (module.drg_hub.drg_all_attributes.display_name) = module.drg_hub.drg_id }
}

# display names and ids of a module that use for_each and shows how to use the *_all_attributes output to select a specific field
output "module_vcn_spokes" {
  description = "vcn names and OCIDs"
  value       = { for vcn in module.vcn_spokes : "${~vcn.vcn_all_attributes.display_name~}" => "${vcn.vcn_id~}" }
  # We combine here two expressions:
  # 1. "for" expression to loop over each key of module.vcn_spokes wrapped with {...} to produce an object
  # 2. "String Template directives" for interpolation and whitespace stripping:
  #   --> ${ ... } evaluates the expression given between the markers, then inserts it into the final string https://www.terraform.io/docs/language/expressions/strings.html#interpolation
  #   --> ~ indicates whitespace stripping before or after https://www.terraform.io/docs/language/expressions/strings.html#whitespace-stripping
  #
  # result will be an object containing "vcn.display_name" = "vcn.id" for each vcn in the vcn_spokes module
}
