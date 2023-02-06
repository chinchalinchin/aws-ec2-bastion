locals {
    default_access_cidr                                 = [ 
                                                            "0.0.0.0/0" 
                                                        ]
    # `ec2_*` locals configure the bastion host, not the EKS node group instance attributes.
    ec2_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "data-ops-infrastructure"
                                                            Owned           = "bah-625518"
                                                            Service         = "ec2"
                                                        }
    ec2_type                                            = "t3.xlarge"
    kms_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "data-ops-infrastructure"
                                                            Owned           = "bah-625518"
                                                            Service         = "kms"
                                                        }
    ssh_key_algorithm                                   = "RSA"
    ssh_key_bits                                        = 4096
}