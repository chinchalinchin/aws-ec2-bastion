resource "aws_key_pair" "ssh_key" {
    count                                               = var.bastion_config.key_name == null ? 1 : 0

    key_name                                            = "${var.project}_key"
    public_key                                          = tls_private_key.rsa[0].public_key_openssh
}


resource "tls_private_key" "rsa" {
    count                                               = var.bastion_config.key_name == null ? 1 : 0

    algorithm                                           = local.ssh_key_algorithm
    rsa_bits                                            = local.ssh_key_bits
}


resource "local_file" "tf-key" {
    count                                               = var.bastion_config.key_name == null ? 1 : 0

    content                                             = tls_private_key.rsa[0].private_key_pem
    filename                                            = "${path.root}/keys/${var.project}_key"
}


resource "aws_security_group" "remote_access_sg" {
    name                                                = "${var.project}-bastion-remote-access"
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
    count                                               = var.bastion_config.public ? 1 : 0

    vpc                                                 = true
    tags                                                = local.ec2_tags
}


resource "aws_eip_association" "eip_assoc" {
    count                                               = var.bastion_config.public ? 1 : 0

    instance_id                                         = aws_instance.bastion_host.id
    allocation_id                                       = aws_eip.bastion_ip[0].id
}

resource "aws_instance" "bastion_host" {
    #checkov:skip=CKV_AWS_88: "EC2 instance should not have public IP."
    #   NOTE: Security restricts traffic to IP whitelist.    
    ami                                                 = var.bastion_config.ami
    associate_public_ip_address                         = var.bastion_config.public
    ebs_optimized                                       = true
    key_name                                            = var.bastion_config.key_name == null ? aws_key_pair.ssh_key[0].key_name : var.bastion_config.key_name
    iam_instance_profile                                = var.bastion_config.instance_profile
    instance_type                                       = local.ec2_type
    monitoring                                          = true 
    subnet_id                                           = var.vpc_config.subnet_id
    tags                                                = merge(
                                                            local.ec2_tags,
                                                            {
                                                                Name                = "${var.project}-bastion-host"
                                                            }
                                                        )
    user_data                                           = templatefile(
                                                            "${path.root}/scripts/ec2/user-data.sh",
                                                            {
                                                                AWS_DEFAULT_REGION  = "${data.aws_region.current.name}"
                                                                AWS_ACCOUNT_ID      = "${data.aws_caller_identity.account_id}"
                                                            }
                                                        )
    vpc_security_group_ids                              = concat(
                                                            [ aws_security_group.remote_access_sg.id ],
                                                            var.vpc_config.security_group_ids
                                                        )                                     

    metadata_options {
        http_endpoint                                   = "enabled"
        http_tokens                                     = "required"
    }

    root_block_device {
        encrypted                                       = true
    }
}