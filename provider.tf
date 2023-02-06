terraform {
  required_version = ">= 1.2.6" 
  
  backend "s3" {
    bucket = "automation-library-terraform-state"
    region = "us-east-1"
    dynamodb_table = "automation-library-terraform-state-locks"
    encrypt = "true"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
    time = {
      source = "hashicorp/time"
      version = "~>0.7.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  region = var.region

  ### Commented out For Demo - Use this Block for integration into an existing Terraform implementation if you already have predefined role ###

  # assume_role {
  #     role_arn = "arn:aws:iam::${var.target_account_id}:role/${var.target_role_name}"
  #     session_name = "Terraform"
  # }
}