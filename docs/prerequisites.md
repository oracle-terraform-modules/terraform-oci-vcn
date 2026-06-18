# Pre-requisites

[Quick Start guide](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/quickstart.md)

This section will guide you through the pre-requisites before you can use this project.

You can proceed to the [Quick Start guide](https://github.com/oracle-terraform-modules/terraform-oci-vcn/blob/main/docs/quickstart.md) if you have already done these.

1. Local development tools: [Git](https://git-scm.com/), [Terraform](https://www.terraform.io), a terminal.
2. Understanding of Oracle Cloud Infrastructure (OCI) and its services, in particular the Virtual Cloud Networking (VCN) service.

### Generate and upload your OCI API keys

Follow the documentation for [generating and uploading your API keys](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two).

Note the key fingerprint.

### Create an OCI compartment

Follow the documentation for [creating a compartment](https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm#two).

### Obtain the necessary OCIDs

The following OCIDs are required:

1. Compartment OCID
2. Tenancy OCID
3. User OCID

Follow the documentation for [obtaining the tenancy and user OCIDs](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five).

To obtain the compartment OCID:

1. Navigate to `Identity > Compartments`.
2. Click on your compartment.
3. Locate `OCID` on the page and click `Copy`.

### Configuring Policies

1. Create a group (e.g. mygroup) and add a user to the group.
2. Create a policy:

   ```text
   Allow group mygroup to manage virtual-network-family in compartment id  ocid1.compartment.oc1..aaa
   ```
