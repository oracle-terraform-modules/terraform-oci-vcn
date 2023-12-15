## Pre-requisites

1. Local development tools: [Git][uri-git], [Terraform][uri-terraform], a terminal.
2. Understanding of Oracle Cloud Infrastructure (OCI) and its services, in particular the Virtual Cloud Networking (VCN) service.

### Generate and upload your OCI API keys

Follow the documentation for [generating and uploading your API keys][uri-oci-keys].

Note the key fingerprint.

### Create an OCI compartment

Follow the documentation for [creating a compartment][uri-oci-compartment].

### Obtain the necessary OCIDs

The following OCIDs are required:

1. Compartment OCID
2. Tenancy OCID
3. User OCID

Follow the documentation for [obtaining the tenancy and user OCIDs][uri-oci-ocids].

To obtain the compartment OCID:

1. Navigate to Identity > Compartments
2. Click on your Compartment
3. Locate OCID on the page and click on `Copy`

### Configuring Policies

1. Create a group (e.g. mygroup) and add a user to the group.

2. Create a policy:

`Allow group mygroup to manage virtual-network-family in compartment id  ocid1.compartment.oc1..aaa `

[uri-oci-compartment]: https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm#two
[uri-oci-keys]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two
[uri-oci-ocids]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five

[uri-git]: https://git-scm.com/
[uri-terraform]: https://www.terraform.io