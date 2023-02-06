resource "aws_key_pair" "ssh_key" {
    key_name                                            = "data_ops_key"
    public_key                                          = tls_private_key.rsa.public_key_openssh
}


resource "tls_private_key" "rsa" {
    algorithm                                           = local.ssh_key_algorithm
    rsa_bits                                            = local.ssh_key_bits
}


resource "local_file" "tf-key" {
    content                                             = tls_private_key.rsa.private_key_pem
    filename                                            = "${path.root}/keys/data_ops_key"
}


resource "aws_security_group" "remote_access_sg" {
    name                                                = "data-ops-bastion-remote-access"
    description                                         = "data-ops bastion host security group"
    vpc_id                                              = var.vpc_config.id
    tags                                                = local.ec2_tags
}


resource "aws_security_group_rule" "remote_access_ingress" {
    description                                         = "Restrict data-ops access to IP whitelist and VPC CIDR block"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = concat(
                                                            var.source_ips,
                                                            var.cidr_block
                                                        )
    security_group_id                                   = aws_security_group.remote_access_sg.id
} 


resource "aws_security_group_rule" "remote_access_egress" {
    description                                         = "Allow all outgoing traffic"
    type                                                = "egress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = [
                                                            "0.0.0.0/0"
                                                        ]
    security_group_id                                   = aws_security_group.remote_access_sg.id
}


resource "aws_eip" "bastion_ip" {
    vpc                                                 = true
    tags                                                = local.ec2_tags
}


resource "aws_eip_association" "eip_assoc" {
    instance_id                                         = aws_instance.bastion_host.id
    allocation_id                                       = aws_eip.bastion_ip.id
}

resource "aws_instance" "bastion_host" {
    #checkov:skip=CKV_AWS_88: "EC2 instance should not have public IP."
    #   NOTE: Security restricts traffic to IP whitelist.    
    ami                                                 = var.bastion_config.ami
    associate_public_ip_address                         = true
    ebs_optimized                                       = true
    key_name                                            = aws_key_pair.ssh_key.key_name
    iam_instance_profile                                = var.bastion_config.instance_profile
    instance_type                                       = local.ec2_type
    monitoring                                          = true 
    subnet_id                                           = var.vpc_config.public_subnet_ids[0]
    tags                                                = merge(
                                                            local.ec2_tags,
                                                            {
                                                                Name                = "data-ops-bastion-host"
                                                            }
                                                        )
    user_data                                           = templatefile(
                                                            "${path.root}/scripts/ec2/user-data.sh",
                                                            {
                                                                AWS_DEFAULT_REGION  = "${data.aws_region.current.name}"
                                                                AWS_ACCOUNT_ID      = "${data.aws_caller_identity.account_id}"
                                                            }
                                                        )
    vpc_security_group_ids                              = [
                                                            aws_security_group.remote_access_sg.id
                                                        ]
                                                        

    metadata_options {
        http_endpoint                                   = "enabled"
        http_tokens                                     = "required"
    }

    root_block_device {
        encrypted                                       = true
    }
}