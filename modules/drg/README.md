# modules/drg

## About

This Terraform module creates an OCI [DRG](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm). It is used internally by the [VCN module](https://registry.terraform.io/modules/oracle-terraform-modules/vcn/oci/latest) but can also be used to provision a DRG independently from the VCN module..

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.
## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
## Resources

| Name | Type |
|------|------|
| [oci_core_drg.drg](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | compartment id where to create all resources | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | predefined and scoped to a namespace to tag the created resources using OCI Defined tags. | `map(any)` | `null` | no |
| <a name="input_drg_display_name"></a> [drg\_display\_name](#input\_drg\_display\_name) | (Updatable) Name of Dynamic Routing Gateway. Does not have to be unique. | `string` | `"drg"` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | simple key-value pairs to tag the created resources using freeform OCI Free-form tags. | `map(any)` | <pre>{<br>  "module": "oracle-terraform-modules/vcn/oci//modules/drg",<br>  "terraformed": "Please do not edit manually"<br>}</pre> | no |
| <a name="input_label_prefix"></a> [label\_prefix](#input\_label\_prefix) | a string that will be prepended to all resources | `string` | `"none"` | no |
| <a name="input_region"></a> [region](#input\_region) | the OCI region where resources will be created | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_drg_all_attributes"></a> [drg\_all\_attributes](#output\_drg\_all\_attributes) | all attributes of created drg |
| <a name="output_drg_id"></a> [drg\_id](#output\_drg\_id) | id of drg if it is created |

<!-- END_TF_DOCS -->