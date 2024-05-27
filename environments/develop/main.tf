provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source     = "../../modules/vpc"
  workspace  = var.workspace
  cidr_block = var.cidr_block
}
