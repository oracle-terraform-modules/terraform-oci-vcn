# Terraform VCN for Oracle Cloud Infrastructure

[changelog]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CHANGELOG.md
[contributing]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTING.md
[contributors]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/CONTRIBUTORS.md
[docs]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/docs

[license]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/LICENSE
[canonical_license]: https://oss.oracle.com/licenses/upl/

[oci]: https://cloud.oracle.com/cloud-infrastructure
[oci_documentation]: https://docs.cloud.oracle.com/iaas/Content/home.htm

[oracle]: https://www.oracle.com
[prerequisites]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.md

[quickstart]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/quickstart.md
[repo]: https://github.com/oracle/terraform-oci-vcn
[resource_manager]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/resourcemanager.md
[reuse]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/examples
[subnets]: https://erikberg.com/notes/networks.html
[terraform]: https://www.terraform.io
[terraform_hashircorp_examples]: https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples
[terraform_oci]: https://www.terraform.io/docs/providers/oci/index.html
[terraform_options]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.md
[terraform_oci_examples]: https://github.com/terraform-providers/terraform-provider-oci/tree/master/examples
[terraform_oci_oke]: https://github.com/oracle-terraform-modules/terraform-oci-oke

The [Terraform VCN][repo] for [Oracle Cloud Infrastructure][oci] (OCI) provides a reusable [Terraform][terraform] module that provisions a minimal VCN on OCI.

It creates the following resources:

- A VCN with one or more customizable CIDR blocks
- An optional internet gateway and a route table
- An optional NAT gateway
- An optional service gateway
- One or more optional Local Peering Gateways in requestor or acceptor mode, with the possibility to associate a Route Table

When `enable_ipv6 = true`, the module also provisions IPv6 support: Oracle-assigned GUA, BYOIPv6 and/or private IPv6 CIDR blocks, IPv6 rules in the Default Security List, and a dual-stack route table (`nat_ipv4_igw_ipv6`) that routes IPv4 through the NAT Gateway and IPv6 through the Internet Gateway.

It also controls the Default Security List, with a *Lockdown mode* that can be enabled or disabled.

Custom route rules can be added to the two route tables created by the module.

This module is primarily meant to be reusable to create more advanced infrastructure on [OCI][oci] either manually in the OCI Console or by extending the Terraform code.

## [Documentation][docs]

### [Pre-requisites][prerequisites]

#### Instructions
- [Quickstart][quickstart]
- [Resource Manager][resource_manager]
- [Reusing as a Terraform module][reuse]
- [Terraform Options][terraform_options]

## Related Documentation, Blog
- [Oracle Cloud Infrastructure Documentation][oci_documentation]
- [Terraform OCI Provider Documentation][terraform_oci]
- [Erik Berg on Networks, Subnets and CIDR][subnets]

## Projects using this module

## Changelog

View the [CHANGELOG][changelog].

## Acknowledgement

Code derived and adapted from [Terraform OCI Examples][terraform_oci_examples] and Hashicorp's [Terraform 0.12 examples][terraform_hashircorp_examples]

## Contributors

[Folks who contributed with explanations, code, feedback, ideas, testing etc.][contributors]

Learn how to [contribute][contributing].

## License

Copyright (c) 2019, 2021 Oracle and/or its associates.

Licensed under the [Universal Permissive License 1.0][license] as shown at
[https://oss.oracle.com/licenses/upl][canonical_license].
