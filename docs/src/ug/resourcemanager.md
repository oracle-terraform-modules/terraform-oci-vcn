## Using Resource Manager

[uri-rm-overview]: https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm
[uri-rm-stack]: https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/managingstacksandjobs.htm


- [Overview][uri-rm-overview]
- [Create Stack][uri-rm-stack]
- Step by Step Instructions


```
git clone https://github.com/oracle-terraform-modules/terraform-oci-vcn.git
zip terraform-oci-vcn.zip *.tf schema.yaml -x main.tf
```

1. ![Create Stack](./images/createstack.png)

2. Upload zip file:
![Upload zip file](./images/uploadzip.png)


3. Configure variables as per your needs:
![Upload zip file](./images/variables1.png)

4. Check the relevant boxes if you need gateways:
![Upload zip file](./images/variables2.png)

5. Review your stack:
![Upload zip file](./images/review.png)

6. Run Terraform plan and apply:
![Upload zip file](./images/tfplan.png)

7. Check the logs:
![Upload zip file](./images/planlogs.png)

