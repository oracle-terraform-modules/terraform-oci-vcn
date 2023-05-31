## Configuring routing rules

[uri-tf-namedvalues]: https://www.terraform.io/docs/language/expressions/references.html
[uri-oci-lpg]: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_local_peering_gateway
[uri-custom-route-rules]: https://github.com/oracle-terraform-modules/terraform-oci-vcn/tree/main/examples/custom_route_rules

When you create an Internet or a NAT gateway, the terraform-oci-vcn module automatically creates a dedicated route table for each gateway:

- `<label_prefix>-internet-route` route table is created if `create_internet_gateway = true`
- `<label_prefix>-nat-route` route table is created if `create_nat_gateway = true`

These automatically created route tables comes with automatic rules, that cannot be controlled by the module user.

### internet-route route table

internet-route is meant to be attached to public subnets you provision. It comes with one automatic/non-editable rule that redirects all unknown destination to the Internet Gateway created by this module: `0.0.0.0/0 --> Internet Gateway`.

### nat-route route table

nat-route table is meant to be attached to private subnets you provision. It comes with one automatic/non-editable rule that redirects all unknown destination to the NAT Gateway created by this module: `0.0.0.0/0 --> NAT Gateway`.

If a Service Gateway is also created by the module with `create_service_gateway = true`, a second rule is added to redirect all Oracle Network Services traffic to the Service Gateway created by this module: `All <REGION> services in OSN --> Service Gateway`

### Custom routes

terraform-oci-vcn module have two optional Input Variables to inject user-defined route rules into `internet-route` and `nat-route` route tables using respectively:

- `internet_gateway_route_rules` defined as a `list(map(string))` with the following expected schema:

```
variable "internet_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to Internet Gateway Routing Table"
  type = list(object({
    destination       = string # required
    destination_type  = string # required
    network_entity_id = string # required
    description       = string # optional
  }))
  default = null
}
```

- `nat_gateway_route_rules` defined as a `list(map(string))` with the following expected schema:

```
variable "nat_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to NAT Gateway Routing Table"
  type = list(object({
    destination       = string # required
    destination_type  = string # required
    network_entity_id = string # required
    description       = string # optional
  }))
  default = null
}
```

They share the same schema but each Input Variable controls the associated route table:

- `destination` accept string value and represent the CIDR that will be affected by the rule,
- `destination_type` accept string value, with `CIDR_BLOCK` or `SERVICE_CIDR_BLOCK` as valid values,
- `network_entity_id` accept string value and represent the gateway to be the target of the rule,
- `description` accept arbitrary string value and give context about the goal of the rule.

#### Special values for `network_entity_id`

For routing rules targeting a gateway created by the module, `network_entity_id` accepts some special strings to automatically retrieve the gateway OCID.

- `internet_gateway_route_rules` and `nat_gateway_route_rules` recognise the `"drg"` string and resolve it to the Dynamic Routing Gateway(DRG) OCID attached to the module (if available),
- `internet_gateway_route_rules` recognise the `"internet_gateway"` string and resolve it to the Internet Gateway OCID created by the module,
- `nat_gateway_route_rules` recognise the `"nat_gateway"` string and resolve it to the NAT Gateway OCID created by the module.

#### Generic values for `network_entity_id`

If you need to create a routing rule with a target gateway created outside of the module, you can simply provide the resource OCID using a valid Terraform method (any [named value][uri-tf-namedvalues]).

### Examples

For example configuration using this option, see [custom route rules][uri-custom-route-rules].
