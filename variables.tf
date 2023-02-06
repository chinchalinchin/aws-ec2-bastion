variable "source_ips" {
    description                         = "IPs to whitelist for remote ingress into the bastion host. These IPs will be added to the security group around the bastion host."
    type                                = list(string)
    sensitive                           = true
}


variable "vpc_config" {
    description                         = "VPC configuration for Bastion deployment."
    type = object({
        id                              = string
        public_subnet_ids               = list(string)
        private_subnet_ids              = list(string)
    })
    default = null
}

variable "bastion_config" {
    description                         = "Configuration for the bastion host deployed into public subnet of VPC. AMI defaults to us-east-1 Ubuntu 16.04. See the following to find the image in your region: https://cloud-images.ubuntu.com/locator/ec2/"
    type = object({
        ami                             = string
        key_name                        = string
        instance_profile                = string
    })
    default = {
        ami                             = "ami-0b0ea68c435eb488d"
        key_name                        = "automation_library_key"
        instance_profile                = "AWSRoleforEC2"
    }
}