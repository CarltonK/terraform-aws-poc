provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "../../modules/vpc"
  workspace  = var.workspace
  cidr_block = var.cidr_block
}
