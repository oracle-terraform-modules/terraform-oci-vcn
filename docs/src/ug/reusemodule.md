## Reusing as a Terraform module

You can also use the method below to reuse this in your own module.

1. Create a variable.tf file in your root project and add the contents of [the variables.tf from the example][uri-variables-example].

2. Create a provider.tf file in your root directory and add the following:

```
provider "oci" {
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  region               = var.region
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
}
```
3. Create a main.tf file and add the following:

```
module "vcn" {
  
  source = "github.com/oracle-terraform-modules/terraform-oci-vcn"
  # to use the terraform registry version comment the previous line and uncomment the 2 lines below
  # source  = "oracle-terraform-modules/vcn/oci"
  # version = "specify_version_number"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  freeform_tags  = var.freeform_tags
  defined_tags = var.defined_tags

  # vcn parameters
  create_internet_gateway  = var.create_internet_gateway  # boolean: true or false
  lockdown_default_seclist = var.lockdown_default_seclist # boolean: true or false
  create_nat_gateway       = var.create_nat_gateway       # boolean: true or false
  create_service_gateway   = var.create_service_gateway   # boolean: true or false
  enable_ipv6              = var.enable_ipv6
  vcn_cidrs                = var.vcn_cidrs # List of IPv4 CIDRs
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  # gateways parameters
  internet_gateway_display_name = var.internet_gateway_display_name
  nat_gateway_display_name      = var.nat_gateway_display_name
  service_gateway_display_name  = var.service_gateway_display_name
  attached_drg_id               = var.attached_drg_id
}
```

4. In order to obtain and reuse the VCN resources created, export the OCIDs in outputs.tf:

```
# Outputs

output "module_vcn_ids" {
  description = "vcn and gateways information"
  value = {
    internet_gateway_id          = module.vcn.internet_gateway_id
    internet_gateway_route_id    = module.vcn.ig_route_id
    nat_gateway_id               = module.vcn.nat_gateway_id
    nat_gateway_route_id         = module.vcn.nat_route_id
    service_gateway_id           = module.vcn.service_gateway_id
    vcn_dns_label                = module.vcn.vcn_all_attributes.dns_label
    vcn_default_security_list_id = module.vcn.vcn_all_attributes.default_security_list_id
    vcn_default_route_table_id   = module.vcn.vcn_all_attributes.default_route_table_id
    vcn_default_dhcp_options_id  = module.vcn.vcn_all_attributes.default_dhcp_options_id
    vcn_id                       = module.vcn.vcn_id
  }
}
```

5. Copy terraform.tfvars.example to terraform.tfvars
```
cp terraform.tfvars.example terraform.tfvars
```

6. Set the mandatory provider parameters:
* `api_fingerprint`
* `api_private_key_path`
* `region`
* `tenancy_id`
* `user_id`

7. Override other parameters in terraform.tfvars:

* `compartment_id`
* `label_prefix`
* `vcn_name`

8. Optional parameters to override:

* `attached_drg_id`
* `create_internet_gateway`
* `create_nat_gateway`
* `create_service_gateway`
* `freeform_tags`
* `defined_tags`
* `vcn_dns_label`

9. Run Terraform:
```
terraform init
terraform plan
terraform apply
```

#### Related documentation:

* [All Terraform configuration options][uri-terraform-options] for this project.

[uri-terraform-options]: ./chapter_8.md
[uri-variables-example]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/examples/module_composition/variables.tf