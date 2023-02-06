locals {
    ec2_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ec2-bastion"
                                                            Owned           = "bah-625518"
                                                            Service         = "ec2"
                                                        }
    ec2_type                                            = "t3.xlarge"
    kms_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ec2-bastion"
                                                            Owned           = "bah-625518"
                                                            Service         = "kms"
                                                        }
    ssh_key_algorithm                                   = "RSA"
    ssh_key_bits                                        = 4096
}