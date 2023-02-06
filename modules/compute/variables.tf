variable "source_ips" {
    description                         = "IPs to whitelist for remote ingress into the bastion host. These IPs will be added to the security group around the bastion host."
    type                                = list(string)
    sensitive                           = true
}


variable "cidr_block" {
    description                         = "CIDR Block for VPC. Note: if deploying from main, this will be pulled from a Terraform data source. Otherwise, it must be inputted."
    type                                = any
    sensitive                           = true
}


variable "vpc_config" {
    description                         = "VPC configuration for Bastion deployment."
    type = object({
        id                              = string
        subnet_id                       = string
        security_group_ids              = list(string)
    })
    sensitive                           = true
}


variable "bastion_config" {
    description                         = "Configuration for the bastion host deployed into public subnet of VPC. AMI defaults to us-east-1 Ubuntu 16.04. See the following to find the image in your region: https://cloud-images.ubuntu.com/locator/ec2/. Note: if key_name is not provided, an SSH key will be provisioned in the local /keys/ folder and uploaded to EC2. Otherwise, ensure the key_name exists in the EC2 key ring. Note: if public is enabled, an Elastic IP will be provisioned and attached to the instance."
    type = object({
        ami                             = string
        instance_profile                = string
        key_name                        = string
        public                          = bool

    })
    default = {
        ami                             = "ami-0b0ea68c435eb488d"
        instance_profile                = "AWSRoleforEC2"
        key_name                        = null
        public                          = true
    }
}


variable "project" {
    description                         = "Name of the project. Used as a resource prefix"
    type                                = string
    default                             = "autolib"
}
