## Creating a VCN

[uri-terraform-options]: ./chapter_5.md
[uri-oci-keys]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two
[uri-oci-ocids]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five
### Assumptions

1. You have setup the [required keys][uri-oci-keys]
2. You know the [required OCIDs][uri-oci-ocids]
3. You have the necessary permissions

### Pre-requisites

1. Git is installed
2. SSH client is installed
3. Terraform 1.3.0 or greater is installed

### Instructions

#### Provisioning using this git repo

1. Clone the repo:

```bash
git clone https://github.com/oracle-terraform-modules/terraform-oci-vcn.git tfvcn

cd tfvcn

cp terraform.tfvars.example terraform.tfvars
```

2. Create a provider.tf file and add the following:

```
provider "oci" {
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  region               = var.region
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
}

# provider identity parameters
variable "api_fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
}

variable "api_private_key_path" {
  description = "path to oci api private key used"
  type        = string
}

variable "tenancy_id" {
  description = "tenancy id where to create the sources"
  type        = string
}

variable "user_id" {
  description = "id of user that terraform will use to create the resources"
  type        = string
}
```

3. Set mandatory provider parameters in terraform.tfvars:

* `api_fingerprint`
* `api_private_key_path`
* `region`
* `tenancy_id`
* `user_id`

4. Override other parameters in terraform.tfvars:

* `compartment_id`
* `label_prefix`
* `vcn_name`

5. Optional parameters to override:

* `create_internet_gateway`
* `create_nat_gateway`
* `create_service_gateway`
* `freeform_tags`
* `attached_drg_id`
* `vcn_dns_label`

6. Run Terraform:

```
terraform init
terraform plan
terraform apply
```