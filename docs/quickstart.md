# Quickstart

1. [Assumptions](#assumptions)
2. [Pre-requisites](#pre-requisites)
3. [Instructions](#instructions)
4. [Related documentation](#related-documentation)

### Assumptions

1. You have set up the [required keys](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm).
2. You know the [required OCIDs](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five).
3. You have the necessary permissions.

### Pre-requisites

1. `git` is installed.
2. Terraform 1.0.0+ is installed.
3. Understanding of the Oracle Cloud Infrastructure (OCI) Virtual Cloud Networking (VCN) service.

### Instructions

#### Provisioning using this git repo

1. Clone the repo:

```bash
git clone https://github.com/oracle-terraform-modules/terraform-oci-vcn.git tfvcn

cd tfvcn

cp terraform.tfvars.example terraform.tfvars
```

2. Create a `provider.tf` file and add the following:

```hcl
provider "oci" {
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.api_fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
}
```

Provider credentials are intentionally configured in `provider.tf`, not in `terraform.tfvars.example`.

3. Set mandatory provider parameters:

- `api_fingerprint`
- `api_private_key_path`
- `region`
- `tenancy_id`
- `user_id`

4. Set other required parameters:

- `compartment_id`

5. Select the gateways to create:

- `create_internet_gateway`
- `create_nat_gateway`
- `create_service_gateway`

6. Optional parameters to override:

- `label_prefix`
- `vcn_cidrs`
- `vcn_name`
- `vcn_dns_label`
- `lockdown_default_seclist`
- `attached_drg_id`
- `enable_ipv6` and the IPv6 parameters documented in [Terraform Options](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.md#ipv6-parameters)

7. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

8. Retrieve the VCN and gateways information:

```bash
terraform output vcn_id
terraform output internet_gateway_id
terraform output nat_gateway_id
terraform output service_gateway_id
```

### Related documentation

- [All Terraform configuration options](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.md) for [this project](https://github.com/oracle-terraform-modules/terraform-oci-vcn)
