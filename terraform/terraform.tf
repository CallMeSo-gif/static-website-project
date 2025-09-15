# This block configures Terraform to run in the HCP Terraform cloud
terraform {
  cloud {
    organization = "Projects-tests" # Found in your HCP settings

    workspaces {
      name = "static-website-project"
    }
  }
}
