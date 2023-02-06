module "compute" {
  source                          = "./modules/compute"

  bastion_config                  = var.bastion_config
  cidr_block                      = [ 
                                    data.aws_vpc.vpc.cidr_block 
                                  ]
  source_ips                      = var.source_ips
  project                         = var.project
  vpc_config                      = var.vpc_config
}