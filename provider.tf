provider "aws" {
    region    ="${var.vpc_region}"
    version   ="~> 2.35"
  
}
terraform {
  required_version    = "~> 0.12.0"
  
  backend "remote" {
    organization  = "AabhusanInc"
    workspaces {
      name        = "lms"
    }
  }
} 