
output "bastion_ip" {
    description                             = "Elastic IP of EC2 bastion host"
    value                                   = var.bastion_config.public ? aws_eip.bastion_ip[0].public_ip : null
}

output "bastion_security_group_id" {
    description                             = "Security Group ID for IP whitelist into EC2 bastion host"
    value                                   = aws_security_group.remote_access_sg.id                 
}