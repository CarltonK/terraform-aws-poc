variable "region" {
  type        = string
  description = "Region containing assets"
}

variable "workspace" {
  type        = string
  description = "Current Workspace Terraform is running in"
}

variable "cidr_block" {
  type        = string
  description = "Route"
}

variable "access_key" {
  type        = string
  description = "Access Key"
}

variable "secret_key" {
  type        = string
  description = "Secret Key"
}

