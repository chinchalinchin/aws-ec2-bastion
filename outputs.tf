## Root Outputs ###
output "bastion_ip" {
    description                             = "Elastic IP of EC2 bastion hsot"
    value                                   = module.compute.bastion_ip
}

output "bastion_security_group_id" {
    description                             = "Security Group ID containing EC2 bastion hsot"
    value                                   = module.compute.bastion_security_group_id
}