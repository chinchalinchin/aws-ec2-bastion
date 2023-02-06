
output "bastion_ip" {
    description                             = "Elastic IP of EC2 bastion host"
    value                                   = aws_eip.bastion_ip.public_ip
}

output "bastion_security_group_id" {
    description                             = "Security Group ID containing EC2 bastion hsot"
    value                                   = aws_security_group.remote_access_sg.id                 
}