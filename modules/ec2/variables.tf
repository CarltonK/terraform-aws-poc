variable "workspace" {
  type        = string
  description = "Current Workspace Terraform is running in"
}

variable "cidr_block" {
  type        = string
  description = "Route"
}

variable "ami_id" {
  type        = string
  description = "ID of the Amazon Machine Image"
  default     = "ami-0a1e9fbebda761cdc"
}

variable "instance_machine_type" {
  type        = string
  description = "The Machine Type of the EC2 Instance"
  default     = "t2.micro"
}

# variable "region" {
#   type        = string
#   description = "Region containing assets"
# }
