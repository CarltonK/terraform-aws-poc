provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ec2" {
  source     = "../../modules/ec2"
  workspace  = var.workspace
  cidr_block = var.cidr_block
  region     = var.region
}
