data "aws_caller_identity" "current" {}


data "aws_region" "current" {}


data "aws_ecr_authorization_token" "token" { }


data "aws_vpc" "vpc" {
    id                                                  = var.vpc_config.id
}