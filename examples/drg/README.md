# Creating a DRG

[docs/prerequisites]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/prerequisites.adoc
[Provisioning Infrastructure with Terraform]:https://www.terraform.io/docs/cli/run/index.html

This example illustrates how to use  `terraform-drg-module` to create an hub and spoke configuration.



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
