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

Three VCN will be created:

- One Hub VCN with 3 LPG and 1 Route Table
- The Route Table on HUB VCN is attached to the first and second HUB LPG
- Three Spoke VCN, with one LPG each
- Spoke1 and Spoke2 are automatically peered with HUB VCN
- Spoke3 VCN is not peered

This diagram illustrates what will be created by this example.

![diagram](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/images/hub-spoke-lpg.png?raw=true&sanitize=true)

## How to declare one or many LPG on the vcn module

You can declare several LPG using the module's Variable Input `local_peering_gateways` (type: map of maps):

- each key of `local_peering_gateways` is an LPG
- the key is the LPG's display name
- you can optionally declare a `route_table_id` to be attached to the LPG (useful on HUB VCN for Transit Routing)
- you can optionally declare a `peer_id`, so your module will act as a requestor and establish the LPG peering (either in the hub vcn module or the spoke vcn module, but not both to).

This is an example that shows three ways to declare an LPG:

```HCL
module "vcn_hub" {
  ...
  local_peering_gateways = {
    to_spoke1 = {
      route_table_id = oci_core_route_table.VTR_spokes.id
    }
    to_spoke2 = {
      route_table_id = oci_core_route_table.VTR_spokes.id
      peer_id = module.vcn_spoke2.lpg_all_attributes["to_hub"]["id"]
    }
    to_spoke3 = {}
  }
}
```

The `peer_id` argument accept any valid string (OCI API is expecting an LPG OCID). The example for LPG named `to_spoke_2` shows how to use the vcn module outputs to dynamically retrieve a valid value.

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
