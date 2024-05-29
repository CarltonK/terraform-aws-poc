variable "workspace" {
  type        = string
  description = "Current Workspace Terraform is running in"
}

variable "cidr_block" {
  type        = string
  description = "Route"
}

# variable "region" {
#   type        = string
#   description = "Region containing assets"
# }