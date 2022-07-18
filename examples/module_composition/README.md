# Example reusing terraform-oci-vcn and extending to create other network resources

[rootvariables]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/examples/module_composition/variables.tf
[sampletfvars]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/examples/module_composition/terraform.tfvars.example
[terraformoptions]:https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/terraformoptions.adoc
[terraform-oci-vcn]:https://registry.terraform.io/modules/oracle-terraform-modules/vcn/oci/latest

__Note: This is an example to demonstrate reusing this Terraform module to create additional network resources. Ensure you evaluate your own security needs when creating security lists, network security groups etc.__

## Create a new Terraform project

As an example, we’ll be using [terraform-oci-vcn] to create
additional network resources in the VCN. The steps required are the following:

1. Create a new directory for your project e.g. mynetwork

2. Create the following files in root directory of your project:

- `variables.tf`
- `locals.tf`
- `provider.tf`
- `main.tf`
- `terraform.tfvars`

3. Define the oci provider

```HCL
provider "oci" {
  tenancy_ocid         = var.tenancy_id
  user_ocid            = var.user_id
  fingerprint          = var.api_fingerprint
  private_key_path     = var.api_private_key_path
  region               = var.region
  disable_auto_retries = false
}
```

## Define project variables

### Variables to reuse the vcn module

1. Define the vcn parameters in the root `variables.tf`.
See an example for [`variables.tf`][rootvariables].

2. Add additional variables if you need to.

## Define your modules

1. Define the vcn module in root `main.tf`

```HCL
module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # vcn parameters
  create_internet_gateway = var.create_internet_gateway
  create_nat_gateway      = var.create_nat_gateway
  create_service_gateway  = var.create_service_gateway
  tags                     = var.freeform_tags
  vcn_cidrs                = var.vcn_cidrs
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name
  lockdown_default_seclist = var.lockdown_default_seclist
  attached_drg_id          = var.attached_drg_id
}
```

2. Enter appropriate values for `terraform.tfvars`. Review [Terraform Options][terraformoptions] for reference.
You can also use this example [terraform.tfvars][sampletfvars]. Just remove the `.example` extension.

## Add your own modules

1. Create your own module e.g. subnets. In modules directory, create a subnets directory:

```shell
mkdir subnets
```

2. Define the additional variables(e.g. subnet masks) in the root and module variable file (`variables.tf`) e.g.

```HCL
variable "netnum" {
  description = "zero-based index of the subnet when the network is masked with the newbit. use as netnum parameter for cidrsubnet function"
  default = {
    bastion = 32
    web     = 16
  }
  type = map
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = {
    bastion = 13
    web     = 11
  }
  type = map
}
```

3. Create the security lists and subnets in `security.tf` and `subnets.tf` respectively in the subnets module:

```HCL
resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-bastion"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    # allow ssh
    protocol = 6
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
  vcn_id = var.vcn_id
}

resource "oci_core_security_list" "web" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-web"

  egress_security_rules {
    protocol    = "all"
    destination = "all"
  }

  ingress_security_rules {
    # allow ssh
    protocol = 6

    source = "0.0.0.0"

    tcp_options {
      min = 80
      max = 80
    }
  }
  vcn_id         = var.vcn_id
}

resource "oci_core_subnet" "bastion" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, var.newbits["bastion"], var.netnum["bastion])
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-bastion"
  dns_label                  = "bastion"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.bastion.id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "web" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, var.newbits["web"], var.netnum["web])
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-web"
  dns_label                  = "web"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.web.id]
  vcn_id                     = var.vcn_id
}
```

4. Add the subnets module in the `main.tf`

```HCL
module "subnets" {
  source = "./modules/subnets"

  netnum  = var.netnum
  newbits = var.newbits

  # other required variables
  .
  .
  .
}
```

5. Update your terraform variable file and add the database parameters:

```HCL
# subnets

netnum = {
  bastion = 32
  web     = 16
}

newbits = {
  bastion = 13
  web     = 11
}
```
