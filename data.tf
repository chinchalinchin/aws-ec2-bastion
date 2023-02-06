data "aws_vpc" "vpc" {
    id                                                  = var.vpc_config.id
}