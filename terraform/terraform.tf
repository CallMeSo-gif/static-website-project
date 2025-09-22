# This block configures Terraform to run in the HCP Terraform cloud
terraform {
   backend "s3" {
    bucket = "remote-backend-tf-state-12345678"
    region = "us-west-1"
  }

  required_providers {
    random = {
        source  = "hashicorp/random"
        version = "~> 3.5.1"
    }
 }
}

