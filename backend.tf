terraform {
  backend "remote" {
    organization = "excelsior"

    workspaces {
      name = "netbox-aws-dev"
    }
  }
}

