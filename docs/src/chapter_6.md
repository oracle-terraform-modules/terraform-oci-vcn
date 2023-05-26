## VCN Gateways

[uri-tf-namedvalues]: https://www.terraform.io/docs/language/expressions/references.html
[uri-oci-lpg]: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_local_peering_gateway
[uri-oci-lpg-concepts]: https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/localVCNpeering.htm#Importan
[uri-oci-transit-routing]: https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/transitrouting.htm
[uri-hub-spoke]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/examples/hub-spoke

### Local Peering Gateways

Local Peering Gateways are used to establish a single peering relationship between two VCNs. For more information about how Local Peering works on OCI, see [Important Local Peering concepts][uri-oci-lpg-concepts] and [Transit Routing][uri-oci-transit-routing].

The VCN module allows you to declare several LPG using the module's `local_peering_gateways` variable Input:

- each key of `local_peering_gateways` is an LPG.
- the key is the LPG's display name.
- you can optionally declare a `route_table_id` to be attached to the LPG. This is useful on to create a Hub VCN for Transit Routing.
- you can optionally declare a `peer_id`, so your module will act as a requestor and trigger the peering processus (to be used either in the hub vcn module or the spoke vcn module, but not both).

### Using the module outputs to retrieve an LPG OCID

You can dynamically retrieve the OCID of an LPG created with this module using the module's `lpg_all_attributes` output: `module.*<module_name>*.lpg_all_attributes["*<lpg_key>*"]["id"]`.

This is particularly useful when both VCNs to be peered are in the same Terraform configuration and created using this module.

### Generic values for `route_table_id` or `peer_id`

If you need to attach a Routing Table or peer with an LPG created outside of the VCN module, you can simply provide the resource OCID using a valid Terraform method (any {uri-tf-namedvalues}[Named Value]).

### Examples

This is an example that shows how to declare LPGs in three different ways:

```hcl
module "vcn_hub" {
  ...
  local_peering_gateways = {
    to_spoke1 = {
      // this LPG will have a Route Table associated with it
      route_table_id = oci_core_route_table.VTR_spokes.id
    }
    to_spoke2 = {
      // this LPG will have a Route Table associated with it and the peering connection will be established (requestor mode)
      route_table_id = oci_core_route_table.VTR_spokes.id
      peer_id = module.vcn_spoke2.lpg_all_attributes["to_hub"]["id"]
    }
    to_spoke3 = {}
      // this LPG will be created without any Route Table associated, and ready to be peered (acceptor mode)
  }
}
```

See the [hub-and-spoke example][uri-hub-spoke] that for more details on how to use this feature.
