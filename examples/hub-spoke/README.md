# Creating a hub-and-spoke using LPGs with module terraform-oci-vcn

[Terraform Variable Definition file]:https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files
[Input Variables]:https://www.terraform.io/docs/language/values/variables.html
[Local Values]:https://www.terraform.io/docs/language/values/locals.html
[Named Values]:https://www.terraform.io/docs/language/expressions/references.html
[docs/prerequisites]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.adoc
[docs/terraformoptions]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.adoc
[docs/routing_rules]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/routing_rules.adoc
[Provisioning Infrastructure with Terraform]:https://www.terraform.io/docs/cli/run/index.html

This example illustrates how to use `terraform-oci-vcn` module to create a hub-and-spoke architecture for Transit Routing, using VCNs and Local Peering Gateways.

Tree VCN are created:

- One Hub VCN, with one LPG and one DRG
- Two Spoke VCN, wtih one LPG each

[WIP: more details on the configuration]

This diagram shows what will be created by this example.

[WIP: insert a diagram]

## How to xxx

[WIP: more details on how to declare a LPG for HUB or SPOKE]

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
