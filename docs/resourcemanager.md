# Using Resource Manager

[Overview](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm)
[Create Stack](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/managingstacksandjobs.htm)

Step by step instructions:

```bash
git clone https://github.com/oracle-terraform-modules/terraform-oci-vcn.git
zip terraform-oci-vcn.zip *.tf schema.yaml -x main.tf
```

1. Create a stack:
   ![Create Stack](./images/createstack.PNG)

2. Upload the zip file:
   ![Upload zip file](./images/uploadzip.PNG)

3. Configure variables as needed:
   ![Configure variables](./images/variable1.PNG)

4. Check the relevant boxes if you need gateways:
   ![Gateway variables](./images/variable2.PNG)

5. Review your stack:
   ![Review stack](./images/review.PNG)

6. Run Terraform plan and apply:
   ![Terraform plan](./images/tfplan.PNG)

7. Check the logs:
   ![Plan logs](./images/planlogs.PNG)
