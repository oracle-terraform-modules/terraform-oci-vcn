# modules/drg

## About

This Terraform module creates an OCI [DRG](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingDRGs.htm). It is used internally by the [VCN module](https://registry.terraform.io/modules/oracle-terraform-modules/vcn/oci/latest) but can also be used to provision a DRG independently from the VCN module..

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.
## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.45.0 |
## Resources

| Name | Type |
|------|------|
| [oci_core_drg.drg](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg) | resource |
| [oci_core_drg_attachment.vcns](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_attachment) | resource |
| [oci_core_remote_peering_connection.rpc](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_remote_peering_connections) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | compartment id where to create all resources | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | predefined and scoped to a namespace to tag the created resources using OCI Defined tags. | `map(any)` | `null` | no |
| <a name="input_drg_display_name"></a> [drg\_display\_name](#input\_drg\_display\_name) | (Updatable) Name of Dynamic Routing Gateway. Does not have to be unique. | `string` | `"drg"` | no |
| <a name="input_drg_vcn_attachments"></a> [drg\_vcn\_attachments](#input\_drg\_vcn\_attachments) | The OCID of the network resource attached to the DRG | `map(any)` | `null` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | simple key-value pairs to tag the created resources using freeform OCI Free-form tags. | `map(any)` | <pre>{<br>  "module": "oracle-terraform-modules/vcn/oci//modules/drg",<br>  "terraformed": "Please do not edit manually"<br>}</pre> | no |
| <a name="input_label_prefix"></a> [label\_prefix](#input\_label\_prefix) | a string that will be prepended to all resources | `string` | `"none"` | no |
| <a name="input_region"></a> [region](#input\_region) | the OCI region where resources will be created | `string` | `null` | no |
| <a name="input_create_rpc"></a> [create\_rpc](#input\_create\_rpc) | whether to create Remote Peering Connection. If set to true, creates an Remote Peerin Connection | `bool` | `false` | no |
| <a name="input_rpc_acceptor_id"></a> [remote\_rpc\_id](#input\_remote\_\rpc\_id) | the Remote Peering Connection ID to peer with, running in a remote OCI region. It is required in only one of the two RPCs to establish the peering | `string` | `null` | no |
| <a name="input_rpc_acceptor_region"></a> [remote\_rpc\_region](#input\_remote\_rpc\_region) | the remote OCI region to establish the peer with. List of regions can be found here: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_drg_all_attributes"></a> [drg\_all\_attributes](#output\_drg\_all\_attributes) | all attributes of created drg |
| <a name="output_drg_attachment_all_attributes"></a> [drg\_attachment\_all\_attributes](#output\_drg\_attachment\_all\_attributes) | all attributes related to drg attachment |
| <a name="output_drg_display_name"></a> [drg\_display\_name](#output\_drg\_display\_name) | display name of drg if it is created |
| <a name="output_drg_id"></a> [drg\_id](#output\_drg\_id) | id of drg if it is created |
| <a name="output_drg_summary"></a> [drg\_summary](#output\_drg\_summary) | drg information summary |
| <a name="output_rpc_id"></a> [rpc\_id](#output\_rpc\_id) | id of rpc if it is created |
| <a name="output_rpc_display_name"></a> [rpc\_display\_name](#output\_rpc\_display\_name) | display name of rpc if it is created |
| <a name="output_rpc_all_attributes"></a> [rpc\_all\_attributes](#output\_rpc\_all\_attributes) | all attributes related to rpc |

<!-- END_TF_DOCS -->