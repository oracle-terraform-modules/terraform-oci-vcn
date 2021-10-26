# Terraform VCN for Oracle Cloud Infrastructure

The [Terraform VCN][repo] for [Oracle Cloud Infrastructure][OCI] provides a reusable [Terraform][terraform] module that provisions a minimal VCN on OCI.

It creates the following resources:

* A VCN with one or more customizable CIDR blocks
* An optional internet gateway and a route table
* An optional NAT gateway
* An optional service gateway
* An optional dynamic routing gateway
* One or more optional Local Peering Gateways in requestor or acceptor mode, and possibilities to associate a Route Table

It also controls the Default Security List, with a *Lockdown mode* that can be enabled or disabled.

Custom route rules can be added to the two route tables created by the module.

This module is primarily meant to be reusable to create more advanced infrastructure on [OCI][OCI] either manually in the OCI Console or by extending the Terraform code.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| oci | >=4.41.0 |

## Providers

| Name | Version |
|------|---------|
| oci | >=4.41.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment\_id | compartment id where to create all resources | `string` | n/a | yes |
| create\_drg | Deprecated: Use drg sub-module instead. Whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway and attach it to the vcn. | `bool` | `false` | no |
| create\_internet\_gateway | whether to create the internet gateway in the vcn. If set to true, creates an Internet Gateway. | `bool` | `false` | no |
| create\_nat\_gateway | whether to create a nat gateway in the vcn. If set to true, creates a nat gateway. | `bool` | `false` | no |
| create\_service\_gateway | whether to create a service gateway. If set to true, creates a service gateway. | `bool` | `false` | no |
| drg\_display\_name | Deprecated: Use drg sub-module instead. (Updatable) Name of Internet Gateway. Does not have to be unique. | `string` | `"drg"` | no |
| enable\_ipv6 | Whether IPv6 is enabled for the VCN. If enabled, Oracle will assign the VCN a IPv6 /56 CIDR block. | `bool` | `false` | no |
| freeform\_tags | simple key-value pairs to tag the created resources using freeform OCI Free-form tags. | `map(any)` | <pre>{<br>  "module": "oracle-terraform-modules/vcn/oci",<br>  "terraformed": "Please do not edit manually"<br>}</pre> | no |
| internet\_gateway\_display\_name | (Updatable) Name of Internet Gateway. Does not have to be unique. | `string` | `"internet-gateway"` | no |
| internet\_gateway\_route\_rules | (Updatable) List of routing rules to add to Internet Gateway Route Table | `list(map(string))` | `null` | no |
| label\_prefix | a string that will be prepended to all resources | `string` | `"none"` | no |
| local\_peering\_gateways | Map of Local Peering Gateways to attach to the VCN. | `map(any)` | `null` | no |
| lockdown\_default\_seclist | whether to remove all default security rules from the VCN Default Security List | `bool` | `true` | no |
| nat\_gateway\_display\_name | (Updatable) Name of NAT Gateway. Does not have to be unique. | `string` | `"nat-gateway"` | no |
| nat\_gateway\_public\_ip\_id | OCID of reserved IP address for NAT gateway. The reserved public IP address needs to be manually created. | `string` | `"none"` | no |
| nat\_gateway\_route\_rules | (Updatable) list of routing rules to add to NAT Gateway Route Table | `list(map(string))` | `null` | no |
| region | the OCI region where resources will be created | `string` | `null` | no |
| service\_gateway\_display\_name | (Updatable) Name of Service Gateway. Does not have to be unique. | `string` | `"service-gateway"` | no |
| vcn\_cidrs | The list of IPv4 CIDR blocks the VCN will use. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| vcn\_dns\_label | A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet | `string` | `"vcnmodule"` | no |
| vcn\_name | user-friendly name of to use for the vcn to be appended to the label\_prefix | `string` | `"vcn-module"` | no |

## Outputs

| Name | Description |
|------|-------------|
| drg\_attachment\_all\_attributes | Deprecated: Use drg sub-module instead. all attributes related to drg attachment |
| drg\_id | Deprecated: Use drg sub-module instead. id of drg if it is created |
| ig\_route\_all\_attributes | all attributes of created ig route table |
| ig\_route\_id | id of internet gateway route table |
| internet\_gateway\_all\_attributes | all attributes of created internet gateway |
| internet\_gateway\_id | id of internet gateway if it is created |
| lpg\_all\_attributes | all attributes of created lpg |
| nat\_gateway\_all\_attributes | all attributes of created nat gateway |
| nat\_gateway\_id | id of nat gateway if it is created |
| nat\_route\_all\_attributes | all attributes of created nat gateway route table |
| nat\_route\_id | id of VCN NAT gateway route table |
| service\_gateway\_all\_attributes | all attributes of created service gateway |
| service\_gateway\_id | id of service gateway if it is created |
| vcn\_all\_attributes | all attributes of created vcn |
| vcn\_id | id of vcn that is created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## [Documentation][docs]

### [Pre-requisites][prerequisites]

#### Instructions

* [Quickstart][quickstart]
* [Reusing as a Terraform module][reuse]
* [Terraform Options][terraform_options]

## Related Documentation, Blog

* [Oracle Cloud Infrastructure Documentation][oci_documentation]
* [Terraform OCI Provider Documentation][terraform_oci]
* [Erik Berg on Networks, Subnets and CIDR][subnets]
* [Lisa Hagemann on Terraform cidrsubnet Deconstructed][terraform_cidr_subnet]

## Projects using this module

## Changelog

View the [CHANGELOG][changelog].

## Acknowledgement

Code derived and adapted from [Terraform OCI Examples][terraform_oci_examples] and Hashicorp's [Terraform 0.12 examples][terraform_oci_examples]

## Contributors

[Folks who contributed with explanations, code, feedback, ideas, testing etc.][contributors]

Learn how to [contribute][contributing].

## License

Copyright (c) 2019, 2021 Oracle and/or its associates.

Licensed under the [Universal Permissive License 1.0][license] as shown at
[https://oss.oracle.com/licenses/upl][canonical_license].

<!-- Links reference section -->
[changelog]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CHANGELOG.adoc
[contributing]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTING.adoc
[contributors]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTORS.adoc
[docs]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/docs

[license]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/LICENSE
[canonical_license]: https://oss.oracle.com/licenses/upl/

[oci]: https://cloud.oracle.com/cloud-infrastructure
[oci_documentation]: https://docs.cloud.oracle.com/iaas/Content/home.htm

[oracle]: https://www.oracle.com
[prerequisites]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.adoc

[quickstart]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/quickstart.adoc
[repo]: https://github.com/oracle/terraform-oci-vcn
[reuse]: https://github.com/oracle/terraform-oci-vcn/examples/db
[subnets]: https://erikberg.com/notes/networks.html
[terraform]: https://www.terraform.io
[terraform_cidr_subnet]: http://blog.itsjustcode.net/blog/2017/11/18/terraform-cidrsubnet-deconstructed/
[terraform_hashircorp_examples]: https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples
[terraform_oci]: https://www.terraform.io/docs/providers/oci/index.html
[terraform_options]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.adoc
[terraform_oci_examples]: https://github.com/terraform-providers/terraform-provider-oci/tree/master/examples
[terraform_oci_oke]: https://github.com/oracle-terraform-modules/terraform-oci-oke
<!-- Links reference section -->