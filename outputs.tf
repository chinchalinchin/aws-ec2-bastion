## Root Outputs ###
output "bastion_ip" {
    description                             = "Elastic IP of EC2 bastion host, if enabled."
    value                                   = module.compute.bastion_ip
}

output "bastion_security_group_id" {
    description                             = "Security Group ID for IP whitelist into EC2 bastion host"
    value                                   = module.compute.bastion_security_group_id
}