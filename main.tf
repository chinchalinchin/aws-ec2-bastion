module "compute" {
  source                          = "./modules/compute"

  bastion_config                  = var.bastion_config
  source_ips                      = var.source_ips
  project                         = var.project
  vpc_config                      = var.vpc_config
}