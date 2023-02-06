# aws-ec2-bastion

Refer to [raw docs](./docs/source/OVERVIEW.md) or [hosted docs](https://pages.github.boozallencsn.com/AutomationLibrary/aws-ec2-bastion/) for more information.

## Quickstart

1. Configure the **Terraform** backend in the _provider.tf_ file. By default, it points to the **AutomationLibrary** **S3** **Terraform** state bucket. If using a remote state, adjust appropriately, or if you are using a local state, comment out the `backend` block.
   
2. Adjust the _.tfvars_ file to your environment. In particular, the `source_ips` variable will need set. See next section for more information.


3. Deploy the modules,

``` shell
terraform init
terraform plan --var-file .tfvars
terraform apply --var-file .tfvars
```

## Configuration

### EC2 OS Image

By default, the EC2 Bastion Host uses an **ubuntu 16** image located in the `us-east-1`. The default username for this distro is `ubuntu`. If you want need a different OS image or need an image in a different region, refer to the [EC2 Ubuntu Catalogue](https://cloud-images.ubuntu.com/locator/ec2/).

The AMI image can be edited by setting overriding the `bastion_config.ami` variable.

### Source IPS

A security group is created around the EC2 bastion host and all access is explicitly denied. To access the EC2, you will need to add your IP to the whitelist. You can pass your IP and any other IPs that need whitelisted in through the `source_ips` list variable.

## Connect to EC2 Bastion Host

The Elastic IP of the bastion host can be easily retrieved with `terraform output`. 

The SSH key used to connect to the bastion host is output into the */keys/* directory (this files in this directory are excluded in the *.gitignore* and will never be committed to version control). Ensure the `chmod` permissions are set to 600 on the generated key,

```shell
chmox 600 ./keys/data_ops_key
```

Then you can connect to the EC2 with the following command,

```shell
ssh -i ./keys/data_ops_key ubuntu@<bastion-ip>
```
