terraform {
  required_version = "~> 1.0.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}
