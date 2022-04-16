#----------
# Terraform
#----------
terraform {
  required_version = "0.13.2"
  backend "s3" {
    bucket  = "system-prod-deploy-tf-999999999"
    region  = "ap-northeast-1"
    key     = "tfstate"
    encrypt = true
  }
}


#----------
# Provider
#----------
provider "aws" {
  region = "ap-northeast-1"
}


#----------
# Remote State
#----------
data "terraform_remote_state" "XXX" {
  backend = "s3"

  config = {
    region = "ap-northeast-1"
    bucket = "system-prod-deploy-tf-999999999"
    key    = "tfstate.XXX"
  }
}


#----------
# Resource - Network
#----------
module "network" {
  source = "../../modules/network"

  # common
  system = "systemA"
  env    = "prod"
  # vpc
  vpc_cidr = "192.168.10.0/24"
  # flow_log
  flow_log_destination = data.terraform_remote_state.storage.outputs.s3_log_arn
  # subnet_public
  subnet_public_cidr = ["192.168.10.0/26", "192.168.10.64/26"]