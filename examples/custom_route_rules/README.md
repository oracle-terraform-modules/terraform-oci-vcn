# Declaring custom routing rules for module terraform-oci-vcn

[Terraform Variable Definition file]:https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files
[Input Variables]:https://www.terraform.io/docs/language/values/variables.html
[Local Values]:https://www.terraform.io/docs/language/values/locals.html
[Named Values]:https://www.terraform.io/docs/language/expressions/references.html
[docs/prerequisites]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.adoc
[docs/terraformoptions]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.adoc
[docs/routing_rules]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/routing_rules.adoc
[Provisioning Infrastructure with Terraform]:https://www.terraform.io/docs/cli/run/index.html

This example illustrates how to use `terraform-oci-vcn` module to create a vcn with gateways and custom routing rules.

For demonstration purpose, all the gateways supported by this module are created:

- DRG
- Internet Gateway
- NAT Gateway
- Service Gateway

Two Route Tables also are created by the module:

- `internet_gateway_route_rules` module Input Variable, which controls the rules in `terraform-oci-internet-route` Route Table
- `nat_gateway_route_rules` module Input Variable, which controls the rules in `terraform-oci-nat-route` Route Table

In addition, a Local Peering Gateway is created at the root of the configuration (not managed by the module) : `terraform-oci-lpg`

This diagram illustrates what will be created by this example.

![diagram](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/images/custom_route_rules.drawio.PNG?raw=true&sanitize=true)

## How to specify module Input Variables values

This example shows two methods to specify values for `internet_gateway_route_rules` and `nat_gateway_route_rules` module Variable Inputs:

- using a Variable Input for `internet_gateway_route_rules`, declared in `variables.tf` with values initialized in `terraform.tfvars` (you can copy/rename `terraform.tfvars.example` from the same folder)
- using a Local Value for `nat_gateway_route_rules`, declared and initialized directly in `variables.tf`

Using [Input Variables] in conjuction with *.tfvars files is a common pattern. We introduce here the usage of [Local Values] for the same goal. There is many advantages in using `Local Values` over `Variable Inputs` at the root of the configuration:

- Values can be computed and becomes dynamic, with Terraform Functions, of coming possibly from any valid [Named Values]
- Declaration and Initialization occurs in one place, for easier reading and configuration sharing

For details about type and the accepted values for these two Input Variables, please see [docs/terraformoptions] and [docs/routing_rules]

## Prerequisites

You will need to collect the following information before you start:

1. your OCI provider authentication values
2. a compartment OCID in which the present configuration will be created

For detailed instructions, see [docs/prerequisites]

## Using this example with Terraform CLI

Prepare one [Terraform Variable Definition file] named `terraform.tfvars` with the required authentication information.

*TIP: You can rename and configure `terraform.tfvars.example` from this example's folder.*

Then apply the example using the following commands:

```shell
> terraform init
> terraform plan
> terraform apply
```

See [Provisioning Infrastructure with Terraform] for more details about Terraform CLI and the available subcommands.
