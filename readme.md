# Terraform using azure

## How to use it

There are three steps to build infrastructure with Terraform:

Initialize the Terraform configuration directory using `terraform init`
Create an execution plan using `terraform plan`
Create or modify infrastructure using `terraform apply`

## Tasks to Create

 - Resource group
 - Network Security Group
 - Virtual machines


## Destroying Resources

Resources can be destroyed using the `terraform destroy` command. You'll use terraform destroy in this tutorial to remove infrastructure between lessons, and when you're finished with the guide

```
terraform plan -destroy
```

### References

Terraform Azure Provider
- https://www.terraform.io/docs/providers/azurerm/index.html

Azure Get Started
- https://learn.hashicorp.com/terraform/azure/build_az

Youtube References
- https://www.youtube.com/watch?v=OAWBHyNKrzw
