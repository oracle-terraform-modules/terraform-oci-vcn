# Terraform Options

Configuration Terraform Options:

1. [Provider](#provider)
2. [General OCI](#general-oci)
3. [VCN Parameters](#vcn-parameters)
4. [IPv6 Parameters](#ipv6-parameters)
5. [Gateway Parameters](#gateway-parameters)
6. [Subnet Parameters](#subnet-parameters)
7. [Logging Parameters](#logging-parameters)
8. [Tagging Parameters](#tagging-parameters)
9. [IPv6 Behavior](#ipv6-behavior)
10. [Outputs](#outputs)
11. [Validation Rules](#validation-rules)

## Provider

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `region` | Region where to provision the vcn. List of regions. Required. | string | None |

## General OCI

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `compartment_id` | Compartment id where the VCN will be provisioned. Required. | string | None |
| `label_prefix` | A string to be prepended to the names of resources. | string | `none` |
| `tenancy_id` | Tenancy OCID. Required. | string | None |

## VCN Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `vcn_name` | (Updatable) The name of the VCN that will be appended to the label_prefix. | string | `vcn` |
| `vcn_cidrs` | (Updatable) The list of IPv4 CIDR blocks the VCN will use. The CIDR block must not overlap with the CIDR block of another network. | list(string) | `["10.0.0.0/16"]` |
| `vcn_dns_label` | A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN). DNS resolution for hostnames in the VCN is disabled when null. | string | `vcnmodule` |
| `lockdown_default_seclist` | Whether to remove all default security rules from the VCN Default Security List. | `true` / `false` | `true` |
| `create_internet_gateway` | Whether to create an Internet Gateway. | `true` / `false` | `false` |
| `create_nat_gateway` | Whether to create a NAT gateway. | `true` / `false` | `false` |
| `create_service_gateway` | Whether to create a service gateway to use Oracle Services. | `true` / `false` | `false` |
| `attached_drg_id` | DRG OCID to be attached to the VCN. | string | None |

## IPv6 Parameters

The following variables control the IPv6 capabilities added to the module. They are only effective when `enable_ipv6 = true`.

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `enable_ipv6` | Whether IPv6 is enabled for the VCN. If enabled, Oracle will assign the VCN a IPv6 /56 CIDR block. | `true` / `false` | `false` |
| `vcn_is_oracle_gua_allocation_enabled` | If Oracle will assign the VCN a IPv6 /56 CIDR block (Global Unicast Address) when IPv6 is enabled. Set to `false` to rely only on BYOIPv6 or private IPv6 blocks. | `true` / `false` | `true` |
| `vcn_ipv6private_cidr_blocks` | List of IPv6 private CIDR blocks to be used for the VCN. Used as the fallback source for subnet `ipv6cidr_blocks` shorthand derivation. | list(string) | `[]` |
| `vcn_byoipv6cidr_details` | List of BYOIPv6 CIDR blocks to be used for the VCN. Each entry must provide `byoipv6range_id` and `ipv6cidr_block`. | list(object) | `[]` |

## Gateway Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `internet_gateway_display_name` | (Updatable) Name of Internet Gateway. Does not have to be unique. | string | `internet-gateway` |
| `nat_gateway_display_name` | (Updatable) Name of NAT Gateway. Does not have to be unique. | string | `nat-gateway` |
| `service_gateway_display_name` | (Updatable) Name of Service Gateway. Does not have to be unique. | string | `service-gateway` |
| `nat_gateway_public_ip_id` | OCID of reserved IP address for NAT gateway. Use `none` to pick a public IP from Oracle's public IP pool, or `RESERVED` to provision a reserved public IP. | string | `none` |
| `internet_gateway_route_rules` | (Updatable) List of routing rules to add to Internet Gateway Route Table. `network_entity_id` accepts `drg`, `internet_gateway`, `lpg@<key>` or a literal OCID. | list(map(string)) | None |
| `nat_gateway_route_rules` | (Updatable) List of routing rules to add to NAT Gateway Route Table. `network_entity_id` accepts `drg`, `nat_gateway`, `lpg@<key>` or a literal OCID. | list(map(string)) | None |
| `local_peering_gateways` | Map of Local Peering Gateways to attach to the VCN. Each entry may set `route_table_id`, `peer_id`, etc. | map(any) | None |

## Subnet Parameters

When `enable_ipv6 = true`, each subnet's `ipv6cidr_blocks` entry can be either an explicit IPv6 CIDR or a shorthand `"newbits, netnum"` string. Shorthand entries are derived with `cidrsubnet()` from the first VCN IPv6 CIDR block, using Oracle-assigned / BYO public IPv6 blocks first and `vcn_ipv6private_cidr_blocks` as the fallback source.

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `subnets` | Map of subnets to be created in the VCN. Each entry supports `cidr_block`, `name`, `dns_label`, `type` (`public`/`private`), `availability_domain`, `ipv6cidr_blocks`, `route_table_id`, `prohibit_internet_ingress`. | any | `{}` |

Supported attributes per subnet entry:

| Attribute | Description |
| --- | --- |
| `cidr_block` | IPv4 CIDR block for the subnet. |
| `name` | Display name. Defaults to the map key. |
| `dns_label` | Optional DNS label for the subnet. |
| `type` | `public` (default) routes through the Internet Gateway; `private` routes through the NAT Gateway. |
| `availability_domain` | 1-based AD number. |
| `ipv6cidr_blocks` | List of explicit IPv6 CIDRs or `"newbits, netnum"` shorthand entries (only used when `enable_ipv6 = true`). |
| `route_table_id` | Optional explicit route table OCID. When set, overrides the default routing based on `type`. Use this to attach a subnet to the dual-stack `nat_ipv4_igw_ipv6` route table. |
| `prohibit_internet_ingress` | Optional. When omitted, defaults to `false` for public subnets with IPv6 enabled, `true` otherwise. |

## Logging Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `enable_vcn_logging` | Enable or Disable VCN flow logging. | `true` / `false` | `false` |
| `log_retention_duration` | Log retention duration in days. | number | `30` |

## Tagging Parameters

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `freeform_tags` | Simple key-value pairs to tag the created resources using freeform OCI tags. | map(any) | `{ terraformed = "Please do not edit manually", module = "oracle-terraform-modules/vcn/oci" }` |
| `defined_tags` | Predefined and scoped to a namespace to tag the resources created using defined tags. | map(string) | None |

## IPv6 Behavior

When `enable_ipv6 = true`, the module automatically:

- Enables IPv6 on the VCN with `is_oracle_gua_allocation_enabled` and `ipv6private_cidr_blocks`, and attaches any `vcn_byoipv6cidr_details` blocks.
- Adds a default IPv6 route (`::/0`) to the Internet Gateway route table.
- Adds IPv6 rules to the VCN Default Security List (egress `::/0`, SSH from `::/0`, and ICMPv6 type 2 code 0 Packet Too Big from `::/0`). The IPv6 rules are only added when the Default Security List is not in lockdown.
- Creates an additional dual-stack route table named `<nat-gateway>-ipv4-igw-ipv6` when **both** an Internet Gateway and a NAT Gateway are created and a public IPv6 block is available (`vcn_is_oracle_gua_allocation_enabled = true` or `vcn_byoipv6cidr_details` is non-empty). This route table routes IPv4 (`0.0.0.0/0`) through the NAT Gateway and IPv6 (`::/0`) through the Internet Gateway. Attach subnets to it via their `route_table_id` attribute, using the `nat_ipv4_igw_ipv6_route_id` module output.

Subnet `ipv6cidr_blocks` shorthand derivation:

- `"newbits, netnum"` is expanded with `cidrsubnet(<first VCN IPv6 CIDR>, newbits, netnum)`.
- Oracle-assigned GUA / BYO public IPv6 blocks are consumed first; `vcn_ipv6private_cidr_blocks` is used as the fallback source.

## Outputs

| Output | Description |
| --- | --- |
| `vcn_id` | id of the VCN that is created. |
| `nat_gateway_id` | id of NAT gateway if it is created. |
| `internet_gateway_id` | id of Internet gateway if it is created. |
| `service_gateway_id` | id of Service gateway if it is created. |
| `ig_route_id` | id of the Internet Gateway route table. |
| `nat_route_id` | id of the VCN NAT gateway route table. |
| `nat_ipv4_igw_ipv6_route_id` | id of the dual-stack route table using NAT gateway for IPv4 and Internet Gateway for IPv6. Empty unless `enable_ipv6 = true` with both an Internet Gateway and a NAT gateway and a public IPv6 block. |
| `sgw_route_id` | id of the VCN Service gateway route table. |
| `subnet_id` | id of the created subnet (first one, if any). |
| `default_security_list_id` | id of the VCN Default Security List. |
| `*_all_attributes` | Map with all attributes of each created resource (`internet_gateway`, `ig_route`, `lpg`, `nat_gateway`, `nat_route`, `nat_ipv4_igw_ipv6_route`, `service_gateway`, `vcn`, `subnet`). Useful for module composition. |

## Validation Rules

- `compartment_id`, `tenancy_id` and `region` are required.
- `vcn_name`, `internet_gateway_display_name`, `nat_gateway_display_name` and `service_gateway_display_name` cannot be empty strings.
- `vcn_dns_label`, when not null, must be an alphanumeric string of 1 to 15 characters beginning with a letter.
- The dual-stack `nat_ipv4_igw_ipv6` route table is created only when `enable_ipv6 = true`, `create_internet_gateway = true`, `create_nat_gateway = true` and a public IPv6 block is available (`vcn_is_oracle_gua_allocation_enabled = true` or `vcn_byoipv6cidr_details` is non-empty).
- Subnet `ipv6cidr_blocks` shorthand entries are only derived when `enable_ipv6 = true`; explicit IPv6 CIDRs are passed through unchanged.
