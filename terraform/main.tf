terraform {
  # required_version = ">= 0.14.8"
  required_version = "~> 1.0"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"

    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }

}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
