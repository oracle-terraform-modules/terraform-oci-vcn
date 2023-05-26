## Pre-requisites

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

Follow the documentation for [obtaining the tenancy and user ocids][uri-oci-ocids].

To obtain the compartment OCID:

1. Navigate to Identity > Compartments
2. Click on your Compartment
3. Locate OCID on the page and click on `Copy`

### Policies

[uri-oci-compartment]: https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm#two
[uri-oci-keys]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two
[uri-oci-ocids]: https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five